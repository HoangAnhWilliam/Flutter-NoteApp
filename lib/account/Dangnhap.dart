import 'package:do_an/screens/DieuKhoan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Dangky.dart';
import '../screens/Trangchu.dart';
import 'Quenmatkhau.dart';
import 'Taikhoan.dart';
import '../models/user.dart';
import 'package:flutter/gestures.dart';


class Dangnhap extends StatefulWidget {
  const Dangnhap({super.key});

  @override
  State<Dangnhap> createState() => _DangnhapState();
}

class _DangnhapState extends State<Dangnhap> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreeToPolicy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_agreeToPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn chưa đồng ý điều khoản của ứng dụng chúng tôi!!!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final prefs = await SharedPreferences.getInstance();
        final String? usersJson = prefs.getString('users');
        
        if (usersJson != null) {
          final data = json.decode(usersJson);
          if (data['users'] != null && data['users'] is List) {
            final users = (data['users'] as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();
            
            // Tìm user phù hợp
            final user = users.firstWhere(
              (user) => user.email == email && user.matkhau == password,
            );
            
            // Lưu thông tin người dùng hiện tại
            await prefs.setString('currentUser', json.encode(user.toJson()));

            // Đăng nhập thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xin chào ${user.name}!'),
                backgroundColor: Colors.green,
              ),
            );
            
            _goToTrangChu();
            return;
          }
        }
        
        try {
          final String response = await rootBundle.loadString('assets/data/user.json');
          final data = await json.decode(response);
          
          if (data['users'] != null && data['users'] is List) {
            final users = (data['users'] as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();
            
            final user = users.firstWhere(
              (user) => user.email == email && user.matkhau == password,
            );
            
            // Lưu thông tin người dùng hiện tại
            await prefs.setString('currentUser', json.encode(user.toJson()));

            // Đăng nhập thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xin chào ${user.name}!'),
                backgroundColor: Colors.green,
              ),
            );
            
            _goToTrangChu();
            return;
          }
        } catch (e) {
          // Bỏ qua lỗi load file JSON
        }
        
        // Không tìm thấy người dùng
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email hoặc mật khẩu không đúng'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        // Không tìm thấy người dùng
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email hoặc mật khẩu không đúng'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Dangky()),
    );
  }

  void _DenQuenmatkhau() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuanMatKhau()),
    );
  }

  void _goToTrangChu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TrangchuWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'My Plant',
                  style: TextStyle(
                    fontFamily: 'DancingScript', 
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email người dùng:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText: 'Nhập email của bạn',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!value.contains('@')) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Mật khẩu:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            hintText: 'Nhập mật khẩu của bạn',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (value.length < 6) {
                              return 'Mật khẩu phải có ít nhất 6 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _DenQuenmatkhau,
                              child: const Text(
                                'Quên mật khẩu',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),                          
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToPolicy,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToPolicy = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(text: 'Tôi đồng ý với '),
                                    TextSpan(
                                      text: 'Điều khoản và Chính sách bảo mật',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        //TODO: Navigate to terms and conditions page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const DieuKhoan(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Nếu chưa có tài khoản? '),
                    GestureDetector(
                      onTap: _goToRegister,
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}