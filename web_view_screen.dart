import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/animations.dart';
import '../../core/app_theme.dart';

/// Shows web pages inside the app using webview_flutter.
/// Android / iOS / macOS use a native WebView, Chrome uses an iframe.
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, this.initialUrl = 'https://www.au.edu.pk'});

  final String initialUrl;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  static const _sites = [
    ('Air University', 'https://www.au.edu.pk'),
    ('Flutter', 'https://flutter.dev'),
    ('Dart', 'https://dart.dev'),
    ('Wikipedia', 'https://en.wikipedia.org'),
  ];

  final _addressController = TextEditingController();
  WebViewController? _controller;

  late String _currentUrl = widget.initialUrl;
  int _progress = 0;
  bool _loading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String? _error;

  bool get _supported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialUrl;
    if (_supported) _setupController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _setupController() {
    final controller = WebViewController();
    if (!kIsWeb) {
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              if (!mounted) return;
              setState(() {
                _loading = true;
                _error = null;
                _progress = 0;
                _currentUrl = url;
                _addressController.text = url;
              });
            },
            onProgress: (p) {
              if (mounted) setState(() => _progress = p);
            },
            onPageFinished: (url) async {
              final back = await controller.canGoBack();
              final forward = await controller.canGoForward();
              if (!mounted) return;
              setState(() {
                _loading = false;
                _currentUrl = url;
                _addressController.text = url;
                _canGoBack = back;
                _canGoForward = forward;
              });
            },
            onWebResourceError: (error) {
              if (!mounted) return;
              if (error.isForMainFrame ?? true) {
                setState(() {
                  _loading = false;
                  _error = error.description;
                });
              }
            },
          ),
        );
    }
    controller.loadRequest(Uri.parse(widget.initialUrl));
    _controller = controller;

    if (kIsWeb) {
      // The iframe gives no loading events, so just hide the loader shortly.
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  void _load(String input) {
    var text = input.trim();
    if (text.isEmpty) return;
    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      text = 'https://$text';
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
      _currentUrl = text;
      _addressController.text = text;
    });
    _controller?.loadRequest(Uri.parse(text));
    if (kIsWeb) {
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  Future<void> _openExternal() async {
    final ok = await launchUrl(
      Uri.parse(_currentUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the browser.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View'),
        actions: [
          if (!kIsWeb && _supported) ...[
            IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: _canGoBack ? () => _controller?.goBack() : null,
            ),
            IconButton(
              tooltip: 'Forward',
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: _canGoForward ? () => _controller?.goForward() : null,
            ),
          ],
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: _supported ? () => _load(_currentUrl) : null,
          ),
          IconButton(
            tooltip: 'Open in browser',
            icon: const Icon(Icons.open_in_new),
            onPressed: _openExternal,
          ),
        ],
      ),
      body: Column(
        children: [
          FadeSlideIn(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
              child: TextField(
                controller: _addressController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                onSubmitted: _load,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock_outline, size: 18),
                  hintText: 'Type a web address',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    color: AppColors.primary,
                    onPressed: () => _load(_addressController.text),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          FadeSlideIn(
            delay: stagger(1),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: _sites.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final site = _sites[i];
                  return ActionChip(
                    avatar: const Icon(Icons.language, size: 16),
                    label: Text(site.$1),
                    onPressed: () => _load(site.$2),
                  );
                },
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: (_loading && !kIsWeb && _supported)
                ? LinearProgressIndicator(
                    value: _progress == 0 ? null : _progress / 100,
                    minHeight: 3,
                  )
                : const SizedBox(width: double.infinity, height: 3),
          ),
          if (kIsWeb)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Running in the browser: some sites refuse to be shown inside '
                'a frame. Use "Open in browser" (top right) for those. On '
                'Android / iOS the page always loads in the native WebView.',
                style: TextStyle(fontSize: 11),
              ),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!_supported || _controller == null) {
      return _MessageCard(
        icon: Icons.desktop_windows_outlined,
        title: 'WebView is not available on this platform',
        message:
            'Run the app on Android, iOS or Chrome to see the embedded page.',
        buttonLabel: 'Open in browser',
        onPressed: _openExternal,
      );
    }
    if (_error != null) {
      return _MessageCard(
        icon: Icons.wifi_off_rounded,
        title: 'Could not load the page',
        message: _error!,
        buttonLabel: 'Try again',
        onPressed: () => _load(_currentUrl),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(child: WebViewWidget(controller: _controller!)),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _loading ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: const ColoredBox(
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
