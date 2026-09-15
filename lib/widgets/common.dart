import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.action,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 24,
        runSpacing: 20,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(eyebrow.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({required this.label, required this.value, required this.icon, this.color = AppColors.primary, super.key});

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: .12), foregroundColor: color, child: Icon(icon)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                  Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({required this.children, this.minWidth = 230, super.key});

  final List<Widget> children;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minWidth).floor().clamp(1, 4);
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: columns == 1 ? 3.2 : 2.15,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}
