import 'package:flutter/material.dart';

class TheItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const TheItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Checkbox(value: false, onChanged: (_) {}),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800]),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 14),
              SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}