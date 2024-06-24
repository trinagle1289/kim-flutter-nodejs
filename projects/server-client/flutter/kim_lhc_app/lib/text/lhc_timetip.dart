import 'package:flutter/material.dart';

void lhcPart2Text (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detailed information', style: TextStyle(fontSize:28.0, fontWeight: FontWeight.bold), ),
        content: const Text('Using the concept of "actual load bearing,'
            '" if two people carry heavy objects together, each person bears approximately 60% of the weight '
            '(assuming it exceeds 50% for control and coordination purposes).',
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
            child: const Text('關閉', style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}