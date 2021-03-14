import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_1/MovieDataModel.dart';

class MovieBaseDB {
  MovieBaseDB() {
    // pass
  }

  static Database _database;

  getDatabase() async {
    if (_database == null) return await initDB();
    return _database;
  }
  
  initDB() async {
    // String path  = join(await getDatabasesPath(), 'db.db');
    return await openDatabase("dataB.db",  
      onCreate: (db, version) {
          db.execute(
              "CREATE TABLE IF NOT EXISTS newMovies(id INTEGER AUTO_INCREMENT, title TEXT UNIQUE, PRIMARY KEY(id))");
          return db.execute(
              "CREATE TABLE IF NOT EXISTS movieBase(id INTEGER , title TEXT UNIQUE, dateCreated TEXT, rating Integer, PRIMARY KEY(id))");
    }, version: 1);
  }

  deleteTable() async {
    _database = await getDatabase();
    _database.execute("DROP TABLE IF EXISTS movieBase");
  }

  //list of movies from device
  newMovies(List<MovieModel> list) async {
    _database = await getDatabase();

    Map<String, dynamic> listOfMovies = {};
    list.forEach((element) {
      listOfMovies.addAll(element.toMap());
    });

    _database.insert(
      "movieBase",
      listOfMovies,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //all movies list

    Map<String, dynamic> newMoviesMap = {};

    list.forEach((element) {
      newMoviesMap.addAll(new NewMovies(title: element.title).toMap());
    });

    if (!(newMoviesMap.length <= 0)) {
      _database.insert(
        "newMovies",
        newMoviesMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<MovieModel>> getMovies() async {
    
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('movieBase');

    String sql = "SELECT * FROM movieBase";
    var result = await db.rawQuery(sql);

    print(result);

    return List.generate(maps.length, (i) {
      return MovieModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        dateCreated: maps[i]['dateCreated'],
        rating: maps[i]['rating']
      );
    });
  }

  Future<List<NewMovies>> getNewMovies() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('newMovies');
    return List.generate(maps.length, (i) {
      return NewMovies(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }

  deleteAllMovies() async {
    final Database db = await getDatabase();

    db.rawDelete("DELETE FROM movieBase");
  }

  delteteNewMovies() async {
    final Database db = await getDatabase();

    db.rawDelete("DELETE FROM newMovies");
  }

  updateRating(int id, int rating) async {
    final Database db = await getDatabase();
    db.rawUpdate("Update movieBase set rating = $rating where id = '$id'");
  }
}
