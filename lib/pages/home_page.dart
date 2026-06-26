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

  List<Widget> _buildShowcaseItems() {
    return [
      MinimalistShowcaseCard(
        title: "Création de Produits",
        description:
            "Conception et édition de logiciels innovants, d'outils web de pointe et d'applications modernes axés sur la stabilité et la performance.",
        actionLabel: "Découvrir les produits",
        url: "https://stanislasselleinformatique.fr",
        onTap: () => _launchUrl("https://stanislasselleinformatique.fr"),
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
    final showcaseItems = _buildShowcaseItems();

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
