import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print('Initializing database...');
    String path = join(await getDatabasesPath(), 'bank.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        username TEXT,
        password TEXT,
        balance INTEGER
      )
    ''');
  }

  Future<String> insertUser(Map<String, dynamic> user) async {
    final db = await DatabaseHelper().database;

    // Check if a user with the same username already exists
    List<Map<String, dynamic>> existingUsers = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [user['username']],
    );

    if (existingUsers.isNotEmpty) {
      // A user with the same username already exists
      return 'A user with this username already exists.';
    }
    // Insert the new user
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return "New user created";
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await DatabaseHelper().database;

    // Query to find the user by username
    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id', 'name', 'username', 'balance'],
      where: 'username = ?',
      whereArgs: [username],
    );

    // If a user is found, return the User object, otherwise return null
    if (result.isNotEmpty) {
      return User(
        id: result.first['id'],
        username:
            result.first['username'], // Access the username from the result
        name: result.first['name'], // Access the name from the result
        balance: result.first['balance'],
      );
    } else {
      return null;
    }
  }

  Future<String> updateUserBalance(int id, int newBalance) async {
    final db = await DatabaseHelper().database;
    await db.update(
      'users',
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [id],
    );
    return "Balance Updated";
  }

  Future<String> verifyUser(String username, String password) async {
    final db = await database;

    // Query the user with the specified username
    List<Map<String, dynamic>> user = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    // Check if user exists
    if (user.isEmpty) {
      return 'User not found.';
    }

    // Check if the password matches
    if (user.first['password'] == password) {
      return 'User verified successfully.';
    } else {
      return 'Incorrect password.';
    }
  }
}
