import 'package:flutter/material.dart';
import 'account/Dangnhap.dart';
import 'account/Dangky.dart';
import 'account/Quenmatkhau.dart';
import 'account/Taikhoan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Plant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Dangnhap(),
        '/register': (context) => const Dangky(),
        '/forgot-password': (context) => const QuanMatKhau(),
        '/profile': (context) => const TaiKhoan(),
      },
      onGenerateRoute: (settings) {
        // Xử lý các route động nếu cần
        return MaterialPageRoute(
          builder: (context) => const Dangnhap(),
        );
      },
      onUnknownRoute: (settings) {
        // Xử lý khi route không tồn tại
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Lỗi')),
            body: const Center(child: Text('Trang không tồn tại')),
          ),
        );
      },
    );
  }
}