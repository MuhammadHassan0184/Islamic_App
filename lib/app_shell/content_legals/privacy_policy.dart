import 'package:flutter/material.dart';
import 'package:zi_core/zi_core_io.dart';
import '../../Config/Colors/app_colors.dart' show AppColors;
import '../app_shell_io.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      backgroundColor: ZiColors.background,
      appBar: ZiAppBarB(title: ShellData.appPrivacyPolicy.title),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FullPrivacyPolicyLink(url: ShellData.privacyPolicyUrl),
            ShellInfoHeaderCard(
              icon: Icons.shield_outlined,
              info: ShellData.appPrivacyPolicy.info,
            ),
            ziGap(24),
            if (ShellData.appPrivacyPolicy.items != null)
              ShellNumberedList(items: ShellData.appPrivacyPolicy.items!),
            ziGap(20),
            const ShellDeveloperCredit(),
            ziGap(24),
          ],
        ),
      ),
    );
  }
}

class _FullPrivacyPolicyLink extends StatelessWidget {
  const _FullPrivacyPolicyLink({required this.url});

  final String url;

  Future<void> _open() async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: ZiColors.surface,
        borderRadius: BorderRadius.circular(ZiRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(ZiRadius.md),
          onTap: _open,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.open_in_new_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Open Full Privacy Policy',
                        style: ZiTypoStyles.titleSm,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View the full policy on our website',
                        style: ZiTypoStyles.caption,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
