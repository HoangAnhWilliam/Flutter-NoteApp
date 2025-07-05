import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class TaiKhoan extends StatefulWidget {
  const TaiKhoan({Key? key}) : super(key: key);

  @override
  _TaiKhoanState createState() => _TaiKhoanState();
}

class _TaiKhoanState extends State<TaiKhoan> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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
      print("Error loading current user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã có lỗi khi tải thông tin người dùng'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateUserInfo(User updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Cập nhật currentUser
      await prefs.setString('currentUser', json.encode(updatedUser.toJson()));
      
      // Cập nhật trong danh sách users
      final String? usersJson = prefs.getString('users');
      if (usersJson != null) {
        final data = json.decode(usersJson);
        if (data['users'] != null && data['users'] is List) {
          List<User> users = (data['users'] as List)
              .map((userJson) => User.fromJson(userJson))
              .toList();
              
          // Tìm và cập nhật user
          final index = users.indexWhere((user) => user.email == updatedUser.email);
          if (index != -1) {
            users[index] = updatedUser;
            
            // Lưu lại danh sách users
            await prefs.setString('users', json.encode({
              'users': users.map((user) => user.toJson()).toList()
            }));
          }
        }
      }
      
      setState(() {
        _currentUser = updatedUser;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã có lỗi khi cập nhật thông tin'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _currentUser == null 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin tài khoản',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentUser!.name ?? 'Không có thông tin',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _currentUser!.email ?? 'Không có thông tin',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _currentUser!.avatar!.startsWith('http')
                                  ? NetworkImage(_currentUser!.avatar!)
                                  : AssetImage(_currentUser!.avatar!) as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _showUpdateDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cập nhật',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showUpdateDialog() {
    final nameController = TextEditingController(text: _currentUser?.name);
    final emailController = TextEditingController(text: _currentUser?.email);
    final avatarController = TextEditingController(text: _currentUser?.avatar);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cập nhật thông tin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: avatarController,
                decoration: const InputDecoration(labelText: 'URL ảnh đại diện'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentUser != null) {
                  final updatedUser = _currentUser!.copyWith(
                    name: nameController.text,
                    email: emailController.text,
                    avatar: avatarController.text,
                  );
                  _updateUserInfo(updatedUser);
                }
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}