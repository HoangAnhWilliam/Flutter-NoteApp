import 'package:flutter/material.dart';

class Thenhomviec extends StatelessWidget {
  final Color color;
  final String timeText;
  final Color timeColor;
  final String title;
  final VoidCallback onPressed;

  const Thenhomviec({
    Key? key,
    required this.color,
    required this.timeText,
    required this.timeColor,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              timeText,
              style: TextStyle(fontSize: 12, color: timeColor),
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_right_alt, size: 20),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}