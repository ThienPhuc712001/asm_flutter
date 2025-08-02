class AppConstants {
  static const String appName = 'Restaurant Menu Manager';
  static const String baseUrl = 'http://10.0.2.2:1337';

  static const String apiUrl = '$baseUrl/api';

  // Error messages
  static const String networkError =
      'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';
  static const String serverError = 'Lỗi máy chủ. Vui lòng thử lại sau.';
  static const String unknownError = 'Đã xảy ra lỗi không xác định.';

  // Success messages
  static const String dishCreated = 'Đã tạo món ăn mới thành công!';
  static const String dishUpdated = 'Đã cập nhật món ăn thành công!';
  static const String dishDeleted = 'Đã xóa món ăn thành công!';

  // Validation messages
  static const String requiredField = 'Trường này là bắt buộc';
  static const String invalidPrice = 'Vui lòng nhập giá hợp lệ';
  static const String selectCategory = 'Vui lòng chọn danh mục';
}

class AppColors {
  static const primaryColor = 0xFFFF9800; // Orange
  static const primaryColorLight = 0xFFFFB74D;
  static const primaryColorDark = 0xFFF57C00;
  static const accentColor = 0xFF4CAF50; // Green
  static const errorColor = 0xFFF44336; // Red
  static const warningColor = 0xFFFF9800; // Orange
  static const successColor = 0xFF4CAF50; // Green
}
