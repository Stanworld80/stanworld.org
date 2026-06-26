import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CRÉATEUR DE PRODUITS INFORMATIQUES",
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: 24),
          Text(
            "Éditeur indépendant et ingénieur logiciel, je conçois et développe des produits informatiques innovants. Mon approche privilégie la rigueur technique, la clarté architecturale et l'élégance du code pour proposer des solutions stables et performantes.",
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
