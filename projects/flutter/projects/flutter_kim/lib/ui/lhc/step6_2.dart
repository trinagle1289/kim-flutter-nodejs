import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

var handImgPath = 'assets/lhc/Unfavourable_Working_Conditions/hand_and_arm.png';

void main() => runApp(const Step6of2App());

class Step6of2App extends StatelessWidget {
  const Step6of2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'Button App', home: Step6of2Field());
}

class Step6of2Field extends StatefulWidget {
  const Step6of2Field({Key? key}) : super(key: key);

  @override
  Step6of2FieldState createState() => Step6of2FieldState();
}

class Step6of2FieldState extends State<Step6of2Field> {
  List<bool> isOptionThreeSelected = [false, false];
  List<bool> isOptionFourSelected = [false, false];

  void updateTransportSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isOptionThreeSelected.length; i++) {
        if (i == index) {
          isOptionThreeSelected[i] = !isOptionThreeSelected[i];
          if (isOptionThreeSelected[i]) {
            step6fo2Data[0] = getOptionThreeValue(i).toDouble();
          } else {
            step6fo2Data[0] = 0.0;
          }
        } else {
          isOptionThreeSelected[i] = false;
        }
      }
    });
  }

  void updateSpaceSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isOptionFourSelected.length; i++) {
        if (i == index) {
          isOptionFourSelected[i] = !isOptionFourSelected[i];
          if (isOptionFourSelected[i]) {
            step6fo2Data[1] = getOptionFourValue(i).toDouble();
          } else {
            step6fo2Data[1] = 0.0;
          }
        } else {
          isOptionFourSelected[i] = false;
        }
      }
    });
  }

  int getOptionThreeValue(int index) {
    switch (index) {
      case 0:
        return 1;
      case 1:
        return 2;
      default:
        return 0;
    }
  }

  int getOptionFourValue(int index) {
    switch (index) {
      case 0:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar('Step 6(2/3)'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text('Unfavourable working conditions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Hand/arm position and movement',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          // 手/手臂圖片
          Image.asset(handImgPath, width: 350, height: 90),

          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            buildCircularCheckboxTransport(
                0, 'Occasionally at the limit of the movement ranges'),
            buildCircularCheckboxTransport(
                1, 'Frequently/constantly at the limit of the movement ranges'),
          ]),
          const SizedBox(height: 5),
          const Text('Adverse ambient conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(width: 8),
            buildCircularCheckboxSpace(0,
                'Unfavourable weather conditions and/or physical workloads caused by heat, draught, cold, wet')
          ]),
          const SizedBox(height: 5),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // 上一步按鈕
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
              // 在這裡處理下一步按鈕的程式碼
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => getLhcApp("6-3")));
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(170, 50))),
              child: const Text('Next',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildCircularCheckboxTransport(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ListTile(
            title: Row(children: [
              Checkbox(
                  value: isOptionThreeSelected[index],
                  onChanged: (value) {
                    updateTransportSelectedIndex(index);
                  },
                  shape: const CircleBorder(),
                  activeColor: Colors.blue),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Text(subtitle,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 8),
            ]),
            contentPadding: const EdgeInsets.all(0)),
      ),
    );
  }

  Widget buildCircularCheckboxSpace(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ListTile(
            title: Row(children: [
              Checkbox(
                  value: isOptionFourSelected[index],
                  onChanged: (value) {
                    updateSpaceSelectedIndex(index);
                  },
                  shape: const CircleBorder(),
                  activeColor: Colors.blue),
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
            ]),
            contentPadding: const EdgeInsets.all(0)),
      ),
    );
  }
}
