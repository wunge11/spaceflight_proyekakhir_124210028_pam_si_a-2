import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final _username = TextEditingController();
  final _password = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;

  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool("login") ?? true);

    if (!newuser) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
    }
  }

  String encryptUsername(String username) {
    // Use MD5 encryption for the username
    var bytes = utf8.encode(username);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  void login() {
    String enteredUsername = _username.text;
    String enteredPassword = _password.text;
    String encryptedUsername = encryptUsername(enteredUsername);
    String encryptedPassword = encryptPassword(enteredPassword);

    // Check if the entered username and password match the hardcoded values
    if (enteredUsername == "wung" && enteredPassword == "1234") {
      // Login successful
      logindata.setBool("login", false);
      logindata.setString("username", enteredUsername);
      print("Encrypted Username: $encryptedUsername");
      print("Encrypted Password: $encryptedPassword");

      // Tampilkan Snackbar login berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blueAccent,
        ),
      );

      // Pindah ke halaman Home
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
    } else {
      // Login failed
      print("Username or password is incorrect");

      // Tampilkan Snackbar login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed! Please check your username and password'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Spaceflight News",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(15.0),
        children: [
          Image.asset(
            "asset/pc.png",
            height: 150, // Sesuaikan dengan tinggi yang diinginkan
            width: 150, // Sesuaikan dengan lebar yang diinginkan
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Login first!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _username,
            decoration: InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _password,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  // Toggle the visibility of the password
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
          ),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              onPressed: login,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
