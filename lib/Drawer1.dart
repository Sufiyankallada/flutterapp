import 'package:flutter/material.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/loginpage.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 142, 235, 139),
          ),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title: const Text('About'),
          trailing: Icon(Icons.info),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Settings'),
          trailing: Icon(Icons.settings),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Logout'),
          trailing: Icon(Icons.logout),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            toast("Successfully logged out");
          },
        ),
      ],
    ),
  );
}
