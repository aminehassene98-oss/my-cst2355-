import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 1. We create "Controllers" to read what the user types in the boxes
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  // 2. This variable tracks which image to show
  var imageSource = "images/question.png";

  @override
  void initState() {
    super.initState();
    // Initialize the controllers when the app starts
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up controllers when the app is closed
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lab 2 Login")),
      body: Column(
        children: [
          // Login Field
          TextField(
            controller: _loginController,
            decoration: InputDecoration(labelText: "Login name"),
          ),

          // Password Field - obscureText hides the characters
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
          ),

          // The Login Button
          ElevatedButton(
            onPressed: () {
              // Get the text from the password box
              String pass = _passwordController.text;

              // Logic: Check if it matches "ASDF"
              setState(() {
                if (pass == "ASDF") {
                  imageSource = "images/light.png";
                } else {
                  imageSource = "images/stop.png";
                }
              });
            },
            child: Text("Login"),
          ),

          // The Image with a description for screen readers
          Semantics(
            label: 'Indicator of login success',
            child: Image.asset(imageSource, width: 300, height: 300),
          ),
        ],
      ),
    );
  }
}