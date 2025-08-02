import 'category.dart';

class Dish {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final Category? category;

  Dish({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.category,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image']?['url'],
      category: json['category'] != null 
          ? Category.fromJson(json['category']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category?.id,
    };
  }

  Dish copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    Category? category,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}

