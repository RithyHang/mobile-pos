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

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     id: json['id'],
  //     name: json['title'],
  //     category: json['category'],
  //     price: (json['price'] as num).toDouble(),
  //     image: json['image'],
  //     stock: 10, // Fake API has no stock → mock it
  //   );
  // }

  // Map<String, dynamic> toJson(){
  //   return{
  //     'name': name,
  //     'price': price,
  //     'category': category,
  //     'image': image,
  //     'stock': stock
  //   };
  // }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      // This checks the API key 'title' first, then the DB key 'name'
      name: json['title'] ?? json['name'] ?? 'No Name',
      category: json['category'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      stock: json['stock'] ?? 10,
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
    };
  }
}
