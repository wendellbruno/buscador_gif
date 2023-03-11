import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class GifPage extends StatelessWidget {
  const GifPage({super.key, required this.gifData});

  final Map gifData;

  Future shareGif() async {
    await FlutterShare.share(
        title: "Gif", linkUrl: gifData["images"]["fixed_height"]["url"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: shareGif, icon: const Icon(Icons.share))
        ],
        title: Text(gifData["title"]),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
