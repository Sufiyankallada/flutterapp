import 'package:flutter/material.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/loginpage.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Color.fromARGB(255, 206, 221, 234),
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage('images/socerp.png'), opacity: 100),
            color: Color.fromARGB(255, 89, 121, 147),
          ),
          child: Text(
            'GROWLINE',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        Card(
          elevation: 0.5,
          child: ListTile(
            tileColor: Colors.blue[50]!,
            title: const Text('About'),
            trailing: Icon(Icons.info),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ),
        Card(
          elevation: 0.5,
          child: ListTile(
            tileColor: Colors.blue[50]!,
            title: const Text('Settings'),
            trailing: Icon(Icons.settings),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ),
        Card(
          elevation: 0.5,
          child: ListTile(
            tileColor: Colors.blue[50]!,
            title: const Text('Logout'),
            trailing: Icon(Icons.logout),
            onTap: () {
              _showConfirmationDialog(context);
            },
          ),
        ),
      ],
    ),
  );
}

Future<void> _showConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure ?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Proceed'),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
              toast("Successfully logged out");
            },
          ),
        ],
      );
    },
  );
}
