import 'dart:async';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/movieList.dart';
import 'package:flutter/material.dart';
import 'MovieDataModel.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';



MoviesList moviesList = new MoviesList();


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  moviesList.saveMovies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SearchBar searchBar;

  String newMovies = "";
  
  
  List<Widget> wid = [];
  @override
  initState() {

    super.initState();
    
    moviesList.getLengthOfNewMovies().then((value) => newMovies = "$value");
    
    Future<List<MovieModel>> list;
    Future<List<NewMovies>> newMoviesList;
    
    list = moviesList.getAllMovies();
    newMoviesList =  moviesList.getNewMovies();

    wid.add(FutureBuilder(
      future: list,
      builder: (context, AsyncSnapshot<List<MovieModel>> snapshot) {
        if(snapshot.data!=null)
         return AllTabContent(movieList: snapshot.data, len: snapshot.data.length);  
        return Container(
            height: 200,
            child:Center(
              child:CircularProgressIndicator()
            )
          );
        },
      )
    );
    wid.add(FutureBuilder(
      future: newMoviesList,
      builder: (context, AsyncSnapshot<List<NewMovies>> snapshot) {
        
        if(snapshot.data!=null){
          if(snapshot.data.length > 0){
            return NewTabContent(list: snapshot.data, len: snapshot.data.length);}
          else{
            return Container(
              height: 200,
              child:Center(
                child:Text("No new movies")
              )
            );
          }  
        }
       
      return CircularProgressIndicator();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          drawer: ListOfNav(),
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search, color: Colors.white,),
              )
              // searchBar.getSearchAction(context)
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "All",
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New"),
                      Container(
                          key: Key("1"),
                          margin: EdgeInsets.only(bottom: 2.0, left: 1.5),
                          padding: newMovies.length >= 1 || newMovies != '0'
                              ? EdgeInsets.all(2.5)
                              : EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            newMovies,
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                )
              ],
            ),
            title: Text('MovieBase'),
            
          ),
          body: new TabBarView(
              children: wid
            ),
        ),
      ),
    );
  }
}

class ListOfNav extends StatelessWidget {
  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('images/nav.jpg'),
      )),
      child: null,
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.blue,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.info,
              text: 'About',
              onTap: () {
                showAboutDialog(
                    context: (context),
                    applicationName: "MovieBase",
                    children: [
                      Divider(),
                      Text("This app is a personal project developed by:"),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          "Muhammad Muddassar",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text("Email:"),
                      Text("muddassar087@gmail.com")
                    ]);
              }),
          _createDrawerItem(
            icon: Icons.help,
            text: 'Help',
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.face,
            text: 'Profile',
          ),
          Divider(),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NewTabContent extends StatefulWidget {
  List<NewMovies> list = [];
  int len;
  NewTabContent(
    {
      this.list, 
      this.len,
    }
  );
  @override
  _NewTabContentState createState() => _NewTabContentState(list: list, len: len);
}

class _NewTabContentState extends State<NewTabContent> {
  List<NewMovies> list = [];
  int len;
  _NewTabContentState(
    {this.list, this.len}
  );

  @override
  void initState() {
    super.initState();
    moviesList.deleteNewMovies();
  }
  @override
  Widget build(BuildContext context) {
    
    int ind = 0;
    return ListView.builder(
      itemCount:len*2,
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider();
        return ListTile(title: Text("${list[ind++].title.substring(0, 15)}"));
      },
    );
  }
}

// ignore: must_be_immutable
class AllTabContent extends StatefulWidget {
  List<MovieModel> movieList = [];
  int len = 0;
  AllTabContent({this.movieList, this.len = 0});
  @override
  AllTabContentApp createState() => new AllTabContentApp(movieList: this.movieList, len: this.len);
}

class AllTabContentApp extends State<AllTabContent>{
  
  List<MovieModel> movieList = [];
  int len = 0;
  
  AllTabContentApp({this.movieList, this.len});

  int counter = 0;
  bool cboxValue = false;

  @override
  Widget build(BuildContext ctxt) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
                  child: Text("Movies",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ),
                Container(
                    margin: EdgeInsets.only(left: 1.0, bottom: 12.0, top: 10.0),
                    padding: EdgeInsets.only(
                        left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                    decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(100.0)),
                    child: Text("$len",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            backgroundColor: Colors.blue))),
              ],
            )),
        Container(
          height: this.len > 0 ? 7 : 0,
          decoration: BoxDecoration(
            border: null,
            boxShadow: [
              BoxShadow(
                offset: Offset(4, 8),
                blurRadius: 15,
                color: Colors.grey
              )
            ]
          ),
        ),
        Expanded(
          child: movieList.length > 0 ? CardList(string: this.movieList, len: this.len) :
            Center(child: Text("you have'nt downloaded any movies yet"),)
          ,
        ),
        
      ],
    );
  }

}
/*

*/
// ignore: must_be_immutable
class CardList extends StatefulWidget {

  List<MovieModel> string;
  int len;
  CardList({@required this.string, @required this.len});
  
  @override
  _CardListState createState() => _CardListState(list: string, len: len);
}

class _CardListState extends State<CardList>{

  bool isclicked = false;
  int rating = 0;
  List<MovieModel> list = [];

  int len;

  _CardListState({this.list, this.len});

  Widget card(text, subtext, id, rate) {
    print(rate);
    return Container(
        height: 100,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0, top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          text.replaceAll(
                                new RegExp("ESubs|Dual|Audio|x264|BluRay|480p|720p|Themoviesflix|co|mkv|Hindi|English"), " ")
                                .replaceAll(".", " ")
                                .replaceAll("-", " ")
                                .replaceAll("(", "")
                                .replaceAll(")", "")
                                .replaceAll("  ", ""),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(subtext),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                      color: Colors.blue,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // moviesList.deleteAllMovies();
                          });
                        },
                        child: Text("Open",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ))
                ],
              ),
              Divider(
                color: Colors.black12,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                    child: Text("Rate", style: TextStyle(fontSize: 16))),
                Container(
                  margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
                  child: SingleChildScrollView(
                    child: Row(children: <Widget>[
                      Container(
                        height: 20,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return StarRating(
                              onChanged: (index) {
                                setState(() {
                                  moviesList.updateRating(id, index);
                                  rating = index;
                                });
                              },
                              value: rating > 0 ? rating : rate,
                            );
                          },
                        ),
                      )
                    ]),
                  ),
                )
              ])
            ],
          ),
        ),
      ); 
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
      itemCount: this.len,
      itemBuilder: (context, index) {
        MovieModel obj = list[index];
        print(obj.getRating());
        return card(obj.getTitle().substring(0, 15), obj.getDateCreated(), obj.getId(), obj.getRating());
        },
      );         
    }
}

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final IconData filledStar;
  final IconData unfilledStar;

  const StarRating({
    Key key,
    @required this.onChanged,
    this.value = 0,
    this.filledStar,
    this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).accentColor;
    final size = 25.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 20,
          child: IconButton(
            onPressed: onChanged != null
                ? () {
                    onChanged(value == index + 1 ? index : index + 1);
                
                  }
                : null,
            color: index < value ? color : null,
            iconSize: size,
            icon: Icon(
              index < value
                  ? filledStar ?? Icons.star
                  : unfilledStar ?? Icons.star_border,
                  color: Colors.amberAccent,
            ),
            padding: EdgeInsets.zero,
            tooltip: "${index + 1} of 3",
          ),
        );
      }),
    );
  }
}