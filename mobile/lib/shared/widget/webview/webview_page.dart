import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/webview/webview_progress_indicator.dart";
import "package:webview_flutter/webview_flutter.dart";

class WebviewPage extends StatefulWidget {
  const WebviewPage({
    required this.url,
    required this.title,
    super.key,
  });

  final String url;
  final String title;

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebViewController controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100.0;
            });
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
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
            const Grabber(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Gap(48),
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
            const Gap(4),
            WebviewProgressIndicator(
              progress: _progress,
            ),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
