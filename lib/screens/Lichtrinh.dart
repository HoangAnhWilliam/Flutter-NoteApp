import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'Trangchu.dart';
import '../screens/Nhomviec.dart';
import '../screens/Tiendo.dart';
import '../screens/Nhiemvu.dart';
import '../widgets/Chuyentrang.dart';
import '../widgets/Thanhmenu.dart';
import '../models/nhiemvu.dart';
import '../models/user.dart';
import '../models/nhomviec.dart';

class LichtrinhWidget extends StatefulWidget {
  @override
  _LichtrinhWidgetState createState() => _LichtrinhWidgetState();
}

class _LichtrinhWidgetState extends State<LichtrinhWidget> {
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<NhiemVuModel> _tasks = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _currentUser;
  bool _isLoading = true;
  int _selectedIndex = 2; // Index cho màn hình lịch trình

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadData();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userJson = prefs.getString('currentUser');
      if (userJson != null) {
        setState(() {
          _currentUser = User.fromJson(json.decode(userJson));
        });
      }
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> _loadData() async {
    try {
      final String tasksString = await rootBundle.loadString('assets/data/nhiemvu.json');
      final Map<String, dynamic> tasksJson = json.decode(tasksString);
      
      List<NhiemVuModel> allTasks = [];
      for (var group in tasksJson['nhomviec']) {
        allTasks.addAll((group['tasks'] as List)
            .map((taskJson) => NhiemVuModel.fromJson(taskJson)));
      }

      // Load thêm tasks đã lưu trong SharedPreferences
      await _loadSavedTasks(allTasks);

      setState(() {
        _tasks = allTasks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSavedTasks(List<NhiemVuModel> allTasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedTasksJson = prefs.getString('saved_tasks');
      if (savedTasksJson != null) {
        final List<dynamic> savedTasksList = json.decode(savedTasksJson);
        final List<NhiemVuModel> savedTasks = savedTasksList
            .map((taskJson) => NhiemVuModel.fromJson(taskJson))
            .toList();
        allTasks.addAll(savedTasks);
      }
    } catch (e) {
      print("Error loading saved tasks: $e");
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Chỉ lưu các task mới thêm (không có trong JSON gốc)
      final List<NhiemVuModel> newTasks = _tasks.where((task) => 
          task.id.contains('new_') || task.id.contains(DateTime.now().millisecondsSinceEpoch.toString())
      ).toList();
      
      final String tasksJson = json.encode(newTasks.map((task) => task.toJson()).toList());
      await prefs.setString('saved_tasks', tasksJson);
    } catch (e) {
      print("Error saving tasks: $e");
    }
  }

  List<NhiemVuModel> _getTasksForSelectedDate() {
    return _tasks.where((task) => 
        task.date.year == _selectedDate.year &&
        task.date.month == _selectedDate.month &&
        task.date.day == _selectedDate.day).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Lịch trình'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Thanhmenu(
        onMenuSelected: (index) {
          Navigator.pop(context);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TrangchuWidget()),
            );
          }
        },
        selectedIndex: 2,
        currentUser: _currentUser,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildMonthControl(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCalendarGrid(),
                        _buildTaskList(),
                      ],
                    ),
                  ),
                ),
                _buildAddTaskButton(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Nhóm việc'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Lịch trình'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Tiến độ'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Nhiệm vụ'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TrangchuWidget()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NhomViecWidget()),
              );
              break;
            case 2:
              // Đã ở màn hình lịch trình
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TienDoWidget()),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NhiemVu()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildTaskList() {
    final tasksForDate = _getTasksForSelectedDate();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Công việc ngày ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (tasksForDate.isEmpty)
            const Text('Không có công việc nào trong ngày này',
                style: TextStyle(color: Colors.grey))
          else
            Column(
              children: tasksForDate.map((task) => Card(
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
                        onPressed: () {
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                          });
                          _saveTasks();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editTask(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _tasks.remove(task);
                          });
                          _saveTasks();
                        },
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

  Widget _buildAddTaskButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: _showAddTaskDialog,
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

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    TextEditingController subtitleController = TextEditingController();
    DateTime selectedDate = _selectedDate;
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thêm nhiệm vụ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    labelText: 'Tên công việc',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subtitleController,
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
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setDialogState(() {
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
                        Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Thời gian bắt đầu'),
                  trailing: Text(
                    startTime.format(context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        startTime = time;
                        // Tự động điều chỉnh thời gian kết thúc nếu cần
                        if (endTime.hour < time.hour || 
                            (endTime.hour == time.hour && endTime.minute <= time.minute)) {
                          endTime = TimeOfDay(hour: time.hour + 1, minute: time.minute);
                        }
                      });
                    }
                  },
                ),
                ListTile(
                  title: const Text('Thời gian kết thúc'),
                  trailing: Text(
                    endTime.format(context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        endTime = time;
                      });
                    }
                  },
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
                if (taskController.text.isNotEmpty) {
                  // Kiểm tra thời gian kết thúc phải sau thời gian bắt đầu
                  if (endTime.hour < startTime.hour || 
                      (endTime.hour == startTime.hour && endTime.minute <= startTime.minute)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thời gian kết thúc phải sau thời gian bắt đầu'),
                      ),
                    );
                    return;
                  }

                  final newTask = NhiemVuModel(
                    id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                    title: taskController.text,
                    subtitle: subtitleController.text,
                    date: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                    ),
                    startTime: startTime,
                    endTime: endTime,
                    isCompleted: false,
                    groupId: null, // Có thể thêm chọn nhóm sau
                  );

                  setState(() {
                    _tasks.add(newTask);
                  });
                  _saveTasks();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập tên công việc')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _editTask(NhiemVuModel task) {
    TextEditingController taskController = TextEditingController(text: task.title);
    TextEditingController subtitleController = TextEditingController(text: task.subtitle);
    DateTime selectedDate = task.date;
    TimeOfDay startTime = task.startTime;
    TimeOfDay endTime = task.endTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Chỉnh sửa công việc'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    labelText: 'Tên công việc',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subtitleController,
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
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setDialogState(() {
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
                        Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Thời gian bắt đầu'),
                  trailing: Text(
                    startTime.format(context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        startTime = time;
                        // Tự động điều chỉnh thời gian kết thúc nếu cần
                        if (endTime.hour < time.hour || 
                            (endTime.hour == time.hour && endTime.minute <= time.minute)) {
                          endTime = TimeOfDay(hour: time.hour + 1, minute: time.minute);
                        }
                      });
                    }
                  },
                ),
                ListTile(
                  title: const Text('Thời gian kết thúc'),
                  trailing: Text(
                    endTime.format(context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        endTime = time;
                      });
                    }
                  },
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
                if (taskController.text.isNotEmpty) {
                  // Kiểm tra thời gian kết thúc phải sau thời gian bắt đầu
                  if (endTime.hour < startTime.hour || 
                      (endTime.hour == startTime.hour && endTime.minute <= startTime.minute)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thời gian kết thúc phải sau thời gian bắt đầu'),
                      ),
                    );
                    return;
                  }

                  // Cập nhật task
                  task.title= taskController.text;
                  task.subtitle = subtitleController.text;
                  task.date = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  );
                  task.startTime = startTime;
                  task.endTime = endTime;
                  
                  Navigator.pop(context);
                  setState(() {}); // Rebuild widget
                  _saveTasks();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập tên công việc')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthControl() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 30),
            onPressed: () => _changeMonth(-1),
          ),
          Text(
            DateFormat('MMMM yyyy').format(_currentDate),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 30),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + delta, 1);
      try {
        _selectedDate = DateTime(_currentDate.year, _currentDate.month, _selectedDate.day);
      } catch (e) {
        _selectedDate = DateTime(_currentDate.year, _currentDate.month + 1, 0);
      }
    });
  }

  Widget _buildCalendarGrid() {
    DateTime firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    int startingOffset = firstDay.weekday - 1;
    DateTime lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    int totalDays = lastDay.day;
    int prevMonthDays = DateTime(_currentDate.year, _currentDate.month, 0).day;
    int nextMonthDays = 42 - (startingOffset + totalDays);

    List<Widget> dayWidgets = [];

    List<String> weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    for (var day in weekdays) {
      dayWidgets.add(
        Center(
          child: Text(
            day,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    for (int i = 0; i < startingOffset; i++) {
      dayWidgets.add(
        Opacity(
          opacity: 0.5,
          child: Center(
            child: Text('${prevMonthDays - startingOffset + i + 1}'),
          ),
        ),
      );
    }

    for (int i = 1; i <= totalDays; i++) {
      bool isToday = i == DateTime.now().day && 
                    _currentDate.month == DateTime.now().month && 
                    _currentDate.year == DateTime.now().year;
      
      bool isSelected = i == _selectedDate.day && 
                       _currentDate.month == _selectedDate.month && 
                       _currentDate.year == _selectedDate.year;

      bool hasTasks = _tasks.any((task) => 
          task.date.day == i &&
          task.date.month == _currentDate.month &&
          task.date.year == _currentDate.year);

      dayWidgets.add(
        GestureDetector(
          onTap: () => setState(() {
            _selectedDate = DateTime(_currentDate.year, _currentDate.month, i);
          }),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : null,
              shape: BoxShape.circle,
              border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    '$i',
                    style: TextStyle(
                      color: isSelected ? Colors.white : 
                            (isToday ? Colors.blue : Colors.black),
                      fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasTasks)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    for (int i = 1; i <= nextMonthDays; i++) {
      dayWidgets.add(
        Opacity(
          opacity: 0.5,
          child: Center(
            child: Text('$i'),
          ),
        ),
      );
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(8),
      children: dayWidgets,
    );
  }
}