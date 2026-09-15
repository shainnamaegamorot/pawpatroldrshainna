import 'package:flutter/material.dart';

class Pet {
  const Pet({
    required this.name,
    required this.breed,
    required this.species,
    required this.age,
    required this.weight,
    required this.activity,
    required this.nextVisit,
    required this.icon,
  });

  final String name;
  final String breed;
  final String species;
  final String age;
  final String weight;
  final String activity;
  final String nextVisit;
  final IconData icon;

  Map<String, String> toJson() => {
        'name': name,
        'breed': breed,
        'species': species,
        'age': age,
        'weight': weight,
        'activity': activity,
        'nextVisit': nextVisit,
      };

  factory Pet.fromJson(Map<String, dynamic> json) {
    final species = simplePetType(json['species'] as String? ?? 'Other');
    return Pet(
      name: json['name'] as String? ?? 'Unnamed pet',
      breed: json['breed'] as String? ?? 'Not set',
      species: species,
      age: json['age'] as String? ?? 'Not set',
      weight: json['weight'] as String? ?? 'Not set',
      activity: json['activity'] as String? ?? 'Medium',
      nextVisit: json['nextVisit'] as String? ?? 'Not set',
      icon: iconForSpecies(species),
    );
  }

  static IconData iconForSpecies(String species) {
    return simplePetType(species) == 'Bird' ? Icons.flutter_dash : Icons.pets;
  }

  static String simplePetType(String value) {
    switch (value.toLowerCase()) {
      case 'canine':
      case 'dog':
        return 'Dog';
      case 'feline':
      case 'cat':
        return 'Cat';
      case 'avian':
      case 'bird':
        return 'Bird';
      default:
        return 'Other';
    }
  }
}

const pets = <Pet>[
  Pet(name: 'Milo', breed: 'Golden Retriever', species: 'Dog', age: '3 yrs', weight: '31.5 kg', activity: 'High', nextVisit: 'Oct 24', icon: Icons.pets),
  Pet(name: 'Luna', breed: 'British Shorthair', species: 'Cat', age: '2 yrs', weight: '4.8 kg', activity: 'Medium', nextVisit: 'Nov 03', icon: Icons.pets),
  Pet(name: 'Charlie', breed: 'Cockatiel', species: 'Bird', age: '4 yrs', weight: '90 g', activity: 'High', nextVisit: 'Nov 18', icon: Icons.flutter_dash),
  Pet(name: 'Bella', breed: 'French Bulldog', species: 'Dog', age: '4 yrs', weight: '10.9 kg', activity: 'Medium', nextVisit: 'Dec 02', icon: Icons.pets),
  Pet(name: 'Daisy', breed: 'Domestic Shorthair', species: 'Cat', age: '5 yrs', weight: '4.2 kg', activity: 'Low', nextVisit: 'Dec 12', icon: Icons.pets),
  Pet(name: 'Coco', breed: 'Miniature Poodle', species: 'Dog', age: '8 mos', weight: '5.4 kg', activity: 'High', nextVisit: 'Dec 19', icon: Icons.pets),
];
