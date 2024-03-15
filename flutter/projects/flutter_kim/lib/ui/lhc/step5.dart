import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

void main() => runApp(const Step5App());

class Step5App extends StatelessWidget {
  const Step5App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Step5Field());
  }
}

class Step5Field extends StatefulWidget {
  const Step5Field({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  Step5FieldState createState() => Step5FieldState();
}

class Step5FieldState extends State<Step5Field> {
  List<bool> isSelected = [false, false, false];
  // 用於儲存選擇的結果，初始值設為-1

  void updateSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        if (i == index) {
          isSelected[i] = true;
          step5Data = getOptionValue(i).toDouble(); // 更新選擇的結果
        } else {
          isSelected[i] = false;
        }
      }
    });
  }

  int getOptionValue(int index) {
    switch (index) {
      case 0:
        return 0; // 良好對應到0
      case 1:
        return 2; // 受限對應到2
      case 2:
        return 4; // 不良對應到4
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar('Step 5'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          // 副標題
          const Text(
            'Load handling conditions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          // 內容
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildCircularCheckbox(0, 'Good',
                      '(Load is handled with both hands and symmetrically)'),
                  buildCircularCheckbox(1, 'Restricted',
                      '(Load is handled temporarily with one hand and/or asymmetrically, uneven load distribution between the two hands)'),
                  buildCircularCheckbox(2, 'Unfavourable',
                      '(Load is handled predominantly with one hand or unstable load centre)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(170, 50))),
                child: const Text('Back',
                    style: TextStyle(fontSize: 30, color: Colors.white)),
              ),
              const SizedBox(width: 13),

              // 下一步按鈕
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => getLhcApp("6-1")));
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
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildCircularCheckbox(int index, String title, String subtitle) {
    return Center(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 30, color: Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        leading: Checkbox(
          value: isSelected[index],
          onChanged: (value) {
            updateSelectedIndex(index);
          },
          shape: const CircleBorder(),
          activeColor: Colors.blue,
        ),
      ),
    );
  }
}
