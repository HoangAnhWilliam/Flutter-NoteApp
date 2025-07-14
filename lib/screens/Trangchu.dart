import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'Tiendo.dart';
import '../items/Chitietnhomviec.dart';
import 'Lichtrinh.dart';
import 'Nhiemvu.dart';
import 'Nhomviec.dart';
import '../account/Dangnhap.dart';
import '../account/Dangky.dart';
import '../account/Taikhoan.dart';
import '../widgets/Thanhmenu.dart';
import '../widgets/Chuyentrang.dart';
import '../models/user.dart';
import '../models/nhiemvu.dart';
import '../models/nhomviec.dart';
import '../screens/welcomebanner.dart';

class TrangchuWidget extends StatefulWidget {
  @override
  _TrangchuWidgetState createState() => _TrangchuWidgetState();
}

class _TrangchuWidgetState extends State<TrangchuWidget> {
  int _selectedIndex = 0;
  User? _currentUser;
  bool _isLoading = true;
  List<NhomViec> _workGroups = [];
  List<NhiemVuModel> _tasks = [];

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
      // Load work groups
      final String workGroupsString = await rootBundle.loadString('assets/data/nhomviec.json');
      final Map<String, dynamic> workGroupsJson = json.decode(workGroupsString);
      final List<NhomViec> workGroups = (workGroupsJson['nhomviec'] as List)
          .map((groupJson) => NhomViec.fromJson(groupJson))
          .toList();

      // Load tasks
      final String tasksString = await rootBundle.loadString('assets/data/nhiemvu.json');
      final Map<String, dynamic> tasksJson = json.decode(tasksString);
      final List<NhiemVuModel> tasks = [];
      
      for (var groupJson in tasksJson['nhomviec']) {
        tasks.addAll((groupJson['tasks'] as List)
            .map((taskJson) => NhiemVuModel.fromJson(taskJson)));
      }

      setState(() {
        _workGroups = workGroups;
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dangnhap()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildWorkGroupCard(NhomViec group) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: group.colorValue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              group.timeRange,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 12),
          Text(
            group.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_right_alt, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChitietnhomviecWidget(group: group),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(NhiemVuModel task) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            setState(() {
              task.isCompleted = value ?? false;
            });
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          task.subtitle,
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
                DateFormat('hh:mm a').format(task.date),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              WelcomeBanner(currentUser: _currentUser),

              // Work groups section
              Text(
                "Nhóm việc cần làm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _workGroups.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: _buildWorkGroupCard(_workGroups[index]),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Nhiệm vụ hôm nay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskItem(_tasks[index]);
                  },
                ),
              ),

              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Tất cả nhiệm vụ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang Chủ"),
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Đăng xuất',
            ),
        ],
      ),
      drawer: Thanhmenu(
        onMenuSelected: (index) {
          // Handle menu selection if needed
        },
        selectedIndex: _selectedIndex,
        currentUser: _currentUser,
      ),
      body: _buildHomeContent(),
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              // Already on home page
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NhomViecWidget()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LichtrinhWidget()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TienDoWidget()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NhiemVu()),
              );
              break;
          }
        },
      ),
    );
  }
}