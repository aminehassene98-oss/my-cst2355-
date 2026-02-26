import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'repository.dart';


// this is the profile page and it receive the repository object
class ProfilePage extends StatefulWidget {
  // repo contain all user information
  final Repository repo;

  // constructor to pass repo
  ProfilePage(this.repo);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// this is the state of the profile page because we need to update data
class _ProfilePageState extends State<ProfilePage> {

  // controllers are used to control textfield values
  late TextEditingController firstController;
  late TextEditingController lastController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    // this loads values from repository into the controllers
    // so when page open it already show saved data
    firstController = TextEditingController(text: widget.repo.firstName);
    lastController = TextEditingController(text: widget.repo.lastName);
    phoneController = TextEditingController(text: widget.repo.phone);
    emailController = TextEditingController(text: widget.repo.email);

    // this adds listener so everytime user type something it auto save
    // so no need for save button
    firstController.addListener(saveData);
    lastController.addListener(saveData);
    phoneController.addListener(saveData);
    emailController.addListener(saveData);
  }

  // saves all data inside repository
  // everytime text change this get called
  void saveData() {
    widget.repo.firstName = firstController.text;
    widget.repo.lastName = lastController.text;
    widget.repo.phone = phoneController.text;
    widget.repo.email = emailController.text;

    // call saveData from repository to store permanently
    widget.repo.saveData();
  }

  // this function open phone sms or email using url launcher
  Future<void> launchURL(String url) async {
    // convert string to uri
    Uri uri = Uri.parse(url);

    // check if device can open it
    if (await canLaunchUrl(uri)) {
      // if yes launch it
      await launchUrl(uri);
    } else {
      // if not supported show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("this url not supported on this device"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // scaffold is main structure of page
    return Scaffold(
      appBar: AppBar(
        // here i show welcome message with login name
        title: Text("Welcome Back ${widget.repo.loginName}"),
      ),
      body: Padding(
        // give space around content
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: firstController,
              decoration: InputDecoration(labelText: "First Name"),
            ),

            TextField(
              controller: lastController,
              decoration: InputDecoration(labelText: "Last Name"),
            ),

            Row(
              children: [
                // flexible so textfield take available space
                Flexible(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone Number"),
                  ),
                ),

                SizedBox(width: 5),
                // button to call number
                ElevatedButton(
                  onPressed: () {
                    // tel: allow phone call for phone call
                    launchURL("tel:${phoneController.text}");
                  },
                  child: Icon(Icons.phone),
                ),

                SizedBox(width: 5),
                // button to send sms to send mesg
                ElevatedButton(
                  onPressed: () {
                    launchURL("sms:${phoneController.text}");
                  },
                  child: Icon(Icons.message),
                ),
              ],
            ),
            // row for email and button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                ),
                SizedBox(width: 5),
                // button to send email
                ElevatedButton(
                  onPressed: () {
                    // mailto: open email app
                    launchURL("mailto:${emailController.text}");
                  },
                  child: Icon(Icons.mail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}