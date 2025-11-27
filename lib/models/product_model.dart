  import 'dart:convert';

class Product {
  final int? id;
  final String name;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.price
    }
  );

  // Convert Product → Map (for DB)
  Map<String, dynamic> toMap() {
    return {
      'product_id': id,
      'name': name,
      'price': price
    };
  }

  // Convert Map → Product (from DB)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['product_id'],
      name: map['name'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each Product when using the print statement.
  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}
