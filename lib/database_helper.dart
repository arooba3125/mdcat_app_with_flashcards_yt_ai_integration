// Importing the necessary packages to interact with SQLite databases and handle file paths.
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Definition of the DatabaseHelper class.
class DatabaseHelper {
  // Singleton instance to ensure that there is only one instance of DatabaseHelper throughout the application.
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  // Private static variable to hold the database instance.
  static Database? _database;

  // Factory constructor to return the existing instance of DatabaseHelper.
  factory DatabaseHelper() {
    return _instance;
  }

  // Named private constructor for internal use to create the singleton instance.
  DatabaseHelper._internal();

  // Getter to retrieve the database instance asynchronously.
  Future<Database> get database async {
    // If the database instance is already available, return it.
    if (_database != null) return _database!;
    // Initialize the database if not already done.
    _database = await _initDatabase();
    return _database!;
  }

  // Asynchronous method to initialize the database.
  Future<Database> _initDatabase() async {
    // Get the path where the SQLite database is stored on the device.
    final dbPath = await getDatabasesPath();
    // Join the database path with the name of the database file.
    final path = join(dbPath, 'flashcards.db');

    // Open the database or create it if it doesn't exist.
    return await openDatabase(
      path,
      version: 1,  // Version number for the database, used in migrations.
      onCreate: (db, version) {
        // SQL statement to create a new table 'cards'.
        return db.execute(
          'CREATE TABLE cards (id INTEGER PRIMARY KEY, chapter TEXT, front TEXT, back TEXT)',
        );
      },
    );
  }

  // Asynchronous method to insert a new card into the 'cards' table.
  Future<void> insertCard(String chapter, String front, String back) async {
    // Retrieve the database instance.
    final db = await database;
    // Insert a card into the 'cards' table.
    await db.insert(
      'cards',
      {'chapter': chapter, 'front': front, 'back': back},
      conflictAlgorithm: ConflictAlgorithm.replace, // In case of a conflict, replace the old data.
    );
  }

  // Asynchronous method to retrieve all cards from a specific chapter.
  Future<List<Map<String, dynamic>>> getCards(String chapter) async {
    // Retrieve the database instance.
    final db = await database;
    // Query the database for all cards in a specific chapter.
    return await db.query('cards', where: 'chapter = ?', whereArgs: [chapter]);
  }

  // Asynchronous method to delete a card by its ID.
  Future<void> deleteCard(int id) async {
    // Retrieve the database instance.
    final db = await database;
    // Delete a card from the 'cards' table by ID.
    await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }
}
