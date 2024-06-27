// ip_view.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kim_lhc_app/utils/server.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';

void main() {
  runApp(IpViewApp());
}

class IpViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP 輸入',
      home: IpInputPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IpInputPage extends StatefulWidget {
  @override
  _IpInputPageState createState() => _IpInputPageState();
}

class _IpInputPageState extends State<IpInputPage> {
  final TextEditingController ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ipController.text = Server.instance.ip;  // 使用 Server 單例中的 IP 初始化文本控制器
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('輸入伺服器 IP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              '當前伺服器 IP: ${Server.instance.ip}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: '輸入新的 IP 地址',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Server.instance.updateServerIP(ipController.text);
                print('ip_view 的 IP 已更新為: ${Server.instance.ip}');
                //debug 收集資料
                Dio()
                    .getUri(Uri.http(Server.instance.ip))
                    .then((onValue) => {debugPrint("Debug Connection: ${onValue.toString()}")});

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LhcPart1()),
                );
              },
              child: Text('提交'),
            ),
          ],
        ),
      ),
    );
  }
}
