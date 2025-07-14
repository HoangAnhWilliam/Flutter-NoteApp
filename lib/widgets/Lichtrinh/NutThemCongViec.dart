import 'package:flutter/material.dart';
import 'package:do_an/models/nhomviec.dart';
import 'package:do_an/items/ThemNhiemVu.dart';
import 'package:do_an/models/nhiemvu.dart';

class NutThemCongViec extends StatelessWidget {
  final List<NhomViec> availableGroups;
  final Function(NhiemVuModel)? onTaskAdded;

  const NutThemCongViec({
    super.key,
    required this.availableGroups,
    this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThemNhiemVu(
                availableGroups: availableGroups,
                onTaskAdded: onTaskAdded,
              ),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Thêm công việc'),
          ],
        ),
      ),
    );
  }
}