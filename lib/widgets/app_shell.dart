import 'package:flutter/material.dart';

import '../screens/appointments_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/pets_screen.dart';
import '../screens/vaccines_screen.dart';
import '../theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  static const destinations = <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.grid_view_rounded), label: Text('Dashboard')),
    NavigationRailDestination(icon: Icon(Icons.pets_rounded), label: Text('My Pets')),
    NavigationRailDestination(icon: Icon(Icons.vaccines_rounded), label: Text('Vaccinations')),
    NavigationRailDestination(icon: Icon(Icons.calendar_month_rounded), label: Text('Appointments')),
  ];

  void openPage(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 840;
        final extended = constraints.maxWidth >= 1100;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.surface.withValues(alpha: .96),
            title: const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search pets, records, or care...')),
            actions: const [
              IconButton(onPressed: null, icon: Icon(Icons.emergency_outlined)),
              IconButton(onPressed: null, icon: Icon(Icons.notifications_outlined)),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 8),
                child: CircleAvatar(child: Text('SJ')),
              ),
            ],
          ),
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  extended: extended,
                  minExtendedWidth: 250,
                  backgroundColor: Colors.white,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: openPage,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: extended
                        ? const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.pets, color: AppColors.primary), SizedBox(width: 10), Text('Paw Patrol', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700))])
                        : const Icon(Icons.pets, color: AppColors.primary),
                  ),
                  destinations: destinations,
                ),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: [
                    DashboardScreen(onNavigate: openPage),
                    const PetsScreen(),
                    const VaccinesScreen(),
                    const AppointmentsScreen(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: openPage,
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
                    NavigationDestination(icon: Icon(Icons.pets_rounded), label: 'Pets'),
                    NavigationDestination(icon: Icon(Icons.vaccines_rounded), label: 'Vaccines'),
                    NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'Visits'),
                  ],
                ),
        );
      },
    );
  }
}
