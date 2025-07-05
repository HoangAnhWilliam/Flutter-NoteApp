import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/nhiemvu.dart';

class DanhSachCongViec extends StatelessWidget {
  final DateTime selectedDate;
  final List<NhiemVuModel> tasks;
  final Function(NhiemVuModel) onTaskStatusChanged;
  final Function(NhiemVuModel) onTaskEdited;
  final Function(NhiemVuModel) onTaskDeleted;

  const DanhSachCongViec({
    required this.selectedDate,
    required this.tasks,
    required this.onTaskStatusChanged,
    required this.onTaskEdited,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Công việc ngày ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (tasks.isEmpty)
            const Text('Không có công việc nào trong ngày này',
                style: TextStyle(color: Colors.grey))
          else
            Column(
              children: tasks.map((task) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                    color: task.isCompleted ? Colors.green : Colors.blue,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (task.subtitle.isNotEmpty)
                        Text(
                          task.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task.isCompleted ? Icons.undo : Icons.done,
                          color: task.isCompleted ? Colors.orange : Colors.green,
                        ),
                        onPressed: () => onTaskStatusChanged(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onTaskEdited(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onTaskDeleted(task),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}