import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const StanworldApp());
}

class StanworldApp extends StatelessWidget {
  const StanworldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stanislas Selle Informatique',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light, // Pure light minimalist theme as requested
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF111111), // Ink Black
          secondary: Color(0xFF0B192C), // Midnight Navy
          surface: Colors.white,
          onSurface: Color(0xFF111111),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
            .copyWith(
              displayLarge: GoogleFonts.cormorantGaramond(
                fontWeight: FontWeight.w300,
                fontSize: 44,
                letterSpacing: 6.0,
                color: const Color(0xFF111111),
              ),
              displayMedium: GoogleFonts.cormorantGaramond(
                fontWeight: FontWeight.w400,
                fontSize: 28,
                letterSpacing: 2.0,
                color: const Color(0xFF111111),
              ),
              titleLarge: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 1.0,
                color: const Color(0xFF111111),
              ),
              bodyLarge: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 1.6,
                color: const Color(0xFF333333),
              ),
            ),
      ),
      home: const StanworldHomePage(),
    );
  }
}

class StanworldHomePage extends StatelessWidget {
  const StanworldHomePage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 950;

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
                  // Logo Brand Block & Slogan Row
                  isDesktop
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [_buildBrandBlock(), _buildSloganText()],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBrandBlock(),
                            const SizedBox(height: 16),
                            _buildSloganText(),
                          ],
                        ),

                  const SizedBox(height: 40),
                  const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                  const SizedBox(height: 80),

                  // Hero Text & Introduction
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Créateur de produits informatiques",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF0B192C),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Éditeur indépendant et ingénieur logiciel, je conçois et développe des produits informatiques innovants. Mon approche privilégie la rigueur technique, la clarté architecturale et l'élégance du code pour proposer des solutions stables et performantes.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),

                  // Showcase Grid/List
                  isDesktop
                      ? GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                          children: _buildShowcaseItems(),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 30),
                          itemBuilder: (context, index) =>
                              _buildShowcaseItems()[index],
                        ),

                  const SizedBox(height: 120),

                  // Footer / Contacts
                  const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                  const SizedBox(height: 40),
                  Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: isDesktop
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STANISLAS SELLE INFORMATIQUE",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: const Color(0xFF111111),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "SIRET XXXXXXXXXXX — France — Micro-entreprise",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                      if (!isDesktop) const SizedBox(height: 24),
                      Row(
                        children: [
                          _footerLink(
                            "GitHub",
                            "https://github.com/Stanworld80",
                          ),
                          const SizedBox(width: 30),
                          _footerLink(
                            "Email",
                            "mailto:contact@stanislasselleinformatique.fr",
                          ),
                          const SizedBox(width: 30),
                          _footerLink(
                            "Légal",
                            "https://stanislasselleinformatique.fr",
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "STANISLAS SELLE",
          style: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w300,
            fontSize: 28,
            letterSpacing: 5.0,
            color: const Color(0xFF111111),
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            "INFORMATIQUE",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              letterSpacing: 7.5,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSloganText() {
    return Text(
      "L'ingénierie logicielle, l'élégance en plus.",
      style: GoogleFonts.cormorantGaramond(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: const Color(0xFF666666),
      ),
    );
  }

  Widget _footerLink(String label, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: const Color(0xFF111111),
          decoration: TextDecoration.underline,
        ),
      ),
    );
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
            "Blog personnel traitant des paradigmes de programmation, de la qualité logicielle et des architectures modernes.",
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
}

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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.zero, // Sharp square corners as requested
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF111111)
                  : const Color(0xFFE5E5E5),
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
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                      color: const Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sharp Action Button
              Container(
                decoration: BoxDecoration(
                  color: _isHovered
                      ? const Color(0xFF0B192C)
                      : const Color(0xFF111111),
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
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
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
