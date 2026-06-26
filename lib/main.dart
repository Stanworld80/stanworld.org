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
      title: 'Stanworld - Stanislas Selle',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Always dark mode by default for premium developer aesthetic
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F11),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F0FF), // Cyber Cyan
          secondary: Color(0xFF9E00FF), // Electric Violet
          surface: Color(0xFF18181C),
          onSurface: Color(0xFFE4E4E7),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 48,
            letterSpacing: -1.0,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: const Color(0xFFA1A1AA),
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
    final isDesktop = screenSize.width > 900;
    final isTablet = screenSize.width > 600 && screenSize.width <= 900;

    return Scaffold(
      body: Stack(
        children: [
          // Premium subtle background gradient & ambient glow spots
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF08080A),
                    Color(0xFF0F0F13),
                    Color(0xFF14121A),
                  ],
                ),
              ),
            ),
          ),
          // Glow Spot 1
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00F0FF).withOpacity(0.08),
                backgroundBlendMode: BlendMode.screen,
              ),
              child: const SizedBox(),
            ),
          ),
          // Glow Spot 2
          Positioned(
            bottom: -200,
            right: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9E00FF).withOpacity(0.08),
                backgroundBlendMode: BlendMode.screen,
              ),
              child: const SizedBox(),
            ),
          ),
          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? screenSize.width * 0.1 : 24,
                vertical: 40,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header & Language/Social Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00F0FF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF00F0FF),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    )
                                  ]
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'STANWORLD',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  letterSpacing: 2.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.code, color: Colors.white70),
                                tooltip: 'GitHub',
                                onPressed: () => _launchUrl('https://github.com/Stanworld80'),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.alternate_email, color: Colors.white70),
                                tooltip: 'Email',
                                onPressed: () => _launchUrl('mailto:contact@stanworld.org'),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 80),

                      // Hero section with glowing text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF00F0FF), Color(0xFF9E00FF)],
                            ).createShader(bounds),
                            child: Text(
                              'Stanislas Selle',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white, // Required for ShaderMask
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Ingénierie Informatique & Technologies Web",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: const Color(0xFFE4E4E7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: Text(
                              "Expert en ingénierie informatique. Je conçois des solutions logicielles sur-mesure, mène des expérimentations en intelligence artificielle et développe des applications web et mobiles innovantes.",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),

                      // Grid or List of Sections
                      isDesktop
                          ? GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              children: _buildCards(),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                              itemBuilder: (context, index) => _buildCards()[index],
                            ),

                      const SizedBox(height: 120),

                      // Footer
                      const Divider(color: Color(0xFF27272A)),
                      const SizedBox(height: 30),
                      Flex(
                        direction: isDesktop ? Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                        children: [
                          Text(
                            '© 2026 Stanislas Selle. Tous droits réservés.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF71717A),
                            ),
                          ),
                          if (!isDesktop) const SizedBox(height: 16),
                          Row(
                            children: [
                              _footerLink('stanworld.org', 'https://www.stanworld.org'),
                              const SizedBox(width: 20),
                              _footerLink('stanislasselleinformatique.fr', 'https://stanislasselleinformatique.fr'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String label, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFFA1A1AA),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    return [
      InteractiveServiceCard(
        title: "Ingénierie & Services",
        subtitle: "Stanislas Selle Informatique",
        description: "Prestations d'expertise, d'audit technique et de développement de solutions logicielles professionnelles adaptées à vos besoins.",
        icon: Icons.business_center_outlined,
        actionLabel: "Découvrir les services",
        accentColor: const Color(0xFF00F0FF),
        onTap: () => _launchUrl('https://stanislasselleinformatique.fr'),
      ),
      InteractiveServiceCard(
        title: "Stan's Vision",
        subtitle: "Mon Blog Technologique",
        description: "Partage de retours d'expérience, articles de veille technologique et analyses sur le développement et le futur de l'ingénierie.",
        icon: Icons.article_outlined,
        actionLabel: "Lire le blog",
        accentColor: const Color(0xFF9E00FF),
        onTap: () => _launchUrl('https://stanvision.stanworld.org'),
      ),
      InteractiveServiceCard(
        title: "Expérimentations IA",
        subtitle: "Guessnumber & IA Demos",
        description: "Démonstrations interactives et projets d'expérimentation autour de l'intelligence artificielle et du machine learning.",
        icon: Icons.psychology_outlined,
        actionLabel: "Lancer Guessnumber",
        accentColor: const Color(0xFFFF007A),
        onTap: () => _launchUrl('https://guessnumber.stanworld.org'),
      ),
      InteractiveServiceCard(
        title: "Outils & Services",
        subtitle: "Mon Calendrier en ligne",
        description: "Des outils et micro-services web utiles mis à disposition du public, conçus pour la productivité au quotidien.",
        icon: Icons.calendar_month_outlined,
        actionLabel: "Accéder au calendrier",
        accentColor: const Color(0xFF00FF85),
        onTap: () => _launchUrl('https://www.stanworld.org/calendar'),
      ),
    ];
  }
}

class InteractiveServiceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String actionLabel;
  final Color accentColor;
  final VoidCallback onTap;

  const InteractiveServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.actionLabel,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<InteractiveServiceCard> createState() => _InteractiveServiceCardState();
}

class _InteractiveServiceCardState extends State<InteractiveServiceCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          transform: _isHovered 
              ? (Matrix4.identity()..translate(0, -8, 0)..scale(1.02)) 
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: const Color(0xFF18181C),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? widget.accentColor.withOpacity(0.5) : const Color(0xFF27272A),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? widget.accentColor.withOpacity(0.15) : Colors.black.withOpacity(0.2),
                blurRadius: _isHovered ? 25 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon & Top decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 32,
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 1.0 : 0.0,
                        child: Icon(
                          Icons.arrow_outward,
                          color: widget.accentColor,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Titles
                  Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: widget.accentColor.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    widget.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.45,
                      color: const Color(0xFFA1A1AA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Call to Action
              Row(
                children: [
                  Text(
                    widget.actionLabel,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: _isHovered ? widget.accentColor : Colors.white70,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
