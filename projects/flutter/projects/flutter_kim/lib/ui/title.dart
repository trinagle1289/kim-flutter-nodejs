import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: TitleApp()));

/// 開頭靜態介面
class TitleApp extends StatelessWidget {
  const TitleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KIM UI',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(245, 147, 147, 1),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        home: const TitleKIMSelectionPage());
  }
}

/// 開頭 KIM 量表選擇介面
class TitleKIMSelectionPage extends StatelessWidget {
  const TitleKIMSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Indicator Method (KIM)'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: chooseLhcBtn(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: chooseMhoBtn(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: choosePpBtn(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: chooseAbpBtn(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: chooseBfBtn(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: chooseBmBtn(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 按鈕-選擇 KIM-LHC
  ElevatedButton chooseLhcBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(245, 200, 200, 1.0),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => getLhcApp("1-1")),
        );
      },
      child: const SizedBox(
        width: 200, // 設置寬度
        child: Center(
          child: Text(
            '人工物料搬運\n(KIM-LHC)',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// 按鈕-選擇 KIM-MHO
  ElevatedButton chooseMhoBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(189, 225, 225, 1.0),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {},
      child: const SizedBox(
        width: 200, // 設置寬度
        child: Center(
          child: Text(
            '手動處理操作\n(KIM-MHO)',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// 按鈕-選擇 KIM-PP
  ElevatedButton choosePpBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(245, 200, 200, 1.0),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {},
      child: const SizedBox(
        width: 200, // 設置寬度
        child: Center(
          child: Text(
            '推拉作業搬運\n(KIM-PP)',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// 按鈕-選擇 KIM-ABP
  ElevatedButton chooseAbpBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(189, 225, 225, 1.0),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {},
      child: const SizedBox(
        width: 200, // 設置寬度
        child: Center(
          child: Text(
            '不當姿勢作業\n(KIM-ABP)',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// 按鈕-選擇 KIM-BF
  ElevatedButton chooseBfBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(245, 200, 200, 1.0),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {},
      child: const SizedBox(
        width: 200, // 設置寬度
        child: Center(
          child: Text(
            'Whole-body Forces\n(KIM-BF)',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// 按鈕-選擇 KIM-BM
  ElevatedButton chooseBmBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(189, 225, 225, 1.0),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {},
      child: const SizedBox(
        width: 200, // 設置寬度
        child: Center(
          child: Text(
            'Body Movement\n(KIM-BM)',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
