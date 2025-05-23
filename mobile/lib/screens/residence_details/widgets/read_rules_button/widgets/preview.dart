import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:webview_flutter/webview_flutter.dart";

class Preview extends StatefulWidget {
  const Preview({required this.url, required this.title, super.key, this.height = 150});

  final String url;
  final String title;
  final double height;

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AbsorbPointer(
          absorbing: true,
          child: Stack(
            children: [
              if (isLoading)
                Skeletonizer(
                  containersColor: theme.bgSecondary.withValues(alpha: .2),
                  enabled: true,
                  child: SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            4,
                            (index) => Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 10,
                                  width: constraints.maxWidth * 0.8,
                                  color: theme.bgSecondary,
                                ),
                              ),
                            ),
                          ),
                          context.vBox4,
                        ],
                      ),
                    ),
                  ),
                ),
              WebViewWidget(controller: controller),
            ],
          ),
        );
      },
    );
  }
}
