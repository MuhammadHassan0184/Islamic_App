import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zi_core/zi_core_io.dart';

import 'quran_reading_progress.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key, required this.isActive});

  final bool isActive;

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  static final Uri _quranUri = Uri.parse(
    'https://tadreesulquran.com/read-quran-online/',
  );
  static const _connectionMessage =
      'No internet connection. Connect to the internet to read the Quran.';

  late final WebViewController _webViewController;
  Timer? _loadTimeout;
  bool _isCheckingConnection = false;
  bool _isLoadingPage = false;
  bool _hasInternet = false;
  bool _hasPageError = false;
  bool _hasOpenedReader = false;
  int _checkId = 0;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'QuranScroll',
        onMessageReceived: (message) {
          final offset = double.tryParse(message.message);
          if (offset != null) QuranReadingProgress.saveScrollOffset(offset);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;
            if (_isSocialUrl(uri)) return NavigationDecision.prevent;
            if (_isQuranSite(uri) && _isReaderPage(uri)) {
              QuranReadingProgress.save(
                url: uri.toString(),
                title: _titleFromUri(uri),
              );
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (_) {
            if (!mounted) return;
            _hasOpenedReader = true;
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
            _removeSocialLinksAndSaveProgress();
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != false && mounted) {
              _handleMainFrameError();
            }
          },
        ),
      );
    if (widget.isActive) _checkConnectionAndOpen();
  }

  @override
  void didUpdateWidget(covariant QuranScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      _checkConnectionAndOpen();
    }
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
    if (_isCheckingConnection) return;
    await QuranReadingProgress.load();
    if (!mounted) return;
    final checkId = ++_checkId;
    setState(() {
      _isCheckingConnection = true;
      _hasPageError = false;
    });

    final isOnline = await _canReachInternet();
    if (!mounted || checkId != _checkId) return;
    final shouldLoadPage =
        !_hasOpenedReader || forceReload || _hasPageError || !_hasInternet;
    setState(() {
      _isCheckingConnection = false;
      _hasInternet = isOnline;
      _isLoadingPage = isOnline && shouldLoadPage;
    });

    if (!isOnline) return;
    if (_hasOpenedReader && !shouldLoadPage) return;
    _startLoadTimeout();
    if (_hasOpenedReader) {
      await _webViewController.reload();
      return;
    }
    final lastUrl = QuranReadingProgress.lastReadUrl.value;
    final destination = Uri.tryParse(lastUrl) ?? _quranUri;
    await _webViewController.loadRequest(
      _isQuranSite(destination) ? destination : _quranUri,
    );
  }

  bool _isQuranSite(Uri uri) =>
      uri.scheme == 'https' &&
      uri.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '') ==
          'tadreesulquran.com';

  bool _isReaderPage(Uri uri) {
    final path = uri.path.replaceAll(RegExp(r'/+$'), '');
    return path.isNotEmpty &&
        (path != '/read-quran-online' || uri.hasQuery || uri.hasFragment);
  }

  bool _isSocialUrl(Uri uri) {
    final address = uri.host.toLowerCase();
    return address.contains('whatsapp') ||
        address == 'wa.me' ||
        address.contains('facebook') ||
        address == 'fb.com' ||
        address.contains('instagram') ||
        address.contains('twitter') ||
        address == 'x.com' ||
        address.contains('telegram') ||
        address.contains('pinterest') ||
        address.contains('linkedin');
  }

  String _titleFromUri(Uri uri) {
    final location = '${uri.path} ${uri.query} ${uri.fragment}';
    if (location.toLowerCase().contains('para')) {
      final match = RegExp(r'para[-_ ]?(\d+)', caseSensitive: false)
          .firstMatch(location);
      if (match != null) return 'Para ${match.group(1)}';
    }
    final slug = uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
    final title = Uri.decodeComponent(slug)
        .replaceAll(RegExp(r'[-_]'), ' ')
        .trim();
    return title.isEmpty ? 'Quran reading' : title;
  }

  Future<void> _removeSocialLinksAndSaveProgress() async {
    try {
      await _webViewController.runJavaScript(r'''(() => {
        const social = /whatsapp|wa\.me|facebook|fb\.com|instagram|twitter|x\.com|telegram|pinterest|linkedin/i;
        const containers = '.sharedaddy, .addtoany_share_save_container, .wp-block-social-links, [class*="social-share"], [class*="social_share"], [class*="whatsapp"]';
        if (!document.getElementById('app-hide-quran-social')) {
          const style = document.createElement('style');
          style.id = 'app-hide-quran-social';
          style.textContent = `${containers} { display: none !important; }`;
          document.head.appendChild(style);
        }
        const hideLinks = () => document.querySelectorAll('a[href]').forEach((link) => {
          if (!social.test(link.href)) return;
          const container = link.closest(containers);
          (container || link).style.setProperty('display', 'none', 'important');
        });
        hideLinks();
        new MutationObserver(hideLinks).observe(document.documentElement, {
          childList: true,
          subtree: true
        });
        let lastScrollUpdate = 0;
        window.addEventListener('scroll', () => {
          const now = Date.now();
          if (now - lastScrollUpdate < 1000) return;
          lastScrollUpdate = now;
          window.QuranScroll.postMessage(String(window.scrollY));
        }, { passive: true });
      })();''');

      final url = await _webViewController.currentUrl();
      if (url == null) return;
      final uri = Uri.tryParse(url);
      if (uri == null || !_isQuranSite(uri) || !_isReaderPage(uri)) return;

      final rawTitle = await _webViewController.runJavaScriptReturningResult(
        "JSON.stringify(document.querySelector('h1')?.innerText?.trim() || document.title || '')",
      );
      var title = rawTitle.toString();
      try {
        title = jsonDecode(title) as String;
      } catch (_) {
        title = title.replaceAll(RegExp(r'^"|"$'), '');
      }
      await QuranReadingProgress.save(
        url: uri.toString(),
        title: title.trim().isEmpty ? _titleFromUri(uri) : title,
      );
      final scrollOffset = QuranReadingProgress.lastReadScrollOffset.value;
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await _webViewController.runJavaScript(
        'window.scrollTo(0, ${scrollOffset.toStringAsFixed(0)});',
      );
    } catch (_) {
      // Keep the reader usable if a page blocks script injection.
    }
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
    _loadTimeout = Timer(const Duration(seconds: 25), () {
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
  void dispose() {
    _checkId++;
    _loadTimeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showOffline = !_isCheckingConnection && !_hasInternet;
    final showLoadError = !_isCheckingConnection && _hasInternet && _hasPageError;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Quran Pak',
          style: TextStyle(
            fontSize: context.scaledFont(18).clamp(16, 21),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Reload Quran',
            onPressed: () => _checkConnectionAndOpen(forceReload: true),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_hasInternet) WebViewWidget(controller: _webViewController),
          if (_isCheckingConnection || _isLoadingPage)
            ColoredBox(
              color: AppColors.background,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: context.heightPct(0.018)),
                    Text(
                      _isCheckingConnection
                          ? 'Checking internet connection...'
                          : 'Loading Quran...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: context.scaledFont(14).clamp(12, 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (showOffline || showLoadError)
            _statusCard(
              context,
              message: showOffline
                  ? _connectionMessage
                  : 'Could not load the Quran page. Check your connection and try again.',
              onRetry: _checkConnectionAndOpen,
            ),
        ],
      ),
    );
  }

  Widget _statusCard(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      padding: context.responsivePadding(horizontal: 0.07),
      child: Container(
        padding: context.responsiveAll(0.06),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(ZiRadius.md),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.widthPct(0.17).clamp(56, 76),
              height: context.widthPct(0.17).clamp(56, 76),
              decoration: BoxDecoration(
                color: AppColors.softGreenGradient.colors.first,
                shape: BoxShape.circle,
              ),
              child: Icon(
                showOfflineIcon(message)
                    ? Icons.wifi_off_rounded
                    : Icons.menu_book_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            SizedBox(height: context.heightPct(0.018)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: context.scaledFont(14).clamp(12, 17),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: context.heightPct(0.02)),
            ZiButtonB(
              variant: ZiButtonVariantB.primary,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: 'Try again',
              style: ZiButtonStyleB(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                borderRadius: BorderRadius.circular(ZiRadius.md),
              ),
              action: onRetry,
            ),
          ],
        ),
      ),
    );
  }

  bool showOfflineIcon(String message) => message == _connectionMessage;
}
