//Screen where the user can sign up
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_app/database/online.dart';
import 'package:sqflite/sqflite.dart';
//Get online connection
Future<Database> online = globals.online;

class SignupScreen extends StatefulWidget {

  static final String id = 'signup__screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //User information form
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  //Add a User from its email and pwd in the selected online db
  _add_user(String email, String pwd) async{
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      Online.insertUser(email,pwd,online);
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
            Text(
              'Information',
              style: TextStyle(
                  fontSize: 50.0,
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
                      decoration: InputDecoration(
                          labelText: 'Email'
                      ),
                      validator: (input) => !input.contains('@')
                          ? 'Please enter a valid email'
                          : null,
                      onSaved: (input) => _email = input,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password'
                      ),
                      validator: (input) => input.length < 6
                          ? 'Password must be at least 6 characters long'
                          : null,
                      onSaved: (input) => _password = input,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: () => _add_user(_email,_password),
                      color: Colors.blue,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      color: Colors.blue,
                      child: Text(
                        'Back to Login',
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
