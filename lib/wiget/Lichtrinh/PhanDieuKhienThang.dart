import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhanDieuKhienThang extends StatelessWidget {
  final DateTime currentDate;
  final Function(int) onMonthChanged;

  const PhanDieuKhienThang({
    required this.currentDate,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 30),
            onPressed: () => onMonthChanged(-1),
          ),
          Text(
            DateFormat('MMMM yyyy').format(currentDate),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 30),
            onPressed: () => onMonthChanged(1),
          ),
        ],
      ),
    );
  }
}