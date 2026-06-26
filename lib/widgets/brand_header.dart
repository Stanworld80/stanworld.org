import 'package:flutter/material.dart';

class BrandHeader extends StatelessWidget {
  final bool isDesktop;

  const BrandHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final brandBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "STANISLAS SELLE",
          style: theme.textTheme.displayMedium,
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            "INFORMATIQUE",
            style: theme.textTheme.labelMedium,
          ),
        ),
      ],
    );

    final slogan = Text(
      "L'ingénierie logicielle, l'élégance en plus.",
      style: theme.textTheme.displaySmall,
    );

    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          brandBlock,
          slogan,
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          brandBlock,
          const SizedBox(height: 16),
          slogan,
        ],
      );
    }
  }
}
