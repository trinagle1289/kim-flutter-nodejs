import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

void main() => runApp(const Step6of1App());

class Step6of1App extends StatelessWidget {
  const Step6of1App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'Button App', home: Step6of1Field());
}

class Step6of1Field extends StatefulWidget {
  const Step6of1Field({Key? key}) : super(key: key);

  @override
  Step6of1FieldState createState() => Step6of1FieldState();
}

class Step6of1FieldState extends State<Step6of1Field> {
  List<bool> isTransportSelected = [false, false];
  List<bool> isSpaceSelected = [false, false];

  void updateTransportSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isTransportSelected.length; i++) {
        if (i == index) {
          isTransportSelected[i] = !isTransportSelected[i];
          if (isTransportSelected[i]) {
            step6fo1Data[0] = getTransportValue(i).toDouble();
          } else {
            step6fo1Data[0] = 0.0;
          }
        } else {
          isTransportSelected[i] = false;
        }
      }
    });
  }

  void updateSpaceSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isSpaceSelected.length; i++) {
        if (i == index) {
          isSpaceSelected[i] = !isSpaceSelected[i];
          if (isSpaceSelected[i]) {
            step6fo1Data[1] = getSpaceValue(i).toDouble();
          } else {
            step6fo1Data[1] = 0.0;
          }
        } else {
          isSpaceSelected[i] = false;
        }
      }
    });
  }

  int getTransportValue(int index) {
    switch (index) {
      case 0:
        return 2;
      case 1:
        return 5;
      default:
        return 0;
    }
  }

  int getSpaceValue(int index) {
    switch (index) {
      case 0:
        return 1;
      case 1:
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar('Step 6(1/3)'),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 30),
          const Text('Unfavourable working conditions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Difficulties due to holding / carrying',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              buildCircularCheckboxTransport(0,
                  'The load has to be held between > 5 and 10 seconds or carriedover a distance between > 2 m and 5 m.'),
              buildCircularCheckboxTransport(1,
                  'The load has to be held > 10 seconds or carried over a\ndistance > 5 m.'),
            ],
          ),
          const SizedBox(height: 5),
          const Text('Spatial conditions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(width: 8),
            buildCircularCheckboxSpace(0,
                'Work area of less than 1.5 m², floor is moderately dirty and slightly uneven, slight inclination of up to 5°, slightly restricted stability, load must be positioned precisely'),
            buildCircularCheckboxSpace(1,
                'Significantly restricted freedom of movement or space for movement is not high enough, working in confined spaces, floor is very dirty, uneven or roughly cobbled, steps / potholes, stronger inclination of 5-10°, restricted stability, load must be positioned very precisely'),
          ]),
          const SizedBox(height: 5),
        ]),
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
                    MaterialPageRoute(builder: (context) => getLhcApp("6-2")));
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
                  value: isTransportSelected[index],
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
                  value: isSpaceSelected[index],
                  onChanged: (value) {
                    updateSpaceSelectedIndex(index);
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
}
