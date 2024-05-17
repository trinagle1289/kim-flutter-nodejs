import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
                startToTest();
              },
              child: const Text('test')),
        ),
      ),
    );
  }
}

/// 開始測試
void startToTest() async {
  var path = 'http://127.0.0.1:5000/success';
  var response = await Dio().get(path);
  // debugPrint(response.toString());
  
}
