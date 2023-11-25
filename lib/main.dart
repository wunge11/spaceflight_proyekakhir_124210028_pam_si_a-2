import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/login.dart';
import 'package:spaceflight_proyekakhir_124210028_pam_si_a/models/bookmark_model.dart';

String boxName = "BOOKMARK";

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Bookmark>(BookmarkAdapter());
  await Hive.openBox<Bookmark>(boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Space Flight News',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

