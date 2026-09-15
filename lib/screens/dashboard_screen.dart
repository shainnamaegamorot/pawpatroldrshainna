import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.onNavigate, super.key});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeading(
          eyebrow: 'Tuesday, September 15',
          title: 'Good morning, Dr. Shainna',
          subtitle: 'Here is today’s pet care, tasks, and upcoming visits.',
          action: FilledButton.icon(onPressed: () => onNavigate(3), icon: const Icon(Icons.add), label: const Text('New appointment')),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(onPressed: () => onNavigate(1), icon: const Icon(Icons.pets), label: const Text('Open pets')),
            OutlinedButton.icon(onPressed: () => onNavigate(2), icon: const Icon(Icons.vaccines), label: const Text('Open vaccines')),
            OutlinedButton.icon(onPressed: () => onNavigate(3), icon: const Icon(Icons.calendar_month), label: const Text('Open appointments')),
          ],
        ),
        const SizedBox(height: 20),
        const ResponsiveGrid(children: [
          StatCard(label: 'Registered Pets', value: '153', icon: Icons.pets),
          StatCard(label: 'Visits Today', value: '12', icon: Icons.calendar_today, color: AppColors.tertiary),
          StatCard(label: 'Vaccines Due', value: '8', icon: Icons.vaccines, color: AppColors.secondary),
          StatCard(label: 'Urgent Alerts', value: '3', icon: Icons.warning_amber, color: AppColors.error),
        ]),
        const SizedBox(height: 20),
        const Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _Panel(title: 'Today’s schedule', width: 580, children: [
              _ScheduleRow(time: '09:00', pet: 'Milo', detail: 'Yearly checkup'),
              _ScheduleRow(time: '10:30', pet: 'Luna', detail: 'Vaccination follow-up'),
              _ScheduleRow(time: '13:15', pet: 'Charlie', detail: 'Follow-up check'),
              _ScheduleRow(time: '15:00', pet: 'Bella', detail: 'Teeth checkup'),
            ]),
            _Panel(title: 'Recent activity', width: 400, children: [
              ListTile(leading: Icon(Icons.vaccines, color: AppColors.primary), title: Text('Luna vaccination updated'), subtitle: Text('15 minutes ago • Nurse Kyle')),
              ListTile(leading: Icon(Icons.medication, color: AppColors.tertiary), title: Text('Milo received Amoxicillin'), subtitle: Text('42 minutes ago • Dr. Shainna')),
              ListTile(leading: Icon(Icons.task_alt, color: AppColors.secondary), title: Text('Charlie checkup completed'), subtitle: Text('1 hour ago • Dr. Shainna')),
            ]),
          ],
        ),
      ],
    );
  }

}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.width, required this.children});
  final String title;
  final double width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 12), ...children]),
        ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.time, required this.pet, required this.detail});
  final String time;
  final String pet;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ListTile(contentPadding: EdgeInsets.zero, leading: Text(time, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)), title: Text(pet), subtitle: Text(detail), trailing: const Icon(Icons.chevron_right));
  }
}
