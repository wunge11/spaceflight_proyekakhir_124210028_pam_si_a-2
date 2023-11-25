import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/list_blogs.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/list_news.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/list_reports.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'supportUs.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late SharedPreferences logindata;
  late String username;
  late String jakartaTimeZoneId = 'Asia/Jakarta';

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString("username")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomAppBar(username: username, jakartaTimeZoneId: jakartaTimeZoneId),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    MenuItem(
                      title: 'News',
                      subtitle: 'Latest news updates',
                      imageUrl:
                      'https://spaceflightnewsapi.net/img/features/News.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PageListNews()),
                        );
                        print('Tapped on News');
                      },
                    ),
                    MenuItem(
                      title: 'Blogs',
                      subtitle: 'Read interesting blogs',
                      imageUrl:
                      'https://spaceflightnewsapi.net/img/features/Blogs.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PageListBlogs()),
                        );
                        print('Tapped on Blogs');
                      },
                    ),
                    MenuItem(
                      title: 'Reports',
                      subtitle: 'Explore detailed reports',
                      imageUrl:
                      'https://spaceflightnewsapi.net/img/features/Reports.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PageListReports()),
                        );
                        print('Tapped on Reports');
                      },
                    ),
                    MenuItem(
                      title: 'Support Us',
                      subtitle: 'Contribute and support',
                      imageUrl:
                      'https://spaceflightnewsapi.net/img/features/LL2.svg',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SupportUsPage(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                imageUrl,
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
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

class CustomAppBar extends StatefulWidget {
  final String username;
  final String jakartaTimeZoneId;

  const CustomAppBar({
    Key? key,
    required this.username,
    required this.jakartaTimeZoneId,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late tz.Location jakarta;
  late DateTime currentTime;
  String selectedTimeZone = 'WIB';

  @override
  void initState() {
    super.initState();
    initializeTimezone();
    updateTime();
  }

  void initializeTimezone() {
    jakarta = tz.getLocation(widget.jakartaTimeZoneId);
  }

  void updateTime() {
    final now = tz.TZDateTime.now(jakarta);

    switch (selectedTimeZone) {
      case 'WIB':
        currentTime = now;
        break;
      case 'WIT':
        currentTime = now.add(Duration(hours: 2));
        break;
      case 'WITA':
        currentTime = now.add(Duration(hours: 1));
        break;
      case 'London':
        currentTime = now.subtract(Duration(hours: 7));
        break;
      case 'New York':
        currentTime = now.subtract(Duration(hours: 12));
        break;
      case 'Japan':
        currentTime = now.add(Duration(hours: 2));
        break;
      case 'Hong Kong':
        currentTime = now.add(Duration(hours: 1));
        break;
      case 'Paris':
        currentTime = now.subtract(Duration(hours: 6));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
      height: 120,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0xff6f8ef2),
            Color(0xff3d4ef8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey, ${widget.username}!",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${DateFormat('HH:mm').format(currentTime)}',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedTimeZone,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeZone = newValue!;
                        updateTime();
                      });
                    },
                    items: [
                      'WIB', 'WIT', 'WITA', 'London', 'New York', 'Japan', 'Hong Kong','Paris'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                          style: TextStyle(
                            color: const Color(0xFFA4B1F5),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold, // Ganti warna teks menjadi putih
                          ),),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
