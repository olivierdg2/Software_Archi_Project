import 'package:flutter/material.dart';
import 'package:flutter_app/database/db_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class InputScreen extends StatefulWidget {

  static final String id = 'input_screen';

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  int _id;
  String _description;

  _add(int id, String description,DB db,Future<Database> database) async{
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      var cow = Cow(
        id: id,
        description: _description,
      );
      db.insertCow(cow,database);
      print(await db.cows(database));
    }
  }

  @override
  Widget build(BuildContext context) {
    DB db = new DB();
    Future<Database> database = db.db_init();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Moi przyjaciele krowy',
              style: TextStyle(
                  fontSize: 30.0,
                  fontFamily:
                  'OpenSans'
              ),
            ),
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
                      onPressed: () => _add(_id,_description,db,database),
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
