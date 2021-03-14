import 'package:flutter_application_1/MovieDataModel.dart';
import 'package:flutter_application_1/db.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:intl/intl.dart';

class MoviesList {
  MovieBaseDB database = MovieBaseDB();

  List<MovieModel> _title = [];
  List<String> titles = [];

  Future<List<MovieModel>> createList() async {
    List<AssetPathEntity> list =
        await PhotoManager.getAssetPathList(type: RequestType.video);
    for (int i = 0; i < list.length; i++) {
      final assetList = await list[i].getAssetListRange(start: 0, end: 100000);
      for (AssetEntity a in assetList) {
        if (a.duration / 60 > 60.0 && !titles.contains(a.title)) {
          titles.add(a.title);
          var date = DateTime.fromMillisecondsSinceEpoch(a.createDtSecond * 1000);
          var formattedDate = DateFormat.yMMMd().format(date);
          _title.add(
              new MovieModel(id:int.parse(a.id),title: a.title, dateCreated: "$formattedDate"));
        }
      }
    }
    return _title;
  }

  void saveMovies() async {
    database.newMovies(await createList());
  }

  Future<List<MovieModel>> getAllMovies() async {
    return await database.getMovies();
  }

  void deleteTable() {
    database.deleteTable();
  }

  Future<int> getLengthOfNewMovies() async {
    int len = 0;
    await database.getNewMovies().then((value) => len = value.length);
    return len;
  }

  getNewMovies() {
    return database.getNewMovies();
  }

  deleteAllMovies() {
    database.deleteAllMovies();
  }

  deleteNewMovies() {
    database.delteteNewMovies();
  }

  updateRating(int id, rating){
    database.updateRating(id, rating);
  }
}
