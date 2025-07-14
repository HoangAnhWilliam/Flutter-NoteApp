import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/Trangchu.dart';
import '../screens/Nhiemvu.dart';
import '../models/nhomviec.dart';
import '../models/nhiemvu.dart';

class ChitietnhomviecWidget extends StatefulWidget {
  final NhomViec group;
  const ChitietnhomviecWidget({super.key, required this.group});

  @override
  _ChitietnhomviecWidgetState createState() => _ChitietnhomviecWidgetState();
}

class _ChitietnhomviecWidgetState extends State<ChitietnhomviecWidget> {
  int _selectedIndex = 1; // Default to "Nhóm việc" tab
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    // You can add additional task loading logic here if needed
    setState(() {});
  }

  // Get completed task count
  int get completedCount {
    return widget.group.tasks.where((task) => task.isCompleted).length;
  }

  // Calculate completion percentage
  double get completionPercentage {
    if (widget.group.tasks.isEmpty) return 0;
    return completedCount / widget.group.tasks.length;
  }

  // Handle bottom navigation
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TrangchuWidget()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NhiemVu()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
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
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.group.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  )
                ],
              ),
            ),

            // Group info card - matches Trangchu.dart style
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.group.colorValue,
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
                      widget.group.timeRange,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.group.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: completionPercentage,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${(completionPercentage * 100).toStringAsFixed(0)}% hoàn thành",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Tasks list header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nhiệm vụ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    "$completedCount/${widget.group.tasks.length}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // Tasks list - matches Trangchu.dart style
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.group.tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskItem(widget.group.tasks[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 8),
                Text('Lưu Thế Toàn'),
                Text('22DH113778@st.huflit.edu.vn'),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TrangchuWidget()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Nhóm việc'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Lịch trình'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Tiến độ'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Nhiệm vụ'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NhiemVu()),
              );
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(NhiemVuModel task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
          activeColor: widget.group.colorValue,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: task.isCompleted ? Colors.grey : Colors.grey[800],
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.subtitle,
          style: TextStyle(
            fontSize: 12,
            color: task.isCompleted ? Colors.grey : null,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
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
              Icon(Icons.access_time, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                DateFormat('hh:mm a').format(task.date),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}