import 'package:midterm/models/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._privateConstructor();
  static Database? _database;

  DbHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pos.db');
    return await openDatabase(
      path,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) {
        // Update database/table structure
      },
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  Future<void> createTable(Database db) async {
    await db.execute(
      'CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, price DOUBLE, category STRING, stock INTEGER, image STRING);',
    );
  }

  Future<void> saveProductToFavorite(Product product) async {
    final db = await database;
    final result = await db.insert(
      'products',
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(result);
  }

  Future<List<Product>> getFavoriteProducts() async {
    final db = await database;
    final result = await db.query('products');
    List<Product> products = [];
    for (var element in result) {
      products.add(Product.fromJson(element));
    }
    return products;
  }
}
