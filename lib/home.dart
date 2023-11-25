import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/list_bookmark.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/menu.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/profile.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/saran.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences logindata;
  late String username;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString("username")!;
    });
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Menu(),
    Profile(),
    Saran(),
    PageBookmarks(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 24,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 24,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb_outline,
              size: 24,
             ),
            label: "Saran",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmarks_outlined,
              size: 24,
            ),
            label: "Bookmark",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
