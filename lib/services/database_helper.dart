import 'package:cafeteria_cuc/demo/populate_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cafeteria_cuc/models/product_model.dart';
import 'package:cafeteria_cuc/models/sales_model.dart';
import 'package:cafeteria_cuc/models/sale_detail_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("cafeteria.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      //Instrucción para poder usar llaves foreaneas en sqflite
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      //DEMO: 
      
      onCreate: _createDB,

    );
  }
  //
  Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE products (
      product_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL
    )
  ''');
  
  await db.execute('''
    CREATE TABLE sales (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      time TEXT NOT NULL
    )
  ''');

  await db.execute('''
    CREATE TABLE sales_detail (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sale_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      total REAL NOT NULL,
      FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
    )
  ''');

  await seedProducts(db);
}


  // Create a product
  Future<int> createProduct(Product product) async {
    final db = await instance.database;

    return await db.rawInsert(
    'INSERT INTO products (name, price) VALUES (?, ?)',
    [product.name, product.price],
  );
  }
  // Read product
  Future<List<Product>> readProducts() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM products');
    return result.map((map) => Product.fromMap(map)).toList();
  }
  // Update product
  Future<int> updateProducts(Product product) async {
    final db = await instance.database;
    return await db.rawUpdate(
    'UPDATE products SET name = ?, price = ? WHERE product_id = ?',
    [product.name, product.price, product.id],
    );
  }

  //Logic delete product. REQUIRES MODIFICATION IN PRODUCT MODEL (ADD is_active Column)
  Future<int> logicDeleteProduct(Product product) async{
    final db = await instance.database;
    return await db.rawUpdate(
    'UPDATE products SET is_active = ? WHERE product_id ?',
      //[product.is_active,product.id]
    );
  }
  // Delete product
  Future<int> deleteProducts(int productId) async {
    final db = await instance.database;
    return await db.rawDelete(
    'DELETE FROM products WHERE product_id = ?',
    [productId],
  );
  }





  // CRUD SALES
  Future<int> createSale(Sales sale) async {
  final db = await instance.database;
  return await db.insert('sales', sale.toMap());
}

// Read sale
Future<List<Sales>> readAllSales() async {
  final db = await instance.database;
  final result = await db.query('sales');
  return result.map((map) => Sales.fromMap(map)).toList();
}

// Update sale
Future<int> updateSale(Sales sale) async {
  final db = await instance.database;
  return await db.update(
    'sales',
    sale.toMap(),
    where: 'sale_id = ?',
    whereArgs: [sale.id],
  );
}

// Delete sale
Future<int> deleteSale(int id) async {
  final db = await instance.database;
  return await db.delete(
    'sales',
    where: 'sale_id = ?',
    whereArgs: [id],
  );
}

// Create a sale detail
// Create
Future<int> createSalesDetail(SalesDetail detail) async {
  final db = await instance.database;
  return await db.insert('sales_detail', detail.toMap());
}

// Read all
Future<List<SalesDetail>> readAllSalesDetail() async {
  final db = await instance.database;
  final result = await db.query('sales_detail');
  return result.map((map) => SalesDetail.fromMap(map)).toList();
}

// Read by sale_id
Future<List<SalesDetail>> readDetailsBySaleId(int id) async {
  final db = await instance.database;
  final result = await db.query(
    'sales_detail',
    where: 'sale_id = ?',
    whereArgs: [id],
  );
  return result.map((map) => SalesDetail.fromMap(map)).toList();
}

// Update
Future<int> updateSalesDetail(SalesDetail detail) async {
  final db = await instance.database;
  return await db.update(
    'sales_detail',
    detail.toMap(),
    where: 'id = ?',
    whereArgs: [detail.id],
  );
}

// Delete
Future<int> deleteSalesDetail(int id) async {
  final db = await instance.database;
  return await db.delete(
    'sales_detail',
    where: 'id = ?',
    whereArgs: [id],
  );
}



// Select para ORDENES

Future<List<Map<String, dynamic>>> readSales() async {
  final db = await instance.database;

  final result = await db.rawQuery('''
    SELECT 
      sd.id AS sale_detail_id,
      s.id AS sale_id,
      s.date AS date,
      s.time AS time,
      p.name AS item_name,
      sd.quantity AS quantity,
      p.price AS price,
      sd.total AS total
    FROM sales_detail sd
    JOIN sales s ON sd.sale_id = s.id
    JOIN products p ON sd.product_id = p.product_id
    ORDER BY s.id DESC, sd.id ASC
  ''');

  return result;
}




}
