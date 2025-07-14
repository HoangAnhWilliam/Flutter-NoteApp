import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'Trangchu.dart';
import 'Lichtrinh.dart';
import 'Nhiemvu.dart';
import 'Tiendo.dart';
import '../item/Themnhomviec.dart';
import '../account/Dangnhap.dart';
import '../account/Dangky.dart';
import '../account/Taikhoan.dart';
import '../models/nhomviec.dart';
import '../models/nhiemvu.dart';
import '../models/user.dart';

class NhomViecWidget extends StatefulWidget {
  const NhomViecWidget({super.key});

  @override
  State<NhomViecWidget> createState() => _NhomViecWidgetState();
}

class _NhomViecWidgetState extends State<NhomViecWidget> {
  int _selectedIndex = 1;
  int _menuSelectedIndex = 0;
  User? _currentUser;
  bool _isLoading = true;
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
      final String workGroupsString = await rootBundle.loadString('assets/data/nhomviec.json');
      final Map<String, dynamic> workGroupsJson = json.decode(workGroupsString);
      
      setState(() {
        _workGroups = (workGroupsJson['nhomviec'] as List)
            .map((groupJson) => NhomViec.fromJson(groupJson))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onMenuSelected(int index) {
    setState(() => _menuSelectedIndex = index);
    Navigator.pop(context);
    
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrangchuWidget()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaiKhoan()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dangky()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhóm việc')),
      drawer: _buildDrawer(),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _workGroups.length,
                    itemBuilder: (context, index) => _buildNhomViecCard(_workGroups[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final newGroup = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ThemNhomViecScreen()),
                      );
                      if (newGroup != null && newGroup is NhomViec) {
                        setState(() => _workGroups.add(newGroup));
                      }
                    },
                    child: const Text('Thêm nhóm việc'),
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
            onTap: () => _onMenuSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Thông tin'),
            selected: _menuSelectedIndex == 1,
            onTap: () => _onMenuSelected(1),
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('Đăng ký'),
            selected: _menuSelectedIndex == 2,
            onTap: () => _onMenuSelected(2),
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

  Widget _buildNhomViecCard(NhomViec nhomViec) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: nhomViec.colorValue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      nhomViec.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${(nhomViec.completionPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: nhomViec.completionPercentage == 1 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(nhomViec.description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Khung giờ: ${nhomViec.timeRange}', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Hoàn thành: ${nhomViec.completionStatus}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Divider(),
            Text('Các nhiệm vụ:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...nhomViec.tasks.map((task) => ListTile(
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: nhomViec.colorValue,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(task.title),
              subtitle: Text(task.subtitle),
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => setState(() => task.isCompleted = value ?? false),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}