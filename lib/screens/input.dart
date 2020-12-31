//Screen where the user can add a cow to its local db
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/database/local.dart';
import 'globals.dart' as globals;
import 'package:sqflite/sqflite.dart';

//get local connection from globals
Future<Database> local = globals.local;

class InputScreen extends StatefulWidget {

  static final String id = 'input_screen';

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  //Cow information form
  final _formKey = GlobalKey<FormState>();
  int _id;
  String _description;

  //Add cow from its information to local db
  _add_cow(int id, String description) async{
    //Cow information form
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      var cow = Cow(
        id: id,
        description: description,
      );
      Local.insertCow(cow,local);
      //debugging
      print(Local.cows(local));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Image.asset("assets/images/cow.png")),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                      decoration: InputDecoration(
                          labelText: 'Cow Id'
                      ),
                      validator: (input) => input.trim().isEmpty
                          ? 'Please enter a valid Cow id'
                          : null,
                      onSaved: (input) => _id = int.parse(input),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: 'Description'
                      ),
                      onSaved: (input) => _description = input,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: () => _add_cow(_id,_description),
                      color: Colors.blue,
                      child: Text(
                        'Add cow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
