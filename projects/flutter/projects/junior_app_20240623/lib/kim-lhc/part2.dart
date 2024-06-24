import 'package:flutter/material.dart';
import 'package:junior_app_20240623/text/lhc_part2.dart';
import 'package:junior_app_20240623/kim-lhc/part1.dart';

String _gender = '';
int part2Score = 0;
double part2SliderValue = 3;

void main() {
  runApp(const LhcPart2());
}

class LhcPart2 extends StatelessWidget {
  const LhcPart2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIM_LHC_Part2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9D6DE),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                    text: 'Effective Load Weight:',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' $part2Score ',
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                const TextSpan(
                    text: 'points',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        // ListView(滑動螢幕)，Column(垂直排列)
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    // 背景框
                    color: const Color(0xFFF0F5F9).withOpacity(1), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圓角邊角
                    border: Border.all(
                      color: Colors.black, // 邊框颜色
                      width: 2.5, // 邊框宽度
                    ),
                  ),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'Gender',
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Male選項
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _gender = 'Male';
                                      updateScore();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: _gender == 'Male'
                                          ? Border.all(
                                          color: Colors.blue, width: 2.0)
                                          : null,
                                    ),
                                    child: Image.asset(
                                        'assets/picture/LHC/man.png'), // https://www.flaticon.com/free-icons/people
                                  ),
                                ),
                                Text(
                                  'Male',
                                  style: TextStyle(
                                    color: _gender == 'Male'
                                        ? Colors.blue
                                        : Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Female選項
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _gender = 'Female';
                                      updateScore();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: _gender == 'Female'
                                          ? Border.all(
                                          color: Colors.blue, width: 2.0)
                                          : null,
                                    ),
                                    child: Image.asset(
                                        'assets/picture/LHC/woman.png'), // https://www.flaticon.com/free-icons/female
                                  ),
                                ),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    color: _gender == 'Female'
                                        ? Colors.blue
                                        : Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //滑桿那塊(Effective load weight)
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    // 背景框
                    color: const Color(0xFFF0F5F9), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圓角邊角
                    border: Border.all(
                      color: Colors.black, // 邊框颜色
                      width: 2.5, // 邊框宽度
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Effective Load Weight',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            Tooltip(
                              message: 'more information。',
                              child: IconButton(
                                icon: const Icon(Icons.help_outline),
                                color: Colors.black,
                                onPressed: () {
                                  lhcPart2Text(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //slider文字框部分
                        Container(
                          width: 180.0, // 設定寬度
                          height: 50.0, // 設定高度
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF6AAFE6)), // 外框顏色
                            color: const Color(0xFF8EC0E4), // 背景顏色
                            borderRadius: BorderRadius.circular(10.0), // 邊角弧度
                          ),
                          child: Center(
                            child: Text(
                              part2SliderValue > 40
                                  ? 'weight: > 40 kg'
                                  : 'Weight: ${part2SliderValue.toStringAsFixed(0)} kg',
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //滑桿主體部分
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Slider(
                                    value: part2SliderValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        part2SliderValue = newValue;
                                        if (_gender.isNotEmpty) {
                                          updateScore();
                                        }
                                      });
                                    },
                                    min: 3,
                                    max: 41,
                                    divisions: 38,
                                    activeColor: Colors.blue, // 活動條的顏色
                                    inactiveColor: Colors.grey, // 非活動條的顏色
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //減分按鈕
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (part2SliderValue > 3) {
                                          part2SliderValue -= 1;
                                          updateScore();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 120),
                                //加分按鈕
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        if (part2SliderValue <= 40) {
                                          part2SliderValue += 1;
                                          updateScore();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Save按鈕
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _gender.isNotEmpty
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LhcPart1()),
                      );
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
                      'Save',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //計算分數(part2_score)
  void updateScore() {
    if (_gender == 'Male') {
      if (part2SliderValue < 3) {
        part2Score = 0;
      } else if (part2SliderValue > 2 && part2SliderValue <= 5) {
        part2Score = 4;
      } else if (part2SliderValue > 5 && part2SliderValue <= 10) {
        part2Score = 6;
      } else if (part2SliderValue > 10 && part2SliderValue <= 15) {
        part2Score = 8;
      } else if (part2SliderValue > 15 && part2SliderValue <= 20) {
        part2Score = 11;
      } else if (part2SliderValue > 20 && part2SliderValue <= 25) {
        part2Score = 15;
      } else if (part2SliderValue > 25 && part2SliderValue <= 30) {
        part2Score = 25;
      } else if (part2SliderValue > 30 && part2SliderValue <= 35) {
        part2Score = 35;
      } else if (part2SliderValue > 35 && part2SliderValue <= 40) {
        part2Score = 75;
      } else {
        part2Score = 100;
      }
    } else {
      if (part2SliderValue < 3) {
        part2Score = 0;
      } else if (part2SliderValue > 2 && part2SliderValue <= 5) {
        part2Score = 6;
      } else if (part2SliderValue > 5 && part2SliderValue <= 10) {
        part2Score = 9;
      } else if (part2SliderValue > 10 && part2SliderValue <= 15) {
        part2Score = 12;
      } else if (part2SliderValue > 15 && part2SliderValue <= 20) {
        part2Score = 25;
      } else if (part2SliderValue > 20 && part2SliderValue <= 25) {
        part2Score = 75;
      } else if (part2SliderValue > 25 && part2SliderValue <= 30) {
        part2Score = 85;
      } else if (part2SliderValue > 30 && part2SliderValue <= 35) {
        part2Score = 100;
      } else if (part2SliderValue > 35 && part2SliderValue <= 40) {
        part2Score = 100;
      } else {
        part2Score = 100;
      }
    }
    setState(() {});
  }
}
