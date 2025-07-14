import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/nhiemvu.dart';
import 'nhomviec.dart';
import 'tiendo.dart';
import 'trangchu.dart';
import 'lichtrinh.dart';
import '../items/themnhiemvu.dart';
import '../account/dangnhap.dart';
import '../account/dangky.dart';
import '../account/taikhoan.dart';
import '../models/nhomviec.dart';
import '../models/user.dart';

class NhiemVu extends StatefulWidget {
  const NhiemVu({super.key});

  @override
  State<NhiemVu> createState() => _NhiemVuState();
}

class _NhiemVuState extends State<NhiemVu> {
  int _selectedIndex = 4;
  int _menuSelectedIndex = 0;
  User? _currentUser;
  bool _isLoading = true;
  List<NhiemVuGroup> _taskGroups = [];
  List<NhomViec> _workGroups = [];

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
        setState(() => _currentUser = User.fromJson(json.decode(userJson)));
      }
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> _loadData() async {
    try {
      // Load work groups
      final workGroupsString = await rootBundle.loadString('assets/data/nhomviec.json');
      final workGroupsJson = json.decode(workGroupsString);
      
      // Load tasks
      final tasksString = await rootBundle.loadString('assets/data/nhiemvu.json');
      final tasksJson = json.decode(tasksString);
      
      // Group tasks by date
      final Map<String, List<NhiemVuModel>> groupedTasks = {};
      for (var group in tasksJson['nhomviec']) {
        for (var task in group['tasks']) {
          final taskModel = NhiemVuModel.fromJson(task);
          final dateKey = DateFormat('yyyy-MM-dd').format(taskModel.date);
          groupedTasks.putIfAbsent(dateKey, () => []).add(taskModel);
        }
      }
      
      setState(() {
        _workGroups = (workGroupsJson['nhomviec'] as List)
            .map((json) => NhomViec.fromJson(json))
            .toList();
        
        _taskGroups = groupedTasks.entries.map((entry) => NhiemVuGroup(
          date: DateTime.parse(entry.key),
          tasks: entry.value,
        )).toList();
        
        _taskGroups.sort((a, b) => a.date.compareTo(b.date));
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _addNewTask(NhiemVuModel newTask) {
    setState(() {
      final dateKey = DateFormat('yyyy-MM-dd').format(newTask.date);
      final existingGroup = _taskGroups.firstWhere(
        (group) => DateFormat('yyyy-MM-dd').format(group.date) == dateKey,
        orElse: () => NhiemVuGroup(date: newTask.date, tasks: []),
      );
      
      if (existingGroup.tasks.isNotEmpty) {
        existingGroup.tasks.add(newTask);
      } else {
        _taskGroups.add(NhiemVuGroup(date: newTask.date, tasks: [newTask]));
        _taskGroups.sort((a, b) => a.date.compareTo(b.date));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhiệm vụ')),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _taskGroups.length,
                    itemBuilder: (context, groupIndex) {
                      final group = _taskGroups[groupIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              group.formattedDate,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...group.tasks.map((task) => _buildTaskItem(task)).toList(),
                          if (groupIndex != _taskGroups.length - 1)
                            const Divider(height: 1, thickness: 1),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final newTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThemNhiemVu(availableGroups: _workGroups),
                        ),
                      );
                      if (newTask != null) _addNewTask(newTask);
                    },
                    child: const Text('Thêm nhiệm vụ'),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_currentUser?.name ?? 'Khách'),
            accountEmail: Text(_currentUser?.email ?? 'Chưa đăng nhập'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(_currentUser?.avatar ?? 'assets/avatar.png'),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            selected: _menuSelectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TrangchuWidget()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Thông tin'),
            selected: _menuSelectedIndex == 1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaiKhoan()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('Đăng ký'),
            selected: _menuSelectedIndex == 2,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dangky()),
              );
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dangnhap()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Nhóm việc'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Lịch trình'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Tiến độ'),
        BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Nhiệm vụ'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        switch (index) {
          case 0: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrangchuWidget())); break;
          case 1: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NhomViecWidget())); break;
          case 2: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LichtrinhWidget())); break;
          case 3: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TienDoWidget())); break;
          case 4: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NhiemVu())); break;
        }
      },
    );
  }

  Widget _buildTaskItem(NhiemVuModel task) {
    final group = _workGroups.firstWhere(
      (g) => g.id == task.groupId,
      orElse: () => NhomViec(
        id: '',
        title: 'Không có nhóm',
        description: '',
        timeRange: '',
        tasks: [],
        color: '9E9E9E',
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: CheckboxListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.subtitle),
            const SizedBox(height: 4),
            Row(
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
                Text(
                  '${group.title} • ${task.formattedDate}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        value: task.isCompleted,
        onChanged: (bool? value) => setState(() => task.isCompleted = value ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        secondary: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}