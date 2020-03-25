class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal();
}
