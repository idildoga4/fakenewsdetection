import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake News Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NewsCheckScreen(),
    );
  }
}

class NewsCheckScreen extends StatefulWidget {
  const NewsCheckScreen({super.key});

  @override
  State<NewsCheckScreen> createState() => _NewsCheckScreenState();
}

class _NewsCheckScreenState extends State<NewsCheckScreen> {
  final TextEditingController _textController = TextEditingController();

  String _label = "";
  String _confidence = "";
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _checkNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _label = "";
    });

    const String apiUrl = 'http://10.0.2.2:5000/predict'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": _textController.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _label = data['label'];
          _confidence = data['confidence_score'];
        });
      } else {
        setState(() {
          _errorMessage = "API Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network Error\n$e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fake News Detector"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter the news text:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _textController,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              enableInteractiveSelection: true,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Paste the news text you want to analyze...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 20),


            ElevatedButton.icon(
              onPressed: _isLoading ? null : _checkNews,
              icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Icon(Icons.search),
              label: Text(_isLoading ? "Analyzing" : "Check Authenticity"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),


            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.red[100],
                child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ),

            if (_label.isNotEmpty) ...[
              const Divider(),
              const Center(child: Text("Result", style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _label == "REAL" ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _label == "REAL" ? Colors.green : Colors.red,
                    width: 2
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _label == "REAL" ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 60,
                      color: _label == "REAL" ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _label == "REAL" ? "REAL NEWS" : "FAKE NEWS",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _label == "REAL" ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Confidence Score: $_confidence",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}