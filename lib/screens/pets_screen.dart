import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pet.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  static const _savedPetsKey = 'pawhaven_saved_pets';

  String species = 'All';
  String query = '';
  List<Pet> savedPets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final storage = await SharedPreferences.getInstance();
    final storedValues = storage.getStringList(_savedPetsKey) ?? [];
    final loadedPets = <Pet>[];

    for (final value in storedValues) {
      try {
        loadedPets.add(Pet.fromJson(Map<String, dynamic>.from(jsonDecode(value) as Map)));
      } on FormatException {
        // Ignore a damaged saved item and load the remaining pets.
      }
    }

    if (mounted) {
      setState(() => savedPets = loadedPets);
    }
  }

  Future<void> _savePets() async {
    final storage = await SharedPreferences.getInstance();
    final values = savedPets.map((pet) => jsonEncode(pet.toJson())).toList();
    await storage.setStringList(_savedPetsKey, values);
  }

  @override
  Widget build(BuildContext context) {
    final allPets = [...pets, ...savedPets];
    final visiblePets = allPets.where((pet) {
      final matchesSpecies = species == 'All' || pet.species == species;
      final text = '${pet.name} ${pet.breed} ${pet.species}'.toLowerCase();
      return matchesSpecies && text.contains(query.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeading(
          eyebrow: 'Pet List',
          title: 'My Pets',
          subtitle: 'Keep track of your pets, vaccines, health notes, and upcoming visits.',
          action: FilledButton.icon(onPressed: () => _addPet(context), icon: const Icon(Icons.add), label: const Text('Add pet')),
        ),
        const SizedBox(height: 20),
        TextField(onChanged: (value) => setState(() => query = value), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by pet name, breed, or type...')),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          children: ['All', 'Dog', 'Cat', 'Bird'].map((item) => ChoiceChip(label: Text(item), selected: species == item, onSelected: (_) => setState(() => species = item))).toList(),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = (constraints.maxWidth / 320).floor().clamp(1, 3);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 18, mainAxisSpacing: 18, childAspectRatio: columns == 1 ? 2.2 : 1.12),
              itemCount: visiblePets.length,
              itemBuilder: (context, index) => _PetCard(pet: visiblePets[index]),
            );
          },
        ),
      ],
    );
  }

  Future<void> _addPet(BuildContext pageContext) async {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final ageController = TextEditingController();
    final weightController = TextEditingController();
    var selectedSpecies = 'Dog';

    final newPet = await showDialog<Pet>(
      context: pageContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add a pet'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, autofocus: true, decoration: const InputDecoration(labelText: 'Pet name *')),
                  const SizedBox(height: 12),
                  TextField(controller: breedController, decoration: const InputDecoration(labelText: 'Breed')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedSpecies,
                    decoration: const InputDecoration(labelText: 'Pet type'),
                    items: const ['Dog', 'Cat', 'Bird', 'Other'].map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedSpecies = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age')),
                  const SizedBox(height: 12),
                  TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a pet name.')));
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  Pet(
                    name: name,
                    breed: breedController.text.trim().isEmpty ? 'Not set' : breedController.text.trim(),
                    species: selectedSpecies,
                    age: ageController.text.trim().isEmpty ? 'Not set' : ageController.text.trim(),
                    weight: weightController.text.trim().isEmpty ? 'Not set' : weightController.text.trim(),
                    activity: 'Medium',
                    nextVisit: 'Not set',
                    icon: Pet.iconForSpecies(selectedSpecies),
                  ),
                );
              },
              child: const Text('Save pet'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();

    if (newPet == null || !mounted) return;
    setState(() => savedPets.add(newPet));
    await _savePets();

    if (pageContext.mounted) {
      ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(content: Text('${newPet.name} was saved on this device.')));
    }
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [CircleAvatar(radius: 28, backgroundColor: AppColors.primaryFixed, child: Icon(pet.icon, color: AppColors.primary)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(pet.name, style: Theme.of(context).textTheme.titleLarge), Text('${pet.breed} • ${pet.species}', overflow: TextOverflow.ellipsis)]))]),
            const Spacer(),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_Fact('Age', pet.age), _Fact('Weight', pet.weight), _Fact('Activity', pet.activity)])),
            const Spacer(),
            Row(children: [const Icon(Icons.event, size: 18, color: AppColors.primary), const SizedBox(width: 7), const Text('Next visit'), const Spacer(), Text(pet.nextVisit, style: const TextStyle(fontWeight: FontWeight.w700))]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showHealthProfile(context),
                child: const Text('View health profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHealthProfile(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryFixed,
              child: Icon(pet.icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('${pet.name}\'s health profile')),
          ],
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProfileRow(label: 'Breed', value: pet.breed),
              _ProfileRow(label: 'Pet type', value: pet.species),
              _ProfileRow(label: 'Age', value: pet.age),
              _ProfileRow(label: 'Weight', value: pet.weight),
              _ProfileRow(label: 'Activity', value: pet.activity),
              _ProfileRow(label: 'Next visit', value: pet.nextVisit),
              const Divider(height: 28),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(child: Text('Health records are up to date')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textMuted))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(children: [Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.outline)), const SizedBox(height: 3), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))]);
}
