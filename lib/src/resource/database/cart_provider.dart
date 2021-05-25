import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';

final String tableCart = 'tb_Cart';
final String tableCartItem = 'tb_cartItem';

class CartProvider {
  static final _databaseName = "KingBuy.db";

  CartProvider._();

  static final CartProvider instance = CartProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return open(path);
  }

  // Các Column bảng Cart
  String cartColumns = 'id, total_quantity, delivery_address_id, date_time, '
      'hour_time, payment_type, note, is_export_invoice, coupon_id, total_unread';

  // Các Column bảng CartItem
  String cartItemColumns = 'id, qty, product_id, has_read, color_id';

  Future open(String path) async {
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Tạo bảng Cart
    await db.execute('''
          CREATE TABLE $tableCart ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            total_quantity INTEGER,
            delivery_address_id INTEGER,
            date_time TEXT,
            hour_time TEXT,
            payment_type INTEGER,
            note TEXT,
            is_export_invoice INTEGER,
            coupon_id INTEGER,
            total_unread INTEGER,
            delivery_status INTEGER,
            save_point INTEGER
            )
          ''');
    // Tạo bảng CartItem
    await db.execute('''
          CREATE TABLE $tableCartItem ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            product_id INTEGER NOT NULL,
            qty INTEGER NOT NULL,
            has_read INTEGER,
            color_id INTEGER
            )
          ''');
  }

  Future<CartModel> getCart() async {
    Database db = await database;
    List<Map> maps = await db.query(
      tableCart,
      columns: cartColumns.split(",").toList(),
    );
    if (maps.length > 0) {
      return CartModel.fromJson(maps.first);
    }
    return null;
  }

  Future<List<CartItem>> getCartItems() async {
    Database db = await database;
    List<Map> maps = await db.query(tableCartItem, columns: cartItemColumns.split(",").toList());
    if (maps.length > 0) {
      return CartItem.listFromJson(maps);
    }
    return null;
  }

  Future<CartItem> getCartItem(String field, dynamic val) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCartItem, columns: [cartItemColumns], where: '$field = ?', whereArgs: [val]);
    if (maps.length > 0) {
      return CartItem.fromJson(maps.first);
    }
    return null;
  }

  Future insertCart(CartModel item) async {
    Database db = await database;
    return await db.insert(tableCart, item.toMap());
  }

  Future insertCartItem(CartItem item) async {
    Database db = await database;
    int id = await db.insert(tableCartItem, item.toMap());
    return id;
  }

  Future<int> updateCart(CartModel item) async {
    Database db = await database;
    return await db.update(tableCart, item.toMap(), where: 'id = ${item.id}');
  }

  Future<int> readAll() async {
    Database db = await database;
    db.rawUpdate('UPDATE $tableCart SET total_unread = 0');
    return await db.rawUpdate('UPDATE $tableCartItem SET has_read = 1');
  }

  Future<int> updateCartItem(CartItem item) async {
    Database db = await database;
    return await db.update(tableCartItem, item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteCartItem(int id) async {
    Database db = await database;
    return await db.delete(tableCartItem, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllCartItem() async {
    print("delete All CartItem");
    Database db = await database;
    return await db.delete(tableCartItem);
  }

  Future<int> deleteCart() async {
    print("delete Cart");
    Database db = await database;
    return await db.delete(tableCart);
  }
}
