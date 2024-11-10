import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/shared/ui/rl.loader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:resident_live/shared/ui/rl.sliver_header.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String url;
  final String title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            if (mounted) setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Grabber(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gap(48),
                Flexible(
                  child: Text(
                    widget.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RlCloseButton(
                    color: context.rlTheme.iconPrimaryOnColor,
                  ),
                ),
              ],
            ),
            Gap(8),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (isLoading)
                    const Center(
                      child: RlLoader(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
