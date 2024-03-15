import 'package:flutter/material.dart';

void main() => runApp(const TestApp());

/// 測試應用
class TestApp extends StatelessWidget {
  const TestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: titleAppBar('title'),
      body: switchBtn('btnName', onPressed: () {}),
    ));
  }
}

/// 標題應用程式列
AppBar titleAppBar(String title) => AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.blue,
    flexibleSpace: Container(color: Colors.blue),
    title:
        Text(title, style: const TextStyle(fontSize: 40, color: Colors.white)));

/// 選擇按鈕，並導向至不同KIM列表
ElevatedButton chooseBtn(String btnName, {void Function()? onPressed}) =>
    ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: 200,
        child: Text(btnName, style: const TextStyle(fontSize: 20)),
      ),
    );

/// 切換按鈕，進行不同介面的切換
ElevatedButton switchBtn(String btnName, {void Function()? onPressed}) =>
    ElevatedButton(
      onPressed: onPressed,
      child: Text(
        btnName,
        style: const TextStyle(fontSize: 30, color: Colors.white),
      ),
    );

/// 子標題
Widget subTitle(String title) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
