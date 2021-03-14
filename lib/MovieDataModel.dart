class MovieModel {
  int id;
  String title;
  String dateCreated;
  int rating;
  
  MovieModel({this.id, this.title, this.dateCreated, this.rating = 0});

  void setTitle(title) {
    this.title = title;
  }

  void setId(id) {
    this.id = id;
  }

  void setCreated(date) {
    this.dateCreated = date;
  }

  String getDateCreated() => dateCreated;
  int getId() => id;
  int getRating() => rating;
  String getTitle() => title;

  Map<String, dynamic> toMap() {
    return {
      'id':this.id,
      'title': this.title,
      'dateCreated': this.dateCreated,
      'rating':this.rating
    };
  }
}

class NewMovies {
  int id;
  String title;
  NewMovies({this.id, this.title});
  void setTitle(title) {
    this.title = title;
  }

  void setId(id) {
    this.id = id;
  }

  int getId() => id;
  String getTitle() => title;
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
    };
  }
}
