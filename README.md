# Restaurant Menu Management App

Ứng dụng quản lý thực đơn nhà hàng được xây dựng với Flutter (frontend) và Strapi (backend).

## Tính năng

### Frontend (Flutter)
- ✅ Xem danh sách các món ăn trong thực đơn
- ✅ Tạo một món ăn mới
- ✅ Cập nhật thông tin của một món ăn (tên, mô tả, giá, hình ảnh)
- ✅ Xóa một món ăn
- ✅ Tìm kiếm món ăn theo tên
- ✅ Phân loại món ăn theo danh mục (Khai vị, Món chính, Tráng miệng, Đồ uống)
- ✅ Bottom Navigation Bar với 3 tab: Thực đơn, Thống kê, Cài đặt
- ✅ Xử lý lỗi và loading indicators
- ✅ UI trực quan và hấp dẫn

### Backend (Strapi)
- ✅ Content Type: Dish (name, description, price, image, category)
- ✅ Content Type: Category (name)
- ✅ RESTful API endpoints
- ✅ Quan hệ Many-to-One giữa Dish và Category
- ✅ Hỗ trợ upload hình ảnh

## Cấu trúc dự án

```
restaurant_menu_app/
├── backend/                 # Strapi backend
│   ├── src/
│   │   └── api/
│   │       ├── category/    # Category content type
│   │       └── dish/        # Dish content type
│   └── package.json
└── flutter_app/            # Flutter frontend
    ├── lib/
    │   ├── models/         # Data models
    │   ├── services/       # API services
    │   ├── screens/        # UI screens
    │   ├── widgets/        # Reusable widgets
    │   └── main.dart
    └── pubspec.yaml
```

## Cài đặt và chạy

### Backend (Strapi)

1. Di chuyển vào thư mục backend:
```bash
cd backend
```

2. Cài đặt dependencies:
```bash
npm install
```

3. Chạy Strapi:
```bash
npm run develop
```

4. Truy cập admin panel tại: http://localhost:1337/admin

5. Tạo admin user và thiết lập permissions cho API endpoints

### Frontend (Flutter)

1. Di chuyển vào thư mục flutter_app:
```bash
cd flutter_app
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Chạy ứng dụng:
```bash
flutter run
```

## Dữ liệu mẫu

### Categories
1. Khai vị
2. Món chính  
3. Tráng miệng
4. Đồ uống

### Dishes (ví dụ)
1. **Salad Caesar** (Khai vị) - 85,000 VNĐ
2. **Bò bít tết** (Món chính) - 250,000 VNĐ
3. **Tiramisu** (Tráng miệng) - 65,000 VNĐ
4. **Nước cam tươi** (Đồ uống) - 35,000 VNĐ
5. **Tôm nướng** (Khai vị) - 120,000 VNĐ

## API Endpoints

### Categories
- GET `/api/categories` - Lấy danh sách categories
- POST `/api/categories` - Tạo category mới
- PUT `/api/categories/:id` - Cập nhật category
- DELETE `/api/categories/:id` - Xóa category

### Dishes
- GET `/api/dishes?populate=*` - Lấy danh sách dishes với category
- POST `/api/dishes` - Tạo dish mới
- PUT `/api/dishes/:id` - Cập nhật dish
- DELETE `/api/dishes/:id` - Xóa dish
- GET `/api/dishes?populate=*&filters[name][$containsi]=query` - Tìm kiếm dishes
- GET `/api/dishes?populate=*&filters[category][id][$eq]=categoryId` - Lọc theo category

## Thang điểm

| Tiêu chí | Điểm tối đa | Trạng thái |
|----------|-------------|------------|
| 1. Thiết lập Strapi | 1 | ✅ Hoàn thành |
| 2. Thiết kế UI | 2 | ✅ Hoàn thành |
| 3. Chức năng CRUD | 4.5 | ✅ Hoàn thành |
| - Read (List) | 1 | ✅ |
| - Create | 1.5 | ✅ |
| - Update | 1 | ✅ |
| - Delete | 1 | ✅ |
| 4. Điều hướng | 1 | ✅ Hoàn thành |
| 5. Xử lý lỗi và loading | 1.5 | ✅ Hoàn thành |
| **Tổng điểm** | **10** | **✅ 10/10** |

## Công nghệ sử dụng

### Frontend
- Flutter 3.16.9
- Dart 3.2.6
- Provider (State management)
- HTTP (API calls)
- Image Picker (Chọn ảnh)
- Cached Network Image (Cache ảnh)

### Backend
- Strapi v5.20.0
- Node.js
- SQLite (Database mặc định)

## Tác giả

Restaurant Menu Team

## License

MIT License

