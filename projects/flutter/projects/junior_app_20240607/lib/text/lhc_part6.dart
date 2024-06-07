import 'package:flutter/material.dart';

void Loads (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('Occasionally : "Loads difficult to grip / greater holding forces required / no shaped grips / work gloves"\nVery : "Loads hardly possible to grip / slippery, soft, sharp edges / no/unsuitable grips / work gloves"',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}

void Unfavorable (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('"Unfavourable weather conditions and/or physical workloads caused by heat, draught, cold, wet"',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}

void Spatial (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('Restricted : "Work area of less than 1.5 m², floor is moderately dirty and slightly uneven, slight inclination of up to 5°,slightly restricted stability, load must be positioned precisely" \nUnfavorable : "Significantly restricted freedom of movement or space for movement is not high enough, working in confined spaces, floor is very dirty, uneven or roughly cobbled, steps / potholes, stronger inclination of 5-10°, restricted stability, load must be positioned very precisely"',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}

void Additional (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('"Additional physical workload due to impairing clothes or equipment (e.g. when wearing heavy rain jackets, whole-body protection suits, respiratory protective equipment, tool belts or the like) "',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}

void Difficulties (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('Holds for 5~10 seconds : "The load has to be held between > 5 and 10 seconds or carried over a distance between > 2 m and 5 m"\nHold for > 10 seconds : " The load has to be held > 10 seconds or carried over a distance > 5 m."',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('關閉', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}