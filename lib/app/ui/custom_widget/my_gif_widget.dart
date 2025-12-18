import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashrou3/config/resources/app_assets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyGif extends StatefulWidget {
  final String gifUrl;
  final double? height;

  const MyGif({super.key, required this.gifUrl, this.height});

  @override
  State<MyGif> createState() => _MyGifState();
}

class _MyGifState extends State<MyGif> {
  late WebViewController controller;
  late Future<void> _initializeWebView;
  bool isError = false; // Track error state

  @override
  void initState() {
    super.initState();
    _initializeWebView = _initializeWebViewController();
  }

  Future<void> _initializeWebViewController() async {
    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              setState(() {
                // Trigger loading state
                isError = false; // Reset error when loading starts
              });
            },
            onPageFinished: (_) {
              setState(() {
                // Hide loading state
              });
            },
            onWebResourceError: (error) {
              debugPrint("WebView Error: ${error.description}");
              if (mounted) {
                setState(() {
                  isError = true; // Mark error state
                });
              }
            },
          ),
        );

      // Load the gif URL in the WebView with HTML content

      controller.loadRequest(Uri.parse(
        "data:text/html;charset=utf-8,${Uri.encodeComponent('''<html lang="en">
    <head>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        html, body {
          margin: 0;
          padding: 0;
          overflow: hidden;
          width: 100vw;
          height: 100vh;
          display: flex;
          justify-content: center;
          align-items: center;
        }
        img {
          width: 100vw; /* Use viewport width */
          height: 100vh; /* Use viewport height */
          object-fit: cover;
          border-top-left-radius: 16px;
          border-top-right-radius: 16px;
          display: block;
        }
      </style>
    </head>
    <body>
      <img src="${widget.gifUrl}" alt="GIF"/>
    </body>
  </html>''')}",
      ));
    } catch (e) {
      debugPrint("Error initializing WebView: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeWebView,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading skeleton or placeholder while waiting for WebView to initialize
          return SizedBox(
            width: double.infinity,
            height: widget.height ?? double.infinity,
            child: SvgPicture.asset(
              SVGAssets.propertyPlaceholder,
              fit: BoxFit.cover,
              height: widget.height,
              width: double.infinity,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || isError) {
            // In case of error, show a fallback image
            return Center(
              child: SvgPicture.asset(
                SVGAssets.placeholder,
                fit: BoxFit.cover,
                height: widget.height,
                width: double.infinity,
              ),
            );
          }

          // WebView is ready, display it
          return SizedBox(
            width: double.infinity,
            height: widget.height ?? double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AbsorbPointer(
                child: WebViewWidget(controller: controller),
              ),
            ),
          );
        } else {
          // Return a fallback or error state if something goes wrong
          return Center(
            child: SvgPicture.asset(
              SVGAssets.propertyPlaceholder,
              fit: BoxFit.cover,
              height: widget.height,
              width: double.infinity,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    try {
      controller.runJavaScript("window.close();").then((_) {
        controller.clearCache();
      }).catchError((error) {
        debugPrint("Error during controller cleanup: $error");
      });
    } catch (e) {
      debugPrint("Dispose error: $e");
    }
    super.dispose();
  }
}
