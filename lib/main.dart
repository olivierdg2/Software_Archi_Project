import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home.dart';
import 'package:flutter_app/screens/input.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/signup_screen.dart';
import 'package:flutter_app/screens/globals.dart' as  globals;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: MyStatefulWidget(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        InputScreen.id: (context) => InputScreen(),
      },
    );
  }
}
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

//Contains the corps of the applications -> Nav bar + app bar
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  //Screen options of the nav bar
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    InputScreen(),
    LoginScreen(),
  ];
  //On nav bar tapped select index of selected screen
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Build the corps
  @override
  Widget build(BuildContext context) {
    //Chose which icon to display according to isLoggedIn
    bool log = globals.isLoggedIn;
    var connect_icon = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.cloud_off_outlined),
        Text("Offline")
      ],
    );
    if (log){
      connect_icon = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.cloud_rounded),
          Text("Online")
        ],
      );
    }


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //Moi przyjaciele krowyMy Cow\'orkers
        title: const Text('Moi przyjaciele krowy'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: connect_icon,
          ),
        ]
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_sharp),
            label: 'Add Cow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Synchronize',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
