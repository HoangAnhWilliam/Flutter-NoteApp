import 'package:flutter/material.dart';
import 'Trangchu.dart';
import 'Lichtrinh.dart';
import 'Nhiemvu.dart';
import '../account/Dangnhap.dart';
import '../account/Dangky.dart';
import '../account/Taikhoan.dart';



class TienDoWidget extends StatefulWidget {
  const TienDoWidget({super.key});

  @override
  State<TienDoWidget> createState() => _TienDoWidgetState();
}

class _TienDoWidgetState extends State<TienDoWidget> {
  int _selectedIndex = 3; // Default to Tiến độ tab
  
  // Sample progress data
  final List<ProgressCategory> progressCategories = [
    ProgressCategory(
      title: 'Học tập',
      items: ['Theo', 'Giá trị', 'Tháng 5', 'Tháng 6'],
    ),
    ProgressCategory(
      title: 'Thể thao',
      items: ['Chạy bộ', 'Bơi lội', 'Gym'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiến độ'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(''),
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
                Navigator.pop(context);
                _selectedIndex = 0;
                setState(() {});
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TrangchuWidget()),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Thông tin'),
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
              onTap: () {
                Navigator.pop(context); // Close the current drawer/modal if open
                Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => Dangky()),
                );
              },
            ),
            const Divider(
              color: Colors.black,
            ),
              ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.pop(context); // Close the current drawer/modal if open
                Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => Dangnhap()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Tiến độ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...progressCategories.map((category) => 
                  _buildProgressCategory(category)
                ).toList(),
                const SizedBox(height: 30),
                const Divider(thickness: 1),
                const SizedBox(height: 20),
                const Text(
                  'Xem chi tiết nhóm việc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) { 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TrangchuWidget()),
            );
          }
          if (index == 1) { 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LichtrinhWidget()),
            );
          }
          if (index == 2) { 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LichtrinhWidget()),
            );
          }
          if (index == 3) { 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TienDoWidget()),
            );
          }
          if (index == 4) { 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NhiemVu()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProgressCategory(ProgressCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        ...category.items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            '- $item',
            style: const TextStyle(fontSize: 16),
          ),
        )).toList(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ProgressCategory {
  String title;
  List<String> items;

  ProgressCategory({
    required this.title,
    required this.items,
  });
}