class Product {
  int id;
  String name;
  String category;
  double price;
  int stock;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      stock: 10, // Fake API has no stock → mock it
    );
  }
}
