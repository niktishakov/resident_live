import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'widgets/web_page_progress_indicator.dart';

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
            Gap(4),
            WebPageProgressIndicator(
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
