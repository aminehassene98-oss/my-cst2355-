import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login Page'),
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
  // make the controllers to get text from the boxes
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  // get the encrypted helper tool
  EncryptedSharedPreferences myPrefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    // set up the controllers when the app starts
    _loginController = TextEditingController();
    _passwordController = TextEditingController();

    // check if we have any saved data from last time
    checkSavedData();
  }

  // this function looks for saved name and password
  void checkSavedData() {
    myPrefs.getString('user_name').then((String savedName) {
      // if we found a name, put it in the box
      if (savedName.isNotEmpty) {
        setState(() {
          _loginController.text = savedName;
        });

        // now check for the password too
        myPrefs.getString('user_pass').then((String savedPass) {
          if (savedPass.isNotEmpty) {
            setState(() {
              _passwordController.text = savedPass;
            });
          }
        });

        // show the message at the bottom that data was loaded
        // use delayed so the screen has time to build first
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Loaded your saved login info!"))
          );
        });
      }
    });
  }

  @override
  void dispose() {
    // clean up memory when app closes
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // box for the user name
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                  labelText: "Login name",
                  border: OutlineInputBorder()
              ),
            ),

            // adds some space between the boxes
            const SizedBox(height: 20),

            // box for the password
            TextField(
              controller: _passwordController,
              obscureText: true, // hides the text like dots
              decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 20),

            // the login button
            ElevatedButton(
              onPressed: () {
                // show the popup asking to save
                showSaveDialog();
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  // helper to show the alert window
  void showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Login?"),
          content: const Text("Do you want to save your username and password for next time?"),
          actions: [
            // no button clears everything
            TextButton(
              onPressed: () {
                // delete the saved data
                myPrefs.clear();
                // close the window
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            // yes button saves everything
            TextButton(
              onPressed: () {
                // save the text from the boxes to the phone
                myPrefs.setString('user_name', _loginController.text);
                myPrefs.setString('user_pass', _passwordController.text);
                // close the window
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}