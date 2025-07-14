import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/nhomviec.dart';
import '../models/nhiemvu.dart';

class ThemNhomViecScreen extends StatefulWidget {
  final Function(NhomViec)? onSave;

  const ThemNhomViecScreen({super.key, this.onSave});

  @override
  State<ThemNhomViecScreen> createState() => _ThemNhomViecScreenState();
}

class _ThemNhomViecScreenState extends State<ThemNhomViecScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeRangeController = TextEditingController();
  final List<NhiemVuModel> _tasks = [];
  Color _selectedColor = Colors.blue;
  final List<Color> _colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeRangeController.dispose();
    super.dispose();
  }

  void _saveGroup() {
    if (_formKey.currentState!.validate()) {
      final newGroup = NhomViec(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        timeRange: _timeRangeController.text,
        tasks: _tasks,
        userId: "user1",
        color: _selectedColor.value.toRadixString(16).substring(2),
      );

      if (widget.onSave != null) {
        widget.onSave!(newGroup);
      }

      Navigator.pop(context, newGroup);
    }
  }

  void _addNewTask() {
    final taskTitleController = TextEditingController();
    final taskSubtitleController = TextEditingController();
    DateTime? selectedDate = DateTime.now();
    TimeOfDay? startTime = TimeOfDay.now();
    TimeOfDay? endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
    bool isCompleted = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Thêm nhiệm vụ mới'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: taskTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Tiêu đề',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: taskSubtitleController,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Ngày',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(selectedDate!)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Thời gian bắt đầu'),
                    trailing: Text(
                      startTime?.format(context) ?? 'Chọn giờ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          startTime = time;
                          // Tự động điều chỉnh thời gian kết thúc nếu cần
                          if (endTime != null && 
                              (time.hour > endTime!.hour || 
                              (time.hour == endTime!.hour && time.minute >= endTime!.minute))) {
                            endTime = TimeOfDay(hour: time.hour + 1, minute: time.minute);
                          }
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Thời gian kết thúc'),
                    trailing: Text(
                      endTime?.format(context) ?? 'Chọn giờ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          endTime = time;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Hoàn thành:'),
                      Checkbox(
                        value: isCompleted,
                        onChanged: (value) {
                          setState(() {
                            isCompleted = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (taskTitleController.text.isNotEmpty && 
                      startTime != null && 
                      endTime != null) {
                    // Kiểm tra thời gian kết thúc phải sau thời gian bắt đầu
                    if (endTime!.hour < startTime!.hour || 
                        (endTime!.hour == startTime!.hour && endTime!.minute <= startTime!.minute)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thời gian kết thúc phải sau thời gian bắt đầu'),
                        ),
                      );
                      return;
                    }

                    final newTask = NhiemVuModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: taskTitleController.text,
                      subtitle: taskSubtitleController.text,
                      date: selectedDate!,
                      startTime: startTime!,
                      endTime: endTime!,
                      isCompleted: isCompleted,
                      userId: "user1",
                    );
                    setState(() {
                      _tasks.add(newTask);
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                ),
                child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhóm việc'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: _saveGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phần chọn màu
                const Text(
                  'Màu sắc nhóm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colorOptions.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final color = _colorOptions[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _selectedColor == color
                                ? Border.all(color: Colors.black, width: 3)
                                : null,
                          ),
                          child: _selectedColor == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Các trường nhập thông tin
                const Text(
                  'Tên nhóm việc*',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên nhóm việc',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên nhóm việc';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                const Text(
                  'Mô tả',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mô tả nhóm việc',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                const Text(
                  'Khung giờ*',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _timeRangeController,
                  decoration: InputDecoration(
                    hintText: 'VD: 10:00-17:00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập khung giờ';
                    }
                    return null;
                  },
                ),
                
                // Phần nhiệm vụ
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Các nhiệm vụ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: _addNewTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Thêm nhiệm vụ', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _tasks.isEmpty
                    ? const Center(
                        child: Text('Chưa có nhiệm vụ nào'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: _selectedColor.withOpacity(0.1),
                            child: ListTile(
                              title: Text(task.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.subtitle),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ngày: ${DateFormat('dd/MM/yyyy').format(task.date)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Thời gian: ${task.startTime.format(context)} - ${task.endTime.format(context)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Trạng thái: ${task.isCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: task.isCompleted ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _tasks.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}