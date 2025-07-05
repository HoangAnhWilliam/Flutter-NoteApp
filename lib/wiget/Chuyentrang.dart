import 'package:flutter/material.dart';
import '../Screen/Lichtrinh.dart';
import '../Screen/Nhiemvu.dart';
import '../Screen/Nhomviec.dart';
import '../Screen/Tiendo.dart';
import '../Screen/Trangchu.dart';
class ChuyentrangWidget extends StatefulWidget {
  const ChuyentrangWidget({Key? key}) : super(key: key);

  @override
  _ChuyentrangWidgetState createState() => _ChuyentrangWidgetState();
}

class _ChuyentrangWidgetState extends State<ChuyentrangWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    TrangchuWidget(),
    NhomViecWidget(),
    LichtrinhWidget(), 
    NhiemVu(),
  ];

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    
    // If you want to push new routes instead of switching in place
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TrangchuWidget()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NhomViecWidget()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LichtrinhWidget()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TienDoWidget()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NhiemVu()),
      );
    }
    // Add other cases as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
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
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed, // For more than 3 items
      ),
    );
  }
}