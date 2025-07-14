import 'package:flutter/material.dart';

class Phandau extends StatelessWidget {
  const Phandau({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xin chào Toàn !",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Chúc bạn mỗi ngày tốt lành",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}