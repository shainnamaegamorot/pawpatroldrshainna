import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class VaccinesScreen extends StatefulWidget {
  const VaccinesScreen({super.key});

  @override
  State<VaccinesScreen> createState() => _VaccinesScreenState();
}

class _VaccinesScreenState extends State<VaccinesScreen> {
  String status = 'All';

  static const records = [
    ('Milo', 'Rabies 3-Year', 'Oct 24, 2026', 'Up to date'),
    ('Luna', 'FVRCP Core', 'Sep 28, 2026', 'Due soon'),
    ('Rocky', 'DHPP Core', 'Oct 13, 2026', 'Due soon'),
    ('Bella', 'Bordetella', 'Jun 12, 2027', 'Up to date'),
    ('Daisy', 'Feline Leukemia', 'Aug 18, 2027', 'Up to date'),
    ('Cooper', 'Leptospirosis', 'Jul 09, 2026', 'Overdue'),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = records.where((row) => status == 'All' || row.$4 == status).toList();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeading(eyebrow: 'Pet Health', title: 'Vaccines', subtitle: 'See vaccine records, next doses, and vaccines that are late.', action: FilledButton.icon(onPressed: () => _recordVaccine(context), icon: const Icon(Icons.add), label: const Text('Add vaccine'))),
        const SizedBox(height: 20),
        const ResponsiveGrid(children: [
          StatCard(label: 'Up to date', value: '94.2%', icon: Icons.verified_user),
          StatCard(label: 'Due Soon', value: '8', icon: Icons.schedule, color: AppColors.secondary),
          StatCard(label: 'Overdue', value: '3', icon: Icons.warning, color: AppColors.error),
        ]),
        const SizedBox(height: 18),
        Wrap(spacing: 8, children: ['All', 'Up to date', 'Due soon', 'Overdue'].map((item) => ChoiceChip(label: Text(item), selected: status == item, onSelected: (_) => setState(() => status = item))).toList()),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [DataColumn(label: Text('Pet')), DataColumn(label: Text('Vaccine')), DataColumn(label: Text('Next dose')), DataColumn(label: Text('Status'))],
              rows: rows.map((row) => DataRow(cells: [DataCell(Text(row.$1)), DataCell(Text(row.$2)), DataCell(Text(row.$3)), DataCell(_StatusBadge(row.$4))])).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _recordVaccine(BuildContext context) => showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('Add vaccine'), content: const Column(mainAxisSize: MainAxisSize.min, children: [TextField(decoration: InputDecoration(labelText: 'Pet name')), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: 'Vaccine name'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Save'))]));
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == 'Overdue' ? AppColors.error : status == 'Due soon' ? AppColors.primary : AppColors.secondary;
    return DecoratedBox(decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w700))));
  }
}
