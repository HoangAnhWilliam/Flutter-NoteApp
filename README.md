# Flutter NoteApp - Hướng dẫn làm việc nhóm

## 1. Clone project về máy

```bash
git clone https://github.com/HoangAnhWilliam/Flutter-NoteApp.git
cd Flutter-NoteApp
Nếu lần đầu mở project bằng VS Code hoặc Android Studio, chạy:

bash
Sao chép
Chỉnh sửa
flutter pub get
2. Cập nhật code mới nhất từ remote
Luôn chạy trước khi làm việc để tránh conflict:

bash
Sao chép
Chỉnh sửa
git checkout main
git pull origin main
3. Tạo branch mới để làm việc
Luôn tạo nhánh mới theo từng chức năng/ticket/task:

bash
Sao chép
Chỉnh sửa
git checkout -b ten-branch-cua-ban
Ví dụ:

bash
Sao chép
Chỉnh sửa
git checkout -b feature/dang-nhap
4. Commit & Push code lên branch
Sau khi sửa code, lưu lại thay đổi và đẩy lên GitHub:

bash
Sao chép
Chỉnh sửa
git add .
git commit -m "Nội dung commit"
git push origin ten-branch-cua-ban
5. Tạo Pull Request (PR) để merge vào main
Lên GitHub repo, sẽ thấy dòng “Compare & pull request” hoặc “New Pull Request”.

Chọn branch vừa push lên, viết mô tả ngắn gọn.

Bấm Create Pull Request.

Đợi leader hoặc đồng đội review, khi được duyệt sẽ merge vào main.

6. Một số lưu ý
Tuyệt đối không push trực tiếp lên main (nếu không phải leader).

Luôn pull code mới nhất trước khi bắt đầu task mới.

Giải quyết conflict nếu có (hãy hỏi team nếu gặp khó khăn).

Nên đặt tên branch theo chức năng, ví dụ:

feature/dang-nhap

fix/loi-giao-dien

refactor/code-clean

7. Chạy ứng dụng Flutter
bash
Sao chép
Chỉnh sửa
flutter run
