class Product {
  int id;
  String name;
  String category;
  double price;
  int stock;
  String image;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
    required this.isFavorite
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      // This checks the API key 'title' first, then the DB key 'name'
      name: json['title'] ?? json['name'] ?? 'No Name',
      category: json['category'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      stock: json['stock'] ?? 10,
      isFavorite: json['favorite'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name, 
      'price': price,
      'category': category,
      'image': image,
      'stock': stock,
      'isFavorite': isFavorite
    };
  }
}
