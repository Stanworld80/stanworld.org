import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/brand_header.dart';
import '../widgets/hero_section.dart';
import '../widgets/showcase_card.dart';
import '../widgets/footer.dart';

class StanworldHomePage extends StatelessWidget {
  const StanworldHomePage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $urlString');
    }
  }

  void _showProductsDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: theme.colorScheme.surface,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NOS PRODUITS",
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 22,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductItem(
                          context,
                          title: "Colors Notes",
                          description: "Application de prise de notes et de gestion de palettes chromatiques moderne.",
                          gitUrl: "https://github.com/Stanworld80/Colors_Notes",
                        ),
                        const SizedBox(height: 20),
                        _buildProductItem(
                          context,
                          title: "Finance Manager 2026",
                          description: "Outil complet de suivi budgétaire et de gestion de finances personnelles.",
                          gitUrl: "https://github.com/Stanworld80/finance-manager-2026",
                        ),
                        const SizedBox(height: 20),
                        _buildProductItem(
                          context,
                          title: "Archipel De la fortune",
                          description: "Projet de simulation de fortune et de gestion stratégique d'archipel.",
                          gitUrl: "https://github.com/Stanworld80/ArchipelFortune",
                        ),
                        const SizedBox(height: 20),
                        _buildProductItem(
                          context,
                          title: "Very Simple Diary",
                          description: "Application de journal intime minimaliste, performante et multi-plateforme.",
                          gitUrl: "https://github.com/Stanworld80/VerySimpleDiary",
                        ),
                        const SizedBox(height: 20),
                        _buildProductItem(
                          context,
                          title: "StanMovieDB",
                          description: "Base de données de films enrichie avec l'API TMDB et intégrée à Firestore.",
                          gitUrl: "https://github.com/Stanworld80/StanMovieDB",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "FERMER",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductItem(
    BuildContext context, {
    required String title,
    required String description,
    required String gitUrl,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _launchUrl(gitUrl);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Git Repo",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.open_in_new,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  List<Widget> _buildShowcaseItems(BuildContext context) {
    return [
      MinimalistShowcaseCard(
        title: "Création de Produits",
        description:
            "Conception et édition de logiciels innovants, d'outils web de pointe et d'applications modernes axés sur la stabilité et la performance.",
        actionLabel: "Découvrir les produits",
        url: "https://stanislasselleinformatique.fr",
        onTap: () => _showProductsDialog(context),
      ),
      MinimalistShowcaseCard(
        title: "Stan's Vision",
        description:
            "Blog personnel traitant de considérations subjectives et imaginaires potentiellement réalistes.",
        actionLabel: "Consulter les articles",
        url: "https://stanvision.stanworld.org",
        onTap: () => _launchUrl("https://stanvision.stanworld.org"),
      ),
      MinimalistShowcaseCard(
        title: "Expérimentations IA",
        description:
            "Laboratoire de démonstration technique d'algorithmes et de modèles, illustré par le projet Guessnumber.",
        actionLabel: "Lancer Guessnumber",
        url: "https://guessnumber.stanworld.org",
        onTap: () => _launchUrl("https://guessnumber.stanworld.org"),
      ),
      MinimalistShowcaseCard(
        title: "Services en ligne",
        description:
            "Utilitaires web et outils de productivité hébergés à l'usage des professionnels, incluant notre outil de calendrier.",
        actionLabel: "Accéder au Calendrier",
        url: "https://www.stanworld.org/calendar",
        onTap: () => _launchUrl("https://www.stanworld.org/calendar"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 950;
    final showcaseItems = _buildShowcaseItems(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? screenSize.width * 0.12 : 24,
            vertical: 60,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandHeader(isDesktop: isDesktop),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 80),
                  const HeroSection(),
                  const SizedBox(height: 100),
                  Text(
                    "PRODUITS",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                          letterSpacing: 4.0,
                        ),
                  ),
                  const SizedBox(height: 40),
                  isDesktop
                      ? GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                          children: showcaseItems,
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: showcaseItems.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 30),
                          itemBuilder: (context, index) => showcaseItems[index],
                        ),
                  const SizedBox(height: 120),
                  Footer(isDesktop: isDesktop),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
