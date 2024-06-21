import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ImageDisplay extends StatelessWidget {
  final List<String> imageUrls;

  const ImageDisplay({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 170,
      child: ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WebViewPage(url: 'https://www.apple.com/in/'), // Replace with actual URL from imageUrls[i]
              ),
            );
          },
          child: Image.network(
            imageUrls[i],
            width: 200,
            fit: BoxFit.contain,
          ),
        ),
        itemCount: imageUrls.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
