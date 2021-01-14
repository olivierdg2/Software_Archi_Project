//Screen where user's cows are displayed
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_app/database/local.dart';
import 'package:sqflite/sqflite.dart';

//Get local db connection from globals
Future<Database> local = globals.local;

class HomeScreen extends StatefulWidget {

  static final String id = 'home__screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Delete a cow from the local db
  _delete(id){
    Local.deleteCow(id, local);
    setState(() {});
  }
  //Build the screen from a list builder
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildCowListView(),
    );
  }

  //List builder
  _buildCowListView(){
    //Check that we log out when quitting the app
    print(globals.log_id);
    print(globals.isLoggedIn);
    Local.testCow(local);
    return FutureBuilder(
        future: Local.cows(local),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          //In case display could take long time
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _delete(snapshot.data[index].id)
                    )
                  );
                },
            );
          }
        }
    );
  }
}


