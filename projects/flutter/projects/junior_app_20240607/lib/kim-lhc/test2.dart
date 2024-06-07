import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _value = 0;
  List product = [
    {'id': '1', 'name': 'Watch', 'price': '3200', 'category': 'wearable'},
    {'id': '2', 'name': 'T-Shirt', 'price': '520', 'category': 'wearable'},
    {'id': '3', 'name': 'Jeans', 'price': '840', 'category': 'wearable'},
    {
      'id': '4',
      'name': 'refrigerator',
      'price': '1800',
      'category': 'wearable'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Products Filter",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _value = (_value - 10).clamp(0, 4000);
                    });
                  },
                  icon: Icon(Icons.remove),
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 4000,
                    onChanged: (double value) {
                      setState(() {
                        _value = value;
                      });
                    },
                    value: _value,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _value = (_value + 10).clamp(0, 4000);
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Text(
              "All Products < Rs. ${_value.toInt()}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Column(
              children: product.map((e) {
                if (double.parse(e['price']) < _value) {
                  return Container(
                    height: 80,
                    width: w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(e['id'])],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 0)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(e['name']), Text(e['category'])],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(e['price']),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Container();
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}