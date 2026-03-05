import 'dart:async';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String tblMovieWatchlist = 'watchlist';
  static const String tblTvSeriesWatchlist = 'tv_watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    final db = await openDatabase(
      databasePath,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $tblMovieWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $tblTvSeriesWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tblTvSeriesWatchlist (
          id INTEGER PRIMARY KEY,
          name TEXT,
          overview TEXT,
          posterPath TEXT
        );
      ''');
    }
  }

  Future<int> insertWatchlist(covariant Object? movie) async {
    final db = await database;
    return db!.insert(tblMovieWatchlist, _toJsonMap(movie));
  }

  Future<int> removeWatchlist(covariant Object? id) async {
    final db = await database;
    return db!.delete(
      tblMovieWatchlist,
      where: 'id = ?',
      whereArgs: [_resolveId(id)],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      tblMovieWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    return db!.query(tblMovieWatchlist);
  }

  Future<int> insertTvSeriesWatchlist(covariant Object? tvSeries) async {
    final db = await database;
    return db!.insert(tblTvSeriesWatchlist, _toJsonMap(tvSeries));
  }

  Future<int> removeTvSeriesWatchlist(covariant Object? id) async {
    final db = await database;
    return db!.delete(
      tblTvSeriesWatchlist,
      where: 'id = ?',
      whereArgs: [_resolveId(id)],
    );
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      tblTvSeriesWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    return db!.query(tblTvSeriesWatchlist);
  }

  Map<String, dynamic> _toJsonMap(Object? value) {
    if (value == null) {
      throw ArgumentError('Value cannot be null');
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    final dynamic dynamicValue = value;
    final dynamic json = dynamicValue.toJson();
    if (json is Map<String, dynamic>) {
      return json;
    }
    if (json is Map) {
      return Map<String, dynamic>.from(json);
    }

    throw ArgumentError('Unsupported value type: ${value.runtimeType}');
  }

  int _resolveId(Object? value) {
    if (value == null) {
      throw ArgumentError('Value cannot be null');
    }

    if (value is int) {
      return value;
    }

    final dynamic dynamicValue = value;
    final dynamic id = dynamicValue.id;
    if (id is int) {
      return id;
    }

    throw ArgumentError('Unsupported id type: ${value.runtimeType}');
  }
}
