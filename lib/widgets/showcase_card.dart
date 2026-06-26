import 'package:flutter/material.dart';

class MinimalistShowcaseCard extends StatefulWidget {
  final String title;
  final String description;
  final String actionLabel;
  final String url;
  final VoidCallback onTap;

  const MinimalistShowcaseCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.url,
    required this.onTap,
  });

  @override
  State<MinimalistShowcaseCard> createState() => _MinimalistShowcaseCardState();
}

class _MinimalistShowcaseCardState extends State<MinimalistShowcaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderThemeColor = _isHovered 
        ? theme.colorScheme.primary 
        : theme.colorScheme.outline;
    
    final buttonColor = _isHovered 
        ? theme.colorScheme.secondary 
        : theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.zero, // Sharp square corners
            border: Border.all(
              color: borderThemeColor,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleLarge, // Inter, bold, 18
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: theme.textTheme.bodyMedium, // Inter, 13, height 1.5
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sharp Action Button
              Container(
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.zero, // Sharp square corners
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.actionLabel,
                      style: theme.textTheme.labelLarge, // Inter, white, 12
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
