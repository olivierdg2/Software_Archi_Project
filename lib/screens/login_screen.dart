import 'package:flutter/material.dart';
import 'package:flutter_app/screens/signup_screen.dart';
import 'package:flutter_app/database/online.dart';
import 'package:flutter_app/database/local.dart';
import 'globals.dart' as globals;
import 'package:sqflite/sqflite.dart';
bool log = globals.isLoggedIn;
int id = globals.log_id;
Future<Database> online = globals.online;
Future<Database> local = globals.local;
class LoginScreen extends StatefulWidget {

  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;


  _submit() async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      List<int> a = await Online.checkMatch(_email, _password, online);
      Local.testCow(local);
      Online.test(online);
      if (a[0] == 1){
        globals.log_id = a[1];
        globals.isLoggedIn = true;
      }
      else if (a[0] == 0){

      }
      else {

      }
    }
    print(globals.log_id.toString());
    print(globals.isLoggedIn);
    setState(() {});
    print("*****************");
    print(globals.log_id.toString());
    print(globals.isLoggedIn);
  }
  _pull() async{

  }
  _push() async{

  }
  _logout(){
    globals.isLoggedIn = false;
    globals.log_id = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (log){
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250.0,
                child: FlatButton(
                  onPressed: _pull,
                  color: Colors.blue,
                  child: Text(
                    'Pull',
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
                  onPressed: _pull,
                  color: Colors.blue,
                  child: Text(
                    'Push',
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
                  onPressed: _logout,
                  color: Colors.blue,
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }
    else{
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a valid user'
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
                        onPressed: _submit,
                        color: Colors.blue,
                        child: Text(
                          'Login',
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
                        onPressed: () => Navigator.pushNamed(context, SignupScreen.id),
                        color: Colors.blue,
                        child: Text(
                          'Sign up',
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
}


