import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

double c3 = -1;
int c4 = -1;

void main() => runApp(const Step2App());

class Step2App extends StatelessWidget {
  const Step2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Button App',
        home: Step2Field(),
      );
}

class Step2Field extends StatefulWidget {
  const Step2Field({Key? key}) : super(key: key);

  @override
  Step2FieldState createState() => Step2FieldState();
}

class Step2FieldState extends State<Step2Field> {
  List<bool> c1Select = [false, false];
  List<bool> c2Select = [false, false];
  List<bool> c3Select = [false, false];
  List<bool> c4Select = [false, false];

  /*num c1 = -1;
  num c2 = -1;
  num c3 = -1;
  num c4 = -1;*/

  void C1(int index) {
    setState(() {
      for (int i = 0; i < c1Select.length; i++) {
        if (i == index) {
          c1Select[i] = !c1Select[i];
          if (c1Select[i]) {
            step2Data[0] = getc1Value(i);
          } else {
            step2Data[0] = 0.0;
          }
        } else {
          c1Select[i] = false;
        }
      }
    });
  }

  void C2(int index) {
    setState(() {
      for (int i = 0; i < c2Select.length; i++) {
        if (i == index) {
          c2Select[i] = !c2Select[i];
          if (c2Select[i]) {
            step2Data[1] = getc2Value(i);
          } else {
            step2Data[1] = 0.0;
          }
        } else {
          c2Select[i] = false;
        }
      }
    });
  }

  void C3(int index) {
    setState(() {
      for (int i = 0; i < c3Select.length; i++) {
        if (i == index) {
          c3Select[i] = !c3Select[i];
          if (c3Select[i]) {
            step2Data[2] = getc3Value(i);
          } else {
            step2Data[2] = 0.0;
          }
        } else {
          c3Select[i] = false;
        }
      }
    });
  }

  void C4(int index) {
    setState(() {
      for (int i = 0; i < c4Select.length; i++) {
        if (i == index) {
          c4Select[i] = !c4Select[i];
          if (c4Select[i]) {
            step2Data[3] = getc4Value(i);
          } else {
            step2Data[3] = 0.0;
          }
        } else {
          c4Select[i] = false;
        }
      }
    });
  }

  double getc1Value(int index) {
    switch (index) {
      case 0:
        return 1.0;
      case 1:
        return 3.0;
      default:
        return 0.0;
    }
  }

  double getc2Value(int index) {
    switch (index) {
      case 0:
        return 1.0;
      case 1:
        return 3.0;
      default:
        return 0.0;
    }
  }

  double getc3Value(int index) {
    switch (index) {
      case 0:
        return 0.5;
      case 1:
        return 1.0;
      default:
        return 0.0;
    }
  }

  double getc4Value(int index) {
    switch (index) {
      case 0:
        return 1.0;
      case 1:
        return 2.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar('Step 2'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Pody Posture\n(Additional Points)',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 0),
            // const Text(
            //   '額外加分',
            //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 4),
                buildCircularCheckboxC1(0,
                    'Occasional twisting and/or lateral inclination of the trunk identifiable.'),
                buildCircularCheckboxC1(1,
                    'Frequent / constant twisting and/or lateral inclination of the trunk identifiable'),
              ],
            ),
            const SizedBox(height: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                buildCircularCheckboxC2(0,
                    'Load centre and/or hands occasionally at a distance from the body'),
                buildCircularCheckboxC2(1,
                    'Load centre and/or hands frequently / constantly at a distance from the body'),
              ],
            ),
            const SizedBox(height: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                buildCircularCheckboxC3(0,
                    'Arms raised occasionally, hands between elbow and shoulder level'),
                buildCircularCheckboxC3(1,
                    'Arms raised frequently / constantly, hands between elbow and shoulder level'),
              ],
            ),
            const SizedBox(height: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                buildCircularCheckboxC4(
                    0, 'Hands occasionally above shoulder height'),
                buildCircularCheckboxC4(
                    1, 'Hands frequently / constantly above shoulder height'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // 上一步按鈕
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(170, 50))),
              child: const Text('Back',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),

            // 下一步按鈕
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => getLhcApp("3")));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(170, 50)),
              ),
              child: const Text('Next',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildCircularCheckboxC1(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ListTile(
          title: Row(
            children: [
              Checkbox(
                value: c1Select[index],
                onChanged: (value) {
                  C1(index);
                },
                shape: const CircleBorder(),
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Text(subtitle,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  Widget buildCircularCheckboxC2(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ListTile(
          title: Row(
            children: [
              Checkbox(
                value: c2Select[index],
                onChanged: (value) {
                  C2(index);
                },
                shape: const CircleBorder(),
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Text(
                    subtitle,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  Widget buildCircularCheckboxC3(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ListTile(
          title: Row(
            children: [
              Checkbox(
                value: c3Select[index],
                onChanged: (value) {
                  C3(index);
                },
                shape: const CircleBorder(),
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Text(
                    subtitle,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  Widget buildCircularCheckboxC4(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ListTile(
          title: Row(
            children: [
              Checkbox(
                value: c4Select[index],
                onChanged: (value) {
                  C4(index);
                },
                shape: const CircleBorder(),
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Text(
                    subtitle,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}
