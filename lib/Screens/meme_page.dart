import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemePage extends StatefulWidget {
  const MemePage({super.key});

  @override
  _MemePageState createState() => _MemePageState();
}

class _MemePageState extends State<MemePage> {
  String memeUrl = '';

  @override
  void initState() {
    super.initState();
    fetchMeme();
  }

  Future<void> fetchMeme() async {
    final response = await http.get(Uri.parse('https://meme-api.herokuapp.com/gimme'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        memeUrl = data['url'];
      });
    } else {
      throw Exception('Failed to load meme');
    }
  }

  void loadNextMeme() {
    fetchMeme();
  }

  void shareMeme() {
    Share.share('Check out this meme! $memeUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meme Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (memeUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: memeUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: loadNextMeme,
                  child: Text('Next Meme'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: shareMeme,
                  child: Text('Share Meme'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
