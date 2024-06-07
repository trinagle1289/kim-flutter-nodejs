import 'package:flutter/material.dart';
import 'package:junior_app_20240607/kim-lhc/part2.dart';
import 'package:junior_app_20240607/kim-lhc/part3.dart';
import 'package:junior_app_20240607/kim-lhc/part5.dart';
import 'package:junior_app_20240607/kim-lhc/part6.dart';
import 'package:junior_app_20240607/kim-lhc/part7.dart';
import 'package:junior_app_20240607/kim-lhc/record1.dart';
import 'package:junior_app_20240607/kim-lhc/record2.dart';
import 'package:junior_app_20240607/kim-lhc/result.dart';

void main() {
  runApp(Lhc_Part1());
}

double final_score = 0;
double Unfavorable_result = 0;
double Frequency_result = 0;
double Total_result = 0;
double Effective_result = 0;
double Load_result = 0;
double Work_result = 0;

void calculateresult() {
  final_score = (timeLevel) *
      (totalbodyposture +
          part2_score +
          selectedOption +
          selectedOpt +
          part6_score);

  Unfavorable_result = part6_score / 13;
  Frequency_result = timeLevel / 10;
  Total_result = totalbodyposture / 20;
  Effective_result = part2_score / 100;
  Load_result = selectedOption / 4;
  Work_result = selectedOpt / 4;
}

class Lhc_Part1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // 移除 Debug 條
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
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
        backgroundColor: Color(0xFFC9D6DE),
        title: Text(
          'Catalog',
          style: TextStyle(
            fontWeight: FontWeight.bold, // 設置字體加粗
            fontSize: 20,
          ),
        ),
        centerTitle: true, // 標題居中
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Choose one of the following options:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 30),
            // 第一個選項
            TextOption(
              text: '1. Effective load weight',
              points: '$part2_score',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lhc_Part2()),
                );
                print('Effective load weight tapped');
              },
            ),
            const SizedBox(height: 20),
            // 第二個選項
            TextOption(
              text: '2. Total body posture',
              points: '$totalbodyposture',
              //points: '0',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => record1()),
                );
                print('Total body posture tapped');
              },
            ),
            const SizedBox(height: 20),
            // 第三個選項
            TextOption(
              text: '3. Frequency',
              points: '${formatTimeLevel(timeLevel)}',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Two()),
                );
                print('Frequency tapped');
              },
            ),
            const SizedBox(height: 20),
            // 第四個選項
            TextOption(
              text: '4. Load handling conditions',
              points: '$selectedOption',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lhc_Part5()),
                );
                print('Load handling conditions tapped');
              },
            ),
            const SizedBox(height: 20),
            // 第五個選項
            TextOption(
              text: '5. Unfavorable working conditions',
              points: '$part6_score',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Workingcondition()),
                );
                print('Unfavorable working conditions tapped');
              },
            ),
            const SizedBox(height: 20),
            // 第六個選項
            TextOption(
              text: '6. Work organization',
              points: '$selectedOpt',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lhc_Part7()),
                );
                print('Work organization / temporal distribution tapped');
              },
            ),
            const SizedBox(height: 50),
            // 底部按鈕
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  calculateresult();
                  print('$final_score');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Result()),
                  );
                  print('Button tapped');
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 20, // 調整按鈕文字大小
                    fontWeight: FontWeight.bold, // 設置字體加粗
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 40), // 調整按鈕內邊距
                  backgroundColor: Color(0xFF8EC0E4), // 設置按鈕背景色
                ),
                child: Text(
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
    required this.text,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0), // 添加水平和垂直間距
        decoration: BoxDecoration(
          color: Color(0xFFF0F5F9).withOpacity(1),
          borderRadius: BorderRadius.circular(20.0), // 添加圓角
          border: Border.all(color: Colors.black), // 添加邊框
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold, // 設置字體加粗
                ),
              ),
            ),
            Text(
              points,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blue, // 修改數字顏色
                fontWeight: FontWeight.bold, // 設置字體加粗
              ),
            ),
            Text(
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
