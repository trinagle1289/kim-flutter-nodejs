import 'package:flutter/material.dart';

void lhcPart7(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '"Good: Load is handled with both hands and symmetrically.\n'
            'Restricted: Load is handled temporarily with one hand and/or asymmetrically, uneven load distribution between the two hands.\n'
            'Unfavorable: Load is handled predominantly with one hand or unstable load centre.',
            style: TextStyle(
              color: Colors.blue, // 文字顏色
              fontSize: 24.0, // 文字大小
              fontWeight: FontWeight.bold, // 文字粗細
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              '關閉',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
