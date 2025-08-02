import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dish.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Dish> _dishes = [];
  List<Category> _categories = [];
  bool _isLoading = true;

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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, int> _getDishesByCategory() {
    Map<String, int> categoryCount = {};
    
    for (var category in _categories) {
      categoryCount[category.name] = 0;
    }
    
    for (var dish in _dishes) {
      if (dish.category != null) {
        categoryCount[dish.category!.name] = 
            (categoryCount[dish.category!.name] ?? 0) + 1;
      }
    }
    
    return categoryCount;
  }

  double _getAveragePrice() {
    if (_dishes.isEmpty) return 0;
    double total = _dishes.fold(0, (sum, dish) => sum + dish.price);
    return total / _dishes.length;
  }

  double _getMaxPrice() {
    if (_dishes.isEmpty) return 0;
    return _dishes.map((dish) => dish.price).reduce((a, b) => a > b ? a : b);
  }

  double _getMinPrice() {
    if (_dishes.isEmpty) return 0;
    return _dishes.map((dish) => dish.price).reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Tổng số món',
                          _dishes.length.toString(),
                          Icons.restaurant_menu,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Danh mục',
                          _categories.length.toString(),
                          Icons.category,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Price Statistics
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Giá trung bình',
                          '${_getAveragePrice().toStringAsFixed(0)} VNĐ',
                          Icons.trending_up,
                          Colors.orange,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Giá cao nhất',
                          '${_getMaxPrice().toStringAsFixed(0)} VNĐ',
                          Icons.arrow_upward,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Category Distribution
                  Text(
                    'Phân bố theo danh mục',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  if (_categories.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.category, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Chưa có danh mục nào',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._getDishesByCategory().entries.map((entry) {
                      final percentage = _dishes.isEmpty 
                          ? 0.0 
                          : (entry.value / _dishes.length) * 100;
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${entry.value} món (${percentage.toStringAsFixed(1)}%)',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: _dishes.isEmpty ? 0 : entry.value / _dishes.length,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  
                  SizedBox(height: 24),
                  
                  // Price Range
                  Text(
                    'Khoảng giá',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  if (_dishes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.attach_money, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Chưa có dữ liệu giá',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Giá thấp nhất',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${_getMinPrice().toStringAsFixed(0)} VNĐ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.green.withOpacity(0.3),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Giá cao nhất',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${_getMaxPrice().toStringAsFixed(0)} VNĐ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

