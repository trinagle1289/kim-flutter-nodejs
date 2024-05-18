import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
              onPressed: () {
                testing();
              },
              child: const Text('test')),
        ),
      ),
    );
  }
}

/// 開始測試
void testing() async {
  var client = http.Client();
  try {
    var url = Uri.http('10.0.2.2:5000', '/success');
    var response = await client.get(url);
    var json_data = jsonDecode(response.body);
    debugPrint(json_data['method']);
    // var decodeResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  } catch (e) {
    debugPrint('error in ${e.toString()}');
  } finally {
    client.close();
  }
}
