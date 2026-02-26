import 'package:flutter/material.dart';
import 'repository.dart';
import 'login_page.dart';

void main() async {
  // this is required because we use async before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // create repository object
  Repository repo = Repository();
  // loads saved data when app start
  // so user info is not lost
  await repo.loadData();

  // start the app and pass repository
  runApp(MyApp(repo));
}

class MyApp extends StatelessWidget {
  // receive repository
  final Repository repo;

  MyApp(this.repo);

  @override
  Widget build(BuildContext context) {
    // materialapp is root of flutter app
    return MaterialApp(
      title: "Week5 Lab",
      home: LoginPage(repo),
    );
  }
}