import 'package:flutter/material.dart';
import 'package:kim_lhc_app/kim-lhc/part2.dart';
import 'package:kim_lhc_app/kim-lhc/part3.dart';
import 'package:kim_lhc_app/kim-lhc/part5.dart';
import 'package:kim_lhc_app/kim-lhc/part6.dart';
import 'package:kim_lhc_app/kim-lhc/part7.dart';
import 'package:kim_lhc_app/kim-lhc/record1.dart';
import 'package:kim_lhc_app/kim-lhc/record2.dart';
import 'package:kim_lhc_app/kim-lhc/result.dart';
import 'package:kim_lhc_app/kim-lhc/ip_view.dart';

void main() {
  runApp(const LhcPart1());
}

double finalScore = 0;
double unfavorableResult = 0;
double frequencyResult = 0;
double totalResult = 0;
double effectiveResult = 0;
double loadResult = 0;
double workResult = 0;

void calculateresult() {
  finalScore = (timeLevel - 1) *
      (totalbodyposture +
          part2Score +
          selectedOption +
          selectedOpt +
          part6Score);

  double rateScore =
      totalbodyposture + part2Score + selectedOption + selectedOpt + part6Score;

  unfavorableResult = part6Score / rateScore;
  // frequencyResult = timeLevel / rateScore;
  totalResult = totalbodyposture / rateScore;
  effectiveResult = part2Score / rateScore;
  loadResult = selectedOption / rateScore;
  workResult = selectedOpt / rateScore;
}

bool one = false;
int _onechecked = 0;
int _twochecked = 0;
int _threechecked = 0;
int _fourchecked = 0;
int _fivechecked = 0;
int _sixchecked = 0;

class LhcPart1 extends StatelessWidget {
  const LhcPart1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIM LHC 量表評估工具 - 榮靜計畫',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // 移除 Debug 條
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  String formatTimeLevel(double level) {
    if (level % 1 == 0) {
      return level.toInt().toString();
    } else {
      return level.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9D6DE),
        title: const Text(
          'Catalog',
          style: TextStyle(
            fontWeight: FontWeight.bold, // 設置字體加粗
            fontSize: 20,
          ),
        ),
        centerTitle: true, // 標題居中
        ///添加Menu 來改變IP
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("IP Page"),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IpViewApp()),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Choose one of the following options:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 30),
            // 第一個選項
            TextOption(
              text: '1. Effective Load Weight',
              points: '$part2Score',
              onTap: () {
                _onechecked = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LhcPart2()),
                );
                debugPrint('Effective Load Weight tapped');
              },
            ),
            const SizedBox(height: 10),
            // 第二個選項
            TextOption(
              text: '2. Total Body Posture',
              points: '$totalbodyposture2',
              //points: '0',
              onTap: () {
                _twochecked = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Record1()),
                );
                debugPrint('Total body posture tapped');
              },
            ),
            const SizedBox(height: 10),
            // 第三個選項
            TextOption(
              text: '3. Frequency',
              points: formatTimeLevel(timeLevel - 1),
              onTap: () {
                _threechecked = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Two()),
                );
                debugPrint('Frequency tapped');
              },
            ),
            const SizedBox(height: 10),
            // 第四個選項
            TextOption(
              text: '4. Load Handling Conditions',
              points: '$selectedOption',
              onTap: () {
                _fourchecked = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LhcPart5()),
                );
                debugPrint('Load handling conditions tapped');
              },
            ),
            const SizedBox(height: 10),
            // 第五個選項
            TextOption(
              text: '5. Working Conditions',
              points: '$part6Score',
              onTap: () {
                _fivechecked = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Workingcondition()),
                );
                debugPrint('Unfavorable working conditions tapped');
              },
            ),
            const SizedBox(height: 10),
            // 第六個選項
            TextOption(
              text: '6. Work Organization',
              points: '$selectedOpt',
              onTap: () {
                _sixchecked = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LhcPart7()),
                );
                debugPrint('Work organization / temporal distribution tapped');
              },
            ),
            const SizedBox(height: 70),
            // 底部按鈕
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                onPressed: _onechecked.isNegative &&
                        _twochecked.isNegative &&
                        _threechecked.isNegative &&
                        _fourchecked.isNegative &&
                        _fivechecked.isNegative &&
                        _sixchecked.isNegative
                    ? () {
                        calculateresult();
                        debugPrint('$finalScore');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Result()),
                        );
                        debugPrint('Button tapped');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: const Color(0xFF8EC0E4), // 設置按鈕背景顏色
                  disabledBackgroundColor: Colors.grey[300], // 設置按鈕被禁用時的顏色
                  minimumSize: const Size(170, 50), // 設置按鈕的最小尺寸
                ),
                child: const Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 30, // 調整按鈕文字大小
                    fontWeight: FontWeight.bold, // 設置字體加粗
                    color: Colors.white, // 設置文字顏色
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextOption extends StatelessWidget {
  final String text;
  final String points;
  final VoidCallback onTap;

  const TextOption({
    super.key,
    required this.text,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 4.0), // 添加水平和垂直間距
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5F9).withOpacity(1),
          borderRadius: BorderRadius.circular(20.0), // 添加圓角
          border: Border.all(color: Colors.black), // 添加邊框
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold, // 設置字體加粗
                ),
              ),
            ),
            Text(
              points,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.blue, // 修改數字顏色
                fontWeight: FontWeight.bold, // 設置字體加粗
              ),
            ),
            const Text(
              ' points',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold, // 設置字體加粗
              ),
            ),
          ],
        ),
      ),
    );
  }
}
