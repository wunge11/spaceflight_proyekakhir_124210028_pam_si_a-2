import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isHovered = false;
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

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                logindata.setBool("login", true);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil Saya",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: isHovered
                  ? Matrix4.diagonal3Values(1.05, 1.05, 1)
                  : Matrix4.identity(),
              alignment: Alignment.center,
              child: Card(
                elevation: 4.0,
                margin: EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: AssetImage('asset/profil1.png'),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Prita Isworo Wunge',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '124210028',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Pemrograman Aplikasi Mobile SI-A',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Suka membaca fiksi serta menonton video kucing lucu dan gameplay horror',
                          textAlign: TextAlign
                              .center, // Memberikan teks yang lebih rapi di tengah
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Logout",
        child: FloatingActionButton(
          onPressed: () {
            _showLogoutConfirmationDialog();
          },
          backgroundColor: Color(0xFFFFCDD2),
          child: Icon(Icons.logout_outlined),
        ),
      ),
    );
  }
}
