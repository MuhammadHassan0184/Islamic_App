// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:zi_core/zi_core_io.dart';
import '../../Config/Colors/app_colors.dart' show AppColors;
import '../app_shell_io.dart';

const _termsConditionsUrl = 'https://sites.google.com/view/islam101-/home';

class TermsConditionsPageView extends StatelessWidget {
  const TermsConditionsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      backgroundColor: ZiColors.background,
      appBar: ZiAppBarB(title: ShellData.appTermsConditions.title),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FullTermsConditionsLink(url: _termsConditionsUrl),
            ShellInfoHeaderCard(
              icon: Icons.gavel_outlined,
              info: ShellData.appTermsConditions.info,
            ),
            ziGap(24),
            if (ShellData.appTermsConditions.items != null)
              ShellNumberedList(items: ShellData.appTermsConditions.items!),
            ziGap(20),
            const ShellDeveloperCredit(),
            ziGap(20),
          ],
        ),
      ),
    );
  }
}

class _FullTermsConditionsLink extends StatelessWidget {
  const _FullTermsConditionsLink({required this.url});

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
                        'Open Full Terms & Conditions',
                        style: ZiTypoStyles.titleSm,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View the full terms on our website',
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
