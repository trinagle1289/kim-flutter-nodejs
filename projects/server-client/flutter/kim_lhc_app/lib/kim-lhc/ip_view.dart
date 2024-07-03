// ip_view.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kim_lhc_app/utils/server.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';

void main() {
  runApp(const IpViewApp());
}

class IpViewApp extends StatelessWidget {
  const IpViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'KIM LHC 量表評估工具 - 榮靜計畫', home: IpInputPage());
  }
}

class IpInputPage extends StatefulWidget {
  const IpInputPage({super.key});

  @override
  State<IpInputPage> createState() => _IpInputPageState();
}

class _IpInputPageState extends State<IpInputPage> {
  final TextEditingController ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ipController.text = Server.instance.ip; // 使用 Server 單例中的 IP 初始化文本控制器
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('輸入伺服器 IP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              '當前伺服器 IP: ${Server.instance.ip}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: '輸入新的 IP 地址',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // IP 字串
                var ipText = ipController.text;
                // 測試連線狀況
                Dio().getUri(Uri.http(ipText)).then((response) {
                  debugPrint("Debug response: ${response.toString()}");
                  Server.instance.updateServerIP(ipText); // 更新伺服器IP
                  Fluttertoast.showToast(msg: "成功連上伺服器: $ipText");
                }, onError: (e) {
                  // 錯誤處理
                  debugPrint("Connect Server Error: ${e.toString()}");
                  Fluttertoast.showToast(msg: "伺服器連線失敗");
                }).whenComplete(() {
                  // 結束時切換畫面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LhcPart1()),
                  );
                });
              },
              child: const Text('提交'),
            ),
          ],
        ),
      ),
    );
  }
}
