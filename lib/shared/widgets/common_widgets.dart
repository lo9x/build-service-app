import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.muted,
                    ),
              ),
          ],
        ),
        actions: actions,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F2EC), Color(0xFFEEE4D7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: -60,
                right: -20,
                child: _BlurOrb(
                  size: 220,
                  color: Color(0x33C66A3D),
                ),
              ),
              const Positioned(
                left: -60,
                top: 140,
                child: _BlurOrb(
                  size: 180,
                  color: Color(0x33274C46),
                ),
              ),
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                children: [child],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.actions = const [],
    this.footer,
    this.dark = true,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<Widget> actions;
  final Widget? footer;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final panelColor = dark ? AppTheme.ink : AppTheme.surface;
    final titleColor = dark ? Colors.white : AppTheme.ink;
    final bodyColor = dark ? Colors.white70 : AppTheme.muted;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: dark ? Colors.white10 : AppTheme.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              eyebrow,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dark ? Colors.white70 : AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: titleColor,
                ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: bodyColor,
                ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 22),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: actions,
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 22),
            footer!,
          ],
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    required this.description,
    this.trailing,
  });

  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(description),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class LoadingBlock extends StatelessWidget {
  const LoadingBlock({super.key, this.label = 'Загрузка данных...'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class ErrorBlock extends StatelessWidget {
  const ErrorBlock({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StateBadge(
            label: 'Ошибка загрузки',
            color: AppTheme.accent,
          ),
          const SizedBox(height: 14),
          Text(
            'Не удалось получить данные',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}

class EmptyBlock extends StatelessWidget {
  const EmptyBlock({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StateBadge(
            label: 'Пустой список',
            color: AppTheme.primary,
          ),
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message),
        ],
      ),
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip({
    super.key,
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon == null
          ? null
          : Icon(
              icon,
              size: 16,
              color: AppTheme.primary,
            ),
      label: Text(label),
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppTheme.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppTheme.primary),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: title,
            description: description,
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class CatalogCard extends StatelessWidget {
  const CatalogCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.onTap,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> meta;
  final VoidCallback onTap;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(subtitle),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_outward_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, children: meta),
          if (footer != null) ...[
            const SizedBox(height: 18),
            footer!,
          ],
        ],
      ),
    );
  }
}

class RoleToggle extends StatelessWidget {
  const RoleToggle({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isActive = item == selected;
        return InkWell(
          onTap: () => onSelected(item),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isActive ? AppTheme.primary : AppTheme.line,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StateBadge extends StatelessWidget {
  const _StateBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
