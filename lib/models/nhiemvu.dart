import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NhiemVuModel {
  final String id;
  late final String title;
  late final String subtitle;
  late final DateTime date;
  late final TimeOfDay startTime;
  late final TimeOfDay endTime;
  bool isCompleted;
  final String? userId;
  final String? groupId;

  NhiemVuModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
    this.userId,
    this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'isCompleted': isCompleted,
      'userId': userId,
      'groupId': groupId,
    };
  }

  factory NhiemVuModel.fromJson(Map<String, dynamic> json) {
    final startParts = (json['startTime'] ?? '00:00').toString().split(':');
    final endParts = (json['endTime'] ?? '23:59').toString().split(':');
    
    return NhiemVuModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
      isCompleted: json['isCompleted'] ?? false,
      userId: json['userId'],
      groupId: json['groupId'],
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formattedTimeRange(BuildContext context) {
    return '${startTime.format(context)} - ${endTime.format(context)}';
  }

  Duration get duration {
    final start = startTime.hour * 60 + startTime.minute;
    final end = endTime.hour * 60 + endTime.minute;
    return Duration(minutes: end - start);
  }
}

class NhiemVuGroup {
  final DateTime date;
  final List<NhiemVuModel> tasks;

  NhiemVuGroup({
    required this.date,
    required this.tasks,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory NhiemVuGroup.fromJson(Map<String, dynamic> json) {
    return NhiemVuGroup(
      date: DateTime.parse(json['date']),
      tasks: (json['tasks'] as List)
          .map((taskJson) => NhiemVuModel.fromJson(taskJson))
          .toList(),
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}