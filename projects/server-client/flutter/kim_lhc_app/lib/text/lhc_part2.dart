import 'package:flutter/material.dart';

void lhc_part2_text (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('Based on "actual load," if two people are carrying a heavy object together, '
            'each person is assumed to bear approximately 60% of the weight (to account for control and coordination, '
            'it is assumed to exceed 50%).',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
            //fontStyle: FontStyle.italic, // 文字樣式
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