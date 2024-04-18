import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemeGeneratorPage(),
    );
  }
}

class MemeGeneratorPage extends StatefulWidget {
  @override
  _MemeGeneratorPageState createState() => _MemeGeneratorPageState();
}

class _MemeGeneratorPageState extends State<MemeGeneratorPage> {
  TextEditingController topTextController = TextEditingController();
  TextEditingController bottomTextController = TextEditingController();
  String memeUrl = '';

  Future<void> generateMeme() async {
    final String baseUrl = 'https://ronreiter-meme-generator.p.rapidapi.com';
    final String apiKey = '078e8effc2msha8b0fd4b5796971p1e94eajsne2705994ac5e';
    final String memeType = 'Condescending-Wonka';
    final String fontSize = '50';
    final String font = 'Impact';

    final String topText = Uri.encodeComponent(topTextController.text);
    final String bottomText = Uri.encodeComponent(bottomTextController.text);

    final Uri uri = Uri.parse('$baseUrl/meme?top=$topText&bottom=$bottomText&meme=$memeType&font_size=$fontSize&font=$font');

    try {
      final response = await http.get(
        uri,
        headers: {
          'X-Rapidapi-Key': apiKey,
          'X-Rapidapi-Host': 'ronreiter-meme-generator.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          memeUrl = data['url'];
        });
      } else {
        throw Exception('Failed to generate meme: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating meme: $e');
      throw Exception('Failed to generate meme: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meme Generator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(29.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: topTextController,
              decoration: InputDecoration(labelText: 'Top Text'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bottomTextController,
              decoration: InputDecoration(labelText: 'Bottom Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateMeme,
              child: Text('Generate Meme'),
            ),
            SizedBox(height: 20),
            if (memeUrl.isNotEmpty)
              Image.network(memeUrl),
          ],
        ),
      ),
    );
  }
}
