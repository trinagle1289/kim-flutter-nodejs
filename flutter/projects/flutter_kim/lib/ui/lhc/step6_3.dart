import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

void main() => runApp(const Step6of3App());

class Step6of3App extends StatelessWidget {
  const Step6of3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'Button App', home: Step6of3Field());
}

class Step6of3Field extends StatefulWidget {
  const Step6of3Field({Key? key}) : super(key: key);

  @override
  State<Step6of3Field> createState() => Step6of3FieldState();
}

class Step6of3FieldState extends State<Step6of3Field> {
  List<bool> isOptionOneSelected = [false, false];
  List<bool> isOptionTwoSelected = [false, false];

  void updateTransportSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isOptionOneSelected.length; i++) {
        if (i == index) {
          isOptionOneSelected[i] = !isOptionOneSelected[i];
          if (isOptionOneSelected[i]) {
            step6fo3Data[0] = getOptionOneValue(i).toDouble();
          } else {
            step6fo3Data[0] = 0.0;
          }
        } else {
          isOptionOneSelected[i] = false;
        }
      }
    });
  }

  void updateSpaceSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isOptionTwoSelected.length; i++) {
        if (i == index) {
          isOptionTwoSelected[i] = !isOptionTwoSelected[i];
          if (isOptionTwoSelected[i]) {
            step6fo3Data[1] = getOptionTwoValue(i).toDouble();
          } else {
            step6fo3Data[1] = 0.0;
          }
        } else {
          isOptionTwoSelected[i] = false;
        }
      }
    });
  }

  int getOptionOneValue(int index) {
    switch (index) {
      case 0:
        return 1;
      case 1:
        return 2;
      default:
        return 0;
    }
  }

  int getOptionTwoValue(int index) {
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
      appBar: getTitleAppBar('Step 6(3/3)'),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 30),
          const Text('Unfavourable working conditions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text(
            'Force transfer/application',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(width: 8),
            buildCircularCheckboxTransport(0,
                'Loads difficult to grip / greater holding forces required / no shaped grips / work gloves'),
            buildCircularCheckboxTransport(1,
                'Loads hardly possible to grip / slippery, soft, sharp edges / no/unsuitable grips / work gloves'),
          ]),
          const SizedBox(height: 5),
          const Text('Clothes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(width: 8),
            buildCircularCheckboxSpace(0,
                'Additional physical workload due to impairing clothes or equipment (e.g. when wearing heavy rain jackets, whole-body protection suits, respiratory protective equipment, tool belts or the like)')
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => getLhcApp("7")));
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
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
                value: isOptionOneSelected[index],
                onChanged: (value) {
                  updateTransportSelectedIndex(index);
                },
                shape: const CircleBorder(),
                activeColor: Colors.blue),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 8),
                child: Text(subtitle,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
            const SizedBox(width: 8),
          ]),
          contentPadding: const EdgeInsets.all(0),
        ),
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
              value: isOptionTwoSelected[index],
              onChanged: (value) {
                updateSpaceSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 8),
                child: Text(subtitle,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
            const SizedBox(width: 8),
          ]),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}
