import 'package:flutter/material.dart';
import 'package:junior_app_20240607/text/lhc_part2.dart';
import 'package:junior_app_20240607/kim-lhc/part1.dart';

String _gender = '';
int part2_score = 0;
double part2_slider_value = 3;

void main() {
  runApp(const Lhc_Part2());
}

class Lhc_Part2 extends StatelessWidget {
  const Lhc_Part2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIM_LHC_Part2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC9D6DE),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Effective load weight:', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                TextSpan(text: ' $part2_score ', style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold)),
                TextSpan(text: 'point', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),

      body: Column(   //ListView(滑動螢幕)，Column(垂直排列)
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(   // 背景框
                    color: Color(0xFFF0F5F9).withOpacity(1), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圆角邊角
                    border: Border.all(
                      color: Colors.black, // 邊框颜色
                      width: 2.5, // 邊框宽度
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Gender',
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
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
                                          ? Border.all(color: Colors.blue, width: 2.0)
                                          : null,
                                    ),
                                    child: Image.asset('assets/picture/LHC/man.png'), //https://www.flaticon.com/free-icons/people
                                  ),
                                ),
                                Text(
                                  'Male',
                                  style: TextStyle(
                                    color: _gender == 'Male' ? Colors.blue : Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),

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
                                          ? Border.all(color: Colors.blue, width: 2.0)
                                          : null,
                                    ),
                                    child: Image.asset('assets/picture/LHC/woman.png'), //https://www.flaticon.com/free-icons/female
                                  ),
                                ),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    color: _gender == 'Female' ? Colors.blue : Colors.black,
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
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(   // 背景框
                    color: Color(0xFFF0F5F9), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圆角邊角
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
                            Text(
                              'Effective load weight',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            Tooltip(
                              message: 'more information。',
                              child: IconButton(
                                icon: Icon(Icons.help_outline),
                                color: Colors.black,
                                onPressed: () {
                                  lhc_part2_text(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        //slider文字框部分
                        Container(
                          width: 180.0, // 設定寬度
                          height: 50.0, // 設定高度
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF6AAFE6)), // 外框顏色
                            color: Color(0xFF8EC0E4), // 背景顏色
                            borderRadius: BorderRadius.circular(10.0), // 邊角弧度
                          ),
                          child: Center(
                            child: Text(
                              part2_slider_value > 40 ? 'weight: > 40 kg' : 'weight: ${part2_slider_value.toStringAsFixed(0)} kg',
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        //滑桿主體部分
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Slider(
                                    value: part2_slider_value,
                                    onChanged: (newValue) {
                                      setState(() {
                                        part2_slider_value = newValue;
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
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //減分按鈕
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width:2.0),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_gender.isNotEmpty && part2_slider_value > 3) {
                                          part2_slider_value -= 1;
                                          updateScore();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 120),
                                //加分按鈕
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width:2.0),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        if (_gender.isNotEmpty && part2_slider_value <= 40) {
                                          part2_slider_value += 1;
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
              ],
            ),
          ),
        ],
      ),

      //save按鈕
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),    //左上右下
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _gender.isNotEmpty ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lhc_Part1()),
                );
              } : null,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey[300]!;
                  }
                  return const Color(0xFF8EC0E4);
                }),
                minimumSize: MaterialStateProperty.all<Size>(const Size(170, 50)),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),


    );
  }

  //計算分數(part2_score)
  void updateScore() {
    if (_gender == 'Male') {
      if (part2_slider_value < 3) {
        part2_score = 0;
      } else if (part2_slider_value > 2  && part2_slider_value <= 5) {
        part2_score = 4;
      } else if (part2_slider_value > 5 && part2_slider_value <= 10) {
        part2_score = 6;
      } else if (part2_slider_value > 10 && part2_slider_value <= 15) {
        part2_score = 8;
      } else if (part2_slider_value > 15 && part2_slider_value <= 20) {
        part2_score = 11;
      } else if (part2_slider_value > 20 && part2_slider_value <= 25) {
        part2_score = 15;
      } else if (part2_slider_value > 25 && part2_slider_value <= 30) {
        part2_score = 25;
      } else if (part2_slider_value > 30 && part2_slider_value <= 35) {
        part2_score = 35;
      } else if (part2_slider_value > 35 && part2_slider_value <= 40) {
        part2_score = 75;
      } else {
        part2_score = 100;
      }
    } else {
      if (part2_slider_value < 3) {
        part2_score = 0;
      } else if (part2_slider_value > 2 && part2_slider_value <= 5) {
        part2_score = 6;
      } else if (part2_slider_value > 5 && part2_slider_value <= 10) {
        part2_score = 9;
      } else if (part2_slider_value > 10 && part2_slider_value <= 15) {
        part2_score = 12;
      } else if (part2_slider_value > 15 && part2_slider_value <= 20) {
        part2_score = 25;
      } else if (part2_slider_value > 20 && part2_slider_value <= 25) {
        part2_score = 75;
      } else if (part2_slider_value > 25 && part2_slider_value <= 30) {
        part2_score = 85;
      } else if (part2_slider_value > 30 && part2_slider_value <= 35) {
        part2_score = 100;
      } else if (part2_slider_value > 35 && part2_slider_value <= 40) {
        part2_score = 100;
      } else {
        part2_score = 100;
      }
    }
    setState(() {});
  }
}
