import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // App Info Section
          _buildSectionHeader('Thông tin ứng dụng'),
          _buildSettingItem(
            icon: Icons.info,
            title: 'Phiên bản',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.developer_mode,
            title: 'Nhà phát triển',
            subtitle: 'Restaurant Menu Team',
            onTap: () {},
          ),
          
          SizedBox(height: 24),
          
          // Server Settings Section
          _buildSectionHeader('Cài đặt máy chủ'),
          _buildSettingItem(
            icon: Icons.cloud,
            title: 'Địa chỉ máy chủ',
            subtitle: 'http://localhost:1337',
            onTap: () {
              _showServerSettingsDialog(context);
            },
          ),
          _buildSettingItem(
            icon: Icons.sync,
            title: 'Đồng bộ dữ liệu',
            subtitle: 'Cập nhật dữ liệu từ máy chủ',
            onTap: () {
              _showSyncDialog(context);
            },
          ),
          
          SizedBox(height: 24),
          
          // Data Management Section
          _buildSectionHeader('Quản lý dữ liệu'),
          _buildSettingItem(
            icon: Icons.backup,
            title: 'Sao lưu dữ liệu',
            subtitle: 'Tạo bản sao lưu dữ liệu',
            onTap: () {
              _showBackupDialog(context);
            },
          ),
          _buildSettingItem(
            icon: Icons.restore,
            title: 'Khôi phục dữ liệu',
            subtitle: 'Khôi phục từ bản sao lưu',
            onTap: () {
              _showRestoreDialog(context);
            },
          ),
          _buildSettingItem(
            icon: Icons.delete_forever,
            title: 'Xóa tất cả dữ liệu',
            subtitle: 'Xóa toàn bộ dữ liệu cục bộ',
            onTap: () {
              _showClearDataDialog(context);
            },
            textColor: Colors.red,
          ),
          
          SizedBox(height: 24),
          
          // About Section
          _buildSectionHeader('Giới thiệu'),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Hướng dẫn sử dụng',
            subtitle: 'Cách sử dụng ứng dụng',
            onTap: () {
              _showHelpDialog(context);
            },
          ),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Chính sách bảo mật',
            subtitle: 'Điều khoản và chính sách',
            onTap: () {
              _showPrivacyDialog(context);
            },
          ),
          _buildSettingItem(
            icon: Icons.contact_support,
            title: 'Liên hệ hỗ trợ',
            subtitle: 'Gửi phản hồi và báo lỗi',
            onTap: () {
              _showContactDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Colors.grey[600]),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showServerSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cài đặt máy chủ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Địa chỉ máy chủ',
                hintText: 'http://localhost:1337',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Lưu ý: Thay đổi địa chỉ máy chủ có thể ảnh hưởng đến việc đồng bộ dữ liệu.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã cập nhật cài đặt máy chủ')),
              );
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đồng bộ dữ liệu'),
        content: Text('Bạn có muốn đồng bộ dữ liệu từ máy chủ không? Thao tác này có thể mất vài phút.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đang đồng bộ dữ liệu...')),
              );
            },
            child: Text('Đồng bộ'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sao lưu dữ liệu'),
        content: Text('Tạo bản sao lưu dữ liệu hiện tại? Bản sao lưu sẽ được lưu trong bộ nhớ thiết bị.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã tạo bản sao lưu thành công')),
              );
            },
            child: Text('Sao lưu'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Khôi phục dữ liệu'),
        content: Text('Khôi phục dữ liệu từ bản sao lưu? Dữ liệu hiện tại sẽ bị ghi đè.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã khôi phục dữ liệu thành công')),
              );
            },
            child: Text('Khôi phục'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa tất cả dữ liệu'),
        content: Text('CẢNH BÁO: Thao tác này sẽ xóa toàn bộ dữ liệu cục bộ và không thể hoàn tác. Bạn có chắc chắn muốn tiếp tục?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa tất cả dữ liệu')),
              );
            },
            child: Text('Xóa'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hướng dẫn sử dụng'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. Xem danh sách món ăn:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('- Chạm vào tab "Thực đơn" để xem tất cả món ăn'),
              Text('- Sử dụng thanh tìm kiếm để tìm món ăn theo tên'),
              Text('- Lọc món ăn theo danh mục'),
              SizedBox(height: 12),
              Text('2. Thêm món ăn mới:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('- Chạm vào nút "+" ở góc dưới bên phải'),
              Text('- Điền thông tin món ăn và chọn ảnh'),
              Text('- Chọn danh mục và nhấn "Lưu"'),
              SizedBox(height: 12),
              Text('3. Chỉnh sửa món ăn:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('- Chạm vào món ăn để xem chi tiết'),
              Text('- Chạm vào nút "Chỉnh sửa" hoặc menu 3 chấm'),
              SizedBox(height: 12),
              Text('4. Xem thống kê:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('- Chạm vào tab "Thống kê" để xem báo cáo'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chính sách bảo mật'),
        content: SingleChildScrollView(
          child: Text(
            'Ứng dụng Restaurant Menu Manager cam kết bảo vệ thông tin cá nhân của người dùng.\n\n'
            '1. Thu thập thông tin: Ứng dụng chỉ thu thập thông tin cần thiết để quản lý thực đơn.\n\n'
            '2. Sử dụng thông tin: Thông tin được sử dụng để cung cấp dịch vụ quản lý thực đơn.\n\n'
            '3. Bảo mật: Dữ liệu được mã hóa và bảo vệ bằng các biện pháp bảo mật tiên tiến.\n\n'
            '4. Chia sẻ: Chúng tôi không chia sẻ thông tin cá nhân với bên thứ ba.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Liên hệ hỗ trợ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nếu bạn gặp vấn đề hoặc có góp ý, vui lòng liên hệ:'),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, size: 16),
                SizedBox(width: 8),
                Text('support@restaurantmenu.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16),
                SizedBox(width: 8),
                Text('1900-1234'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.web, size: 16),
                SizedBox(width: 8),
                Text('www.restaurantmenu.com'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã gửi yêu cầu hỗ trợ')),
              );
            },
            child: Text('Gửi phản hồi'),
          ),
        ],
      ),
    );
  }
}

