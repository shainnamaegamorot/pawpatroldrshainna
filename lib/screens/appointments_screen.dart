import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/appointment.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  static const _savedAppointmentsKey = 'pawhaven_saved_appointments';

  int day = 15;
  String query = '';
  List<Appointment> savedAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final storage = await SharedPreferences.getInstance();
    final storedValues = storage.getStringList(_savedAppointmentsKey) ?? [];
    final loaded = <Appointment>[];

    for (final value in storedValues) {
      try {
        loaded.add(Appointment.fromJson(Map<String, dynamic>.from(jsonDecode(value) as Map)));
      } on FormatException {
        // Ignore a damaged item and load the remaining appointments.
      }
    }

    if (mounted) {
      setState(() => savedAppointments = loaded);
    }
  }

  Future<void> _saveAppointments() async {
    final storage = await SharedPreferences.getInstance();
    final values = savedAppointments.map((item) => jsonEncode(item.toJson())).toList();
    await storage.setStringList(_savedAppointmentsKey, values);
  }

  @override
  Widget build(BuildContext context) {
    final allAppointments = [...sampleAppointments, ...savedAppointments];
    final visible = allAppointments.where((appointment) {
      final searchableText = '${appointment.petName} ${appointment.reason} ${appointment.doctor} ${appointment.status}'.toLowerCase();
      return appointment.day == day && searchableText.contains(query.toLowerCase());
    }).toList();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeading(eyebrow: 'Pet Visits', title: 'Appointments', subtitle: 'Plan checkups, treatments, and follow-up visits.', action: FilledButton.icon(onPressed: () => _schedule(context), icon: const Icon(Icons.add), label: const Text('Add appointment'))),
        const SizedBox(height: 18),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final date = 13 + index;
              return ChoiceChip(label: SizedBox(width: 44, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index]), Text('$date', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))])), selected: day == date, onSelected: (_) => setState(() => day = date));
            },
          ),
        ),
        const SizedBox(height: 14),
        TextField(onChanged: (value) => setState(() => query = value), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search pet, doctor, or visit type...')),
        const SizedBox(height: 18),
        if (visible.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: Text('No appointments for this day.')),
            ),
          )
        else
          ...visible.map((appointment) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _VisitCard(appointment: appointment))),
      ],
    );
  }

  Future<void> _schedule(BuildContext pageContext) async {
    final petController = TextEditingController();
    final reasonController = TextEditingController();
    final timeController = TextEditingController(text: '09:00 AM');
    var selectedDoctor = 'Dr. Shainna';

    final appointment = await showDialog<Appointment>(
      context: pageContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add appointment for September $day'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: petController, autofocus: true, decoration: const InputDecoration(labelText: 'Pet name *')),
                  const SizedBox(height: 12),
                  TextField(controller: reasonController, decoration: const InputDecoration(labelText: 'Reason for visit *')),
                  const SizedBox(height: 12),
                  TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Time', hintText: 'Example: 10:30 AM')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedDoctor,
                    decoration: const InputDecoration(labelText: 'Doctor'),
                    items: const ['Dr. Shainna', 'Dr. Robert Fox'].map((name) => DropdownMenuItem(value: name, child: Text(name))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedDoctor = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final petName = petController.text.trim();
                final reason = reasonController.text.trim();
                if (petName.isEmpty || reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the pet name and reason for the visit.')));
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  Appointment(
                    day: day,
                    time: timeController.text.trim().isEmpty ? 'Time not set' : timeController.text.trim(),
                    petName: petName,
                    reason: reason,
                    doctor: selectedDoctor,
                    status: 'Pending',
                  ),
                );
              },
              child: const Text('Save appointment'),
            ),
          ],
        ),
      ),
    );

    petController.dispose();
    reasonController.dispose();
    timeController.dispose();

    if (appointment == null || !mounted) return;
    setState(() => savedAppointments.add(appointment));
    await _saveAppointments();

    if (pageContext.mounted) {
      ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(content: Text('${appointment.petName}\'s appointment was saved.')));
    }
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(width: 92, child: Text(appointment.time, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
            const CircleAvatar(backgroundColor: AppColors.primaryFixed, child: Icon(Icons.pets, color: AppColors.primary)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.petName, style: Theme.of(context).textTheme.titleMedium), Text(appointment.reason), Text(appointment.doctor, style: const TextStyle(color: AppColors.textMuted))])),
            Chip(label: Text(appointment.status)),
          ],
        ),
      ),
    );
  }
}
