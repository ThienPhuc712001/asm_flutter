import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dish.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import 'dish_detail_screen.dart';
import 'dish_form_screen.dart';

class DishListScreen extends StatefulWidget {
  @override
  _DishListScreenState createState() => _DishListScreenState();
}

class _DishListScreenState extends State<DishListScreen> {
  List<Dish> _dishes = [];
  List<Category> _categories = [];
  List<Dish> _filteredDishes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  Category? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final dishes = await apiService.getDishes();
      final categories = await apiService.getCategories();
      
      setState(() {
        _dishes = dishes;
        _categories = categories;
        _filteredDishes = dishes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Lỗi tải dữ liệu: $e');
    }
  }

  void _filterDishes() {
    setState(() {
      _filteredDishes = _dishes.where((dish) {
        final matchesSearch = dish.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == null || dish.category?.id == _selectedCategory?.id;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterDishes();
  }

  void _onCategoryChanged(Category? category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterDishes();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDish(Dish dish) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa món "${dish.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && dish.id != null) {
      try {
        final apiService = Provider.of<ApiService>(context, listen: false);
        await apiService.deleteDish(dish.id!);
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xóa món "${dish.name}"')),
        );
      } catch (e) {
        _showErrorDialog('Lỗi khi xóa món ăn: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thực đơn nhà hàng'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm món ăn...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _onSearchChanged,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<Category?>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Lọc theo danh mục',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem<Category?>(
                      value: null,
                      child: Text('Tất cả danh mục'),
                    ),
                    ..._categories.map((category) => DropdownMenuItem<Category?>(
                      value: category,
                      child: Text(category.name),
                    )),
                  ],
                  onChanged: _onCategoryChanged,
                ),
              ],
            ),
          ),
          // Dishes List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredDishes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Không có món ăn nào',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            if (_searchQuery.isNotEmpty || _selectedCategory != null)
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                  _onCategoryChanged(null);
                                },
                                child: Text('Xóa bộ lọc'),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _filteredDishes.length,
                        itemBuilder: (context, index) {
                          final dish = _filteredDishes[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            child: ListTile(
                              leading: dish.imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: 'http://localhost:1337${dish.imageUrl}',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.restaurant),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.restaurant),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.restaurant),
                                    ),
                              title: Text(
                                dish.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (dish.category != null)
                                    Text(
                                      dish.category!.name,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 12,
                                      ),
                                    ),
                                  Text(
                                    '${dish.price.toStringAsFixed(0)} VNĐ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Chỉnh sửa'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Xóa', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DishFormScreen(dish: dish),
                                      ),
                                    ).then((_) => _loadData());
                                  } else if (value == 'delete') {
                                    _deleteDish(dish);
                                  }
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DishDetailScreen(dish: dish),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DishFormScreen(),
            ),
          ).then((_) => _loadData());
        },
        child: Icon(Icons.add),
        tooltip: 'Thêm món ăn mới',
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

