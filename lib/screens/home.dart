import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'globals.dart' as globals;
import 'package:flutter_app/database/local.dart';
import 'package:sqflite/sqflite.dart';
Future<Database> local = globals.local;

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
    //Check that we log out when quitting the app
    print(globals.log_id);
    print(globals.isLoggedIn);
    return FutureBuilder(
        future: Local.cows(local),
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


