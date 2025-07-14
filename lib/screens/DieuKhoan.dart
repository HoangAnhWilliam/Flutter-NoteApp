import 'package:flutter/material.dart';

class DieuKhoan extends StatelessWidget {
  const DieuKhoan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều khoản sử dụng'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding chỉ cho nội dung
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Điều khoản sử dụng',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  '1. Giới thiệu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chào mừng bạn đến với ứng dụng của chúng tôi. Bằng việc sử dụng ứng dụng này, bạn đồng ý tuân thủ các điều khoản và điều kiện sau đây.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '2. Quyền và nghĩa vụ của người dùng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Người dùng có quyền truy cập và sử dụng các tính năng của ứng dụng theo đúng mục đích đã được quy định.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '3. Quyền riêng tư',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn. Vui lòng xem chính sách bảo mật của chúng tôi để biết thêm chi tiết.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '4. Thay đổi điều khoản',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chúng tôi có quyền thay đổi các điều khoản này bất cứ lúc nào. Mọi thay đổi sẽ được thông báo trên ứng dụng và có hiệu lực ngay khi được đăng tải.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '5. Liên hệ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nếu bạn có bất kỳ câu hỏi nào về các điều khoản này, vui lòng liên hệ với chúng tôi qua email hoặc số điện thoại được cung cấp trong ứng dụng.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '6. Chấp nhận điều khoản',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bằng việc sử dụng ứng dụng, bạn xác nhận rằng bạn đã đọc, hiểu và đồng ý với các điều khoản và điều kiện này.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '7. Quyền sở hữu trí tuệ',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tất cả nội dung, bao gồm nhưng không giới hạn ở văn bản, hình ảnh, đồ họa, logo và phần mềm trên ứng dụng này đều thuộc quyền sở hữu trí tuệ của chúng tôi hoặc các bên thứ ba. Việc sao chép, phân phối hoặc sử dụng trái phép các nội dung này là vi phạm pháp luật.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '8. Giới hạn trách nhiệm',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chúng tôi không chịu trách nhiệm về bất kỳ thiệt hại nào phát sinh từ việc sử dụng hoặc không thể sử dụng ứng dụng này, bao gồm nhưng không giới hạn ở thiệt hại về dữ liệu, lợi nhuận hoặc gián đoạn kinh doanh.',
                ),
                // Thêm các điều khoản khác tại đây
              ],
            ),
          ),
        ),
      ),
    );
  }
}
