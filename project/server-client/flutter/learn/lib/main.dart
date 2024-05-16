import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:cronet_http/cronet_http.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
              onPressed: () => startToTest(), child: const Text('test')),
        ),
      ),
    );
  }
}

/// 開始測試
void startToTest() async {
  final Client httpClient;
  if (Platform.isAndroid) {
    final engine = CronetEngine.build(
        cacheMode: CacheMode.memory,
        cacheMaxSize: 2 * 1024 * 1024,
        userAgent: 'Book Agent');
    httpClient = CronetClient.fromCronetEngine(engine, closeEngine: true);
  } else {
    httpClient = IOClient(HttpClient()..userAgent = 'Book Agent');
  }

  final response = await httpClient.get(Uri.https(
      'www.googleapis.com',
      'books/v1/volumes',
      {'q': 'HTTP', 'maxResults': '40', 'printType': 'books'}));

  httpClient.close();
}
