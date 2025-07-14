import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/nhiemvu.dart';
import '../models/nhomviec.dart';

class ThemNhiemVu extends StatefulWidget {
  final List<NhomViec> availableGroups;
  final Function(NhiemVuModel)? onTaskAdded;

  const ThemNhiemVu({
    super.key, 
    required this.availableGroups,
    this.onTaskAdded,
  });

  @override
  State<ThemNhiemVu> createState() => _ThemNhiemVuState();
}

class _ThemNhiemVuState extends State<ThemNhiemVu> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedGroupId;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        // Tự động điều chỉnh endTime nếu cần
        if (_endTime == null || 
            _endTime!.hour < picked.hour || 
            (_endTime!.hour == picked.hour && _endTime!.minute <= picked.minute)) {
          _endTime = TimeOfDay(hour: picked.hour + 1, minute: picked.minute);
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (_startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn thời gian bắt đầu và kết thúc')),
        );
        return;
      }

      if (_endTime!.hour < _startTime!.hour || 
          (_endTime!.hour == _startTime!.hour && _endTime!.minute <= _startTime!.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thời gian kết thúc phải sau thời gian bắt đầu')),
        );
        return;
      }

      final newTask = NhiemVuModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        isCompleted: false,
        groupId: _selectedGroupId,
      );

      if (widget.onTaskAdded != null) {
        widget.onTaskAdded!(newTask);
      }
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhiệm vụ'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tên nhiệm vụ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên nhiệm vụ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Ngày thực hiện',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Vui lòng chọn ngày';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Thời gian bắt đầu'),
                trailing: Text(
                  _startTime?.format(context) ?? 'Chọn giờ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => _selectStartTime(context),
              ),
              ListTile(
                title: const Text('Thời gian kết thúc'),
                trailing: Text(
                  _endTime?.format(context) ?? 'Chọn giờ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => _selectEndTime(context),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Nhóm công việc',
                  border: OutlineInputBorder(),
                ),
                value: _selectedGroupId,
                items: widget.availableGroups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group.id,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: group.colorValue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(group.title),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn nhóm';
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Thêm nhiệm vụ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}