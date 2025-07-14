import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nếu muốn định dạng giờ nâng cao

class WelcomeBanner extends StatelessWidget {
  final dynamic currentUser; // Thay bằng kiểu thực tế nếu có

  const WelcomeBanner({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final bool isDay = hour >= 6 && hour < 18; // 6h sáng đến 18h tối là ban ngày

    final Color bgColor = isDay ? Colors.blue[200]! : Colors.black;
    final IconData icon = isDay ? Icons.wb_sunny : Icons.nightlight_round;
    final Color iconColor = isDay ? Colors.orange : Colors.yellowAccent;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xin chào ${currentUser?.name ?? 'Khách'}!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDay ? Colors.black : Colors.white,
                  ),
                ),
                Text(
                  isDay ? "Chúc bạn buổi sáng vui vẻ" : "Chúc bạn buổi tối thư giãn",
                  style: TextStyle(
                    color: isDay ? Colors.grey[800] : Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            color: iconColor,
            size: 36,
          ),
        ],
      ),
    );
  }
}
