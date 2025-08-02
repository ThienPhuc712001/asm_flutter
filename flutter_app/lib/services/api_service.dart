import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/dish.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:1337/api';
  
  // Dishes endpoints
  Future<List<Dish>> getDishes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dishes?populate=*'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dishesData = data['data'];
        return dishesData.map((json) => Dish.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load dishes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dishes: $e');
    }
  }

  Future<Dish> createDish(Dish dish, {File? imageFile}) async {
    try {
      Map<String, dynamic> dishData = dish.toJson();
      
      final response = await http.post(
        Uri.parse('$baseUrl/dishes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': dishData}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Dish.fromJson(data['data']);
      } else {
        throw Exception('Failed to create dish: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating dish: $e');
    }
  }

  Future<Dish> updateDish(int id, Dish dish) async {
    try {
      Map<String, dynamic> dishData = dish.toJson();
      
      final response = await http.put(
        Uri.parse('$baseUrl/dishes/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': dishData}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Dish.fromJson(data['data']);
      } else {
        throw Exception('Failed to update dish: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating dish: $e');
    }
  }

  Future<void> deleteDish(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/dishes/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete dish: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting dish: $e');
    }
  }

  // Categories endpoints
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoriesData = data['data'];
        return categoriesData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<Category> createCategory(Category category) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': category.toJson()}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Category.fromJson(data['data']);
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Search dishes by name
  Future<List<Dish>> searchDishes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dishes?populate=*&filters[name][\$containsi]=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dishesData = data['data'];
        return dishesData.map((json) => Dish.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search dishes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching dishes: $e');
    }
  }

  // Filter dishes by category
  Future<List<Dish>> getDishesByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dishes?populate=*&filters[category][id][\$eq]=$categoryId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dishesData = data['data'];
        return dishesData.map((json) => Dish.fromJson(json)).toList();
      } else {
        throw Exception('Failed to filter dishes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering dishes: $e');
    }
  }
}

