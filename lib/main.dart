import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

void main() {
  runApp(const PawPatrolApp());
}

class PawPatrolApp extends StatelessWidget {
  const PawPatrolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paw Patrol',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
