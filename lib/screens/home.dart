import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/database/db_test.dart';
import 'package:sqflite/sqflite.dart';

DB db = new DB();
Future<Database> database = db.db_init();

class HomeScreen extends StatefulWidget {

  static final String id = 'home__screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildCowListView(),
    );
  }

  _buildCowListView(){
    return FutureBuilder(
        future: db.cows(database),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black12,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    leading: Text(
                      "${index + 1}",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    title: Text(
                      "Id: ${snapshot.data[index].id}"
                    ),
                    subtitle: Text(
                        "Description: ${snapshot.data[index].description}"
                    ),
                  );
                },
            );
          }
        }
    );
  }
}


