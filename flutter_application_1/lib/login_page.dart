import 'package:flutter/material.dart';
import 'repository.dart';
import 'ProfilePage.dart';

// login page and it receive repository object
class LoginPage extends StatefulWidget {
  // repo contain shared data
  final Repository repo;

  // constructor
  LoginPage(this.repo);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// state class because we need to manage textfield and login logic
class _LoginPageState extends State<LoginPage> {
  // controllers to get text from username and password fields
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  // simple password not secure of course
  final String correctPassword = "1234";

  @override
  Widget build(BuildContext context) {
    // scaffold is the base layout of the page
    return Scaffold(
      // appbar title
      appBar: AppBar(title: Text("Login Page")),
      body: Padding(
        // give spacing around content
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: "Username"),
            ),

            TextField(
              controller: passController,
              decoration: InputDecoration(labelText: "Password"),
              // obscureText true hide password for security
              obscureText: true,
            ),
            // space before button
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // check if password is correct
                if (passController.text == correctPassword) {
                  // save login name inside repository
                  widget.repo.loginName = userController.text;
                  // save data permanently
                  widget.repo.saveData();
                  // navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(widget.repo),
                    ),
                  );
                  // show welcome message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Welcome Back ${userController.text}",
                      ),
                    ),
                  );

                } else {
                  // if password wrong show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Wrong Password")),
                  );
                }
              },
              // button text
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}