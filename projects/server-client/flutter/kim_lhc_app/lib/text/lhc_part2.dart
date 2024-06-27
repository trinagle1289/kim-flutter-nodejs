import 'package:flutter/material.dart';

void lhc_part2_text(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Information',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: const Text(
            'Effective load weight refers to the physical workload which the employee actually has to apply. '
                'When tilting a cardboard box, only approximately 50 % of the load weight has an effect and when carrying a load in pairs, approximately 60 % of '
                'the load weight has an effect per person (in case of increased requirements with respect to load control and coordination, more than 50 % must '
                'be assumed).',
            style: TextStyle(
              color: Colors.blue, // 文字顏色
              fontSize: 24.0, // 文字大小
              fontWeight: FontWeight.bold, // 文字粗細
              // fontStyle: FontStyle.italic, // 文字樣式
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
