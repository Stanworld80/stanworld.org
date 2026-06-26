import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  final bool isDesktop;

  const Footer({
    super.key,
    required this.isDesktop,
  });

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $urlString');
    }
  }

  Widget _footerLink(BuildContext context, String label, String url) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final brandAndSiret = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "STANISLAS SELLE INFORMATIQUE",
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Text(
          "SIRET XXXXXXXXXXX — France — Micro-entreprise",
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );

    final links = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _footerLink(context, "GitHub", "https://github.com/Stanworld80"),
        const SizedBox(width: 30),
        _footerLink(context, "Email", "mailto:contact@stanislasselleinformatique.fr"),
        const SizedBox(width: 30),
        _footerLink(context, "Légal", "https://stanislasselleinformatique.fr"),
      ],
    );

    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 40),
        if (isDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              brandAndSiret,
              links,
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              brandAndSiret,
              const SizedBox(height: 24),
              links,
            ],
          ),
      ],
    );
  }
}
