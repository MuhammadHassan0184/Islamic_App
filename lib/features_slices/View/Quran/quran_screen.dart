import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zi_core/zi_core_io.dart' hide TextDirection;

import 'quran_reading_progress.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key, required this.isActive});

  final bool isActive;

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  static const List<_QuranPara> _paras = [
    _QuranPara(1, 'الم', '1nISt4dDH1As5kZPmikNG8ub9cPdo8iZJ'),
    _QuranPara(2, 'سيقول', '1pbTSfPoVzqovmphGExOdi84dBKsXF5MZ'),
    _QuranPara(3, 'تلك الرسل', '1ow3GyUfVkB3yEZGUYwtH9ND7HPeiGcAA'),
    _QuranPara(4, 'لن تنالوا', '1ccpYP1XP6rAPTZJiM_6lPCSQmz6Zuur6'),
    _QuranPara(5, 'والمحصنات', '12D-1GUwo7mwKLxWmWlye-jireis1fFeh'),
    _QuranPara(6, 'لا يحب الله', '1XrISmaOnOmg-0D9c4YaNLLRULsE0icAj'),
    _QuranPara(7, 'وإذا سمعوا', '1pjUGqWc06QXhnJzMio5pfZ-3Ohn58iTN'),
    _QuranPara(8, 'ولو أننا', '1bHDp22HzE-RfyKCAHOUyrZvDL9la2CxT'),
    _QuranPara(9, 'قال الملأ', '18iLi9CqV5xgpWxEQioFB3LSFlrotvyeH'),
    _QuranPara(10, 'واعلموا', '1T9UlNHpzuFHg_pmrL8IoFupWaZxeS2YB'),
    _QuranPara(11, 'يعتذرون', '1VEz8_8db0C0UZBA_4TlfaR6yGFpWGuW9'),
    _QuranPara(12, 'وما من دابة', '16PSbkvP6gInXxV076lpiBbBrh_GdB28K'),
    _QuranPara(13, 'وما أبرئ', '1AXN3q_XXT3XVvY9hwAKTXjV8QsUvRB-C'),
    _QuranPara(14, 'ربما', '1E2nZThip4xVRT0c5Zvqg88NNzKvVC2RA'),
    _QuranPara(15, 'سبحان الذي', '18eGmdJEUwME3Mg8lG9MH1FCviYrFgrWi'),
    _QuranPara(16, 'قال ألم', '17xiHF8Y5xp8M0QXzyr36jgFz6zc629ZS'),
    _QuranPara(17, 'اقترب', '1weBxK2G8v_SG8yTN4L-a_oumHSnYV2UB'),
    _QuranPara(18, 'قد أفلح', '1jEgZ9pTTCi36OFXo5o6flbVdWkl428mn'),
    _QuranPara(19, 'وقال الذين', '1HkCUEu4cQw4iuUBRanGD8sTFXARJLvpn'),
    _QuranPara(20, 'أمن خلق', '1jvC9LopytnKMTdxRzqcEX0bSBA54iA7m'),
    _QuranPara(21, 'اتل ما أوحي', '19-1xQAlj8SWc3VlWijXtewAObweBSs-H'),
    _QuranPara(22, 'ومن يقنت', '1DVLCQuWbnWlKcf3eaP7v7PKSL-sHb6OM'),
    _QuranPara(23, 'وما لي', '1WP6gUIW5-51RX8ob7OvMe2-zJu_tmZgT'),
    _QuranPara(24, 'فمن أظلم', '127euM5Z0xpILGT70VX3_1pXJiT4Ubre5'),
    _QuranPara(25, 'إليه يرد', '1Mm0bhcbhNEVoDRwFG6HzAadR8C2DLfiX'),
    _QuranPara(26, 'حم', '1v7whdtl9zAp1nmNAdECQCGFAmwAOfe36'),
    _QuranPara(27, 'قال فما خطبكم', '1AjpNpnitFMIgFSTO0SVRZ-QbdtiEVd-N'),
    _QuranPara(28, 'قد سمع الله', '1CZgYj6yw4RPLDh_gz7WRtPBt3AeU5IdB'),
    _QuranPara(29, 'تبارك الذي', '1ZKuaj9IQdehUwtRiog1J1KoNXP-YBqQ-'),
    _QuranPara(30, 'عم يتساءلون', '1SWU9AJwFkfRYuG5tgPuXYAHT_iS56gAQ'),
  ];

  late final WebViewController _webViewController;
  Timer? _loadTimeout;
  _QuranPara? _selectedPara;
  String? _loadedUrl;
  bool _isCheckingConnection = false;
  bool _isLoadingPage = false;
  bool _hasInternet = false;
  bool _hasPageError = false;

  _QuranPara? get _lastReadPara {
    final savedUrl = QuranReadingProgress.lastReadUrl.value;
    for (final para in _paras) {
      if (para.previewUrl == savedUrl) return para;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            _startLoadTimeout();
            setState(() {
              _isLoadingPage = true;
              _hasPageError = false;
            });
          },
          onPageFinished: (_) {
            _loadTimeout?.cancel();
            if (!mounted) return;
            setState(() {
              _isLoadingPage = false;
              _hasPageError = false;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != false && mounted) {
              _handleMainFrameError();
            }
          },
        ),
      );
    QuranReadingProgress.load();
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();
    super.dispose();
  }

  Future<void> _openPara(_QuranPara para) async {
    await QuranReadingProgress.save(
      url: para.previewUrl,
      title: 'Para ${para.label}',
    );
    if (!mounted) return;
    setState(() {
      _selectedPara = para;
      _hasPageError = false;
    });
    await _checkConnectionAndOpen();
  }

  void _returnToParaList() {
    _loadTimeout?.cancel();
    setState(() {
      _selectedPara = null;
      _isCheckingConnection = false;
      _isLoadingPage = false;
      _hasPageError = false;
    });
  }

  Future<bool> _canReachInternet() async {
    try {
      final connectionTypes = await Connectivity().checkConnectivity();
      return connectionTypes.any((type) => type != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkConnectionAndOpen({bool forceReload = false}) async {
    final para = _selectedPara;
    if (_isCheckingConnection || para == null) return;
    final url = para.previewUrl;
    final shouldLoad = _loadedUrl != url || forceReload || _hasPageError;

    setState(() {
      _isCheckingConnection = true;
      _hasPageError = false;
    });
    final isOnline = await _canReachInternet();
    if (!mounted) return;

    setState(() {
      _isCheckingConnection = false;
      _hasInternet = isOnline;
    });
    if (!isOnline) return;

    if (!shouldLoad) return;
    _loadedUrl = url;
    setState(() => _isLoadingPage = true);
    _startLoadTimeout();
    await _webViewController.loadRequest(Uri.parse(url));
  }

  Future<void> _handleMainFrameError() async {
    _loadTimeout?.cancel();
    final isOnline = await _canReachInternet();
    if (!mounted) return;
    setState(() {
      _isLoadingPage = false;
      _hasPageError = true;
      _hasInternet = isOnline;
    });
  }

  void _startLoadTimeout() {
    _loadTimeout?.cancel();
    _loadTimeout = Timer(const Duration(seconds: 30), () {
      if (!mounted || !_isLoadingPage) return;
      _handleLoadTimeout();
    });
  }

  Future<void> _handleLoadTimeout() async {
    final isOnline = await _canReachInternet();
    if (!mounted || !_isLoadingPage) return;
    setState(() {
      _isLoadingPage = false;
      _hasPageError = true;
      _hasInternet = isOnline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedPara == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectedPara != null) _returnToParaList();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          leading: _selectedPara == null
              ? null
              : IconButton(
                  tooltip: 'All Paras',
                  onPressed: _returnToParaList,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
          title: Text(
            _selectedPara == null
                ? 'Quran Pak'
                : 'Para ${_selectedPara!.label}',
            style: TextStyle(
              fontSize: context.scaledFont(18).clamp(16, 21),
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            if (_selectedPara != null)
              IconButton(
                tooltip: 'Reload Para',
                onPressed: () => _checkConnectionAndOpen(forceReload: true),
                icon: const Icon(Icons.refresh_rounded),
              ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/Home_bg_image.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: AppColors.background),
            ),
            ColoredBox(color: Colors.white.withValues(alpha: 0.2)),
            _selectedPara == null ? _buildParaList(context) : _buildReader(),
          ],
        ),
      ),
    );
  }

  Widget _buildParaList(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final tileExtent = (100.0 + ((textScale - 1) * 24))
        .clamp(100.0, 132.0)
        .toDouble();

    return Column(
      children: [
        Padding(
          padding: context.responsivePadding(
            horizontal: 0.045,
            vertical: 0.018,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              context.widthPct(0.045).clamp(14.0, 20.0).toDouble(),
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.16),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Image.asset("assets/Quran_image.png"),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Read Quran Pak',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: context.scaledFont(17),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose from all 30 Paras',
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.82),
                          fontSize: context.scaledFont(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFFFD36A),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          final lastReadPara = _lastReadPara;
          if (lastReadPara == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: context.responsivePadding(horizontal: 0.045),
            child: _ContinueReadingCard(
              para: lastReadPara,
              onTap: () => _openPara(lastReadPara),
            ),
          );
        }),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: context.responsivePadding(
              horizontal: 0.045,
              vertical: 0.012,
            ),
            itemCount: _paras.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 440,
              mainAxisExtent: tileExtent,
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final para = _paras[index];
              return _ParaListTile(para: para, onTap: () => _openPara(para));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReader() {
    final showOffline = !_isCheckingConnection && !_hasInternet;
    final showLoadError =
        !_isCheckingConnection && _hasInternet && _hasPageError;

    return Stack(
      children: [
        if (_hasInternet) WebViewWidget(controller: _webViewController),
        if (_isCheckingConnection || _isLoadingPage)
          const ColoredBox(
            color: AppColors.background,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        if (showOffline || showLoadError)
          _readerStatusCard(
            message: showOffline
                ? 'Connect to the internet to open this Para.'
                : 'Could not open this Para. Check your connection and try again.',
          ),
      ],
    );
  }

  Widget _readerStatusCard({required String message}) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: AppColors.primary,
              size: 42,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ZiButtonB(
              variant: ZiButtonVariantB.primary,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: 'Try again',
              style: ZiButtonStyleB(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              action: _checkConnectionAndOpen,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuranPara {
  const _QuranPara(this.number, this.arabicName, this.fileId);

  final int number;
  final String arabicName;
  final String fileId;

  String get label => number.toString().padLeft(2, '0');
  String get previewUrl => 'https://drive.google.com/file/d/$fileId/preview';
}

class _ParaListTile extends StatelessWidget {
  const _ParaListTile({required this.para, required this.onTap});

  final _QuranPara para;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xF7FFFFFF),
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      shadowColor: AppColors.primaryDark.withValues(alpha: 0.12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3EBDD)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  para.label,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Para ${para.label}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      para.arabicName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primary,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({required this.para, required this.onTap});

  final _QuranPara para;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF9EB),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              const Icon(Icons.bookmark_rounded, color: Color(0xFFB58A38)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Continue Para ${para.label}',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
