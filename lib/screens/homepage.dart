import 'package:flutter/material.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/reusables.dart';
import 'package:oru_app/screens/collectcylinders.dart';
import 'package:oru_app/screens/delivercylinder.dart';

import 'package:oru_app/screens/fillcylinders.dart';

import 'package:oru_app/screens/loginpage.dart';

import '../drawer1.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  String access_token;
  HomePage({Key? mykey, required this.access_token}) : super(key: mykey);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    //change item hieght to change the hieght of grid
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.2;
    final double itemWidth = size.width / 2;
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.9,
          backgroundColor: Color.fromARGB(255, 73, 183, 202),
          title: const Text('Day Scholars',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Data Entry',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
            IconButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.redAccent,
                )),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    GB("Fill Cylinders", Icons.add_circle_outline, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FillCylinders(
                                    qrList: [],
                                    accessToken: widget.access_token,
                                  )));
                    }),
                    GB("Deliver Cylinders", Icons.delivery_dining, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliverCylinder(
                                  qrList: [],
                                  accessToken: widget.access_token)));
                    }),
                    GB("Pickup", Icons.directions_bike, () {}),
                    GB("Collect", Icons.local_shipping, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CollectCylinder(
                                    accessToken: widget.access_token,
                                    qrList: [],
                                  )));
                    }),
                    GB("Manual", Icons.person, () {}),
                    GB("Add New Cylinder", Icons.add, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FillCylinders(
                                  qrList: [],
                                  accessToken: widget.access_token)));
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: buildDrawer(context),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  logout(widget.access_token);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text("Yes"),
              ),
            ],
          );
        });
    return exitApp != null ? exitApp : false;
    //return exitApp ?? false;
  }

  Future<void> logout(String accessToken) async {
    final url = Uri.parse('http://soc-erp.showcase.code7.in/api/logout');
    final headers = {'Authorization': 'Bearer $accessToken'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      toast("Successfully logged out");
      print('Logout successful');
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'];
      throw Exception('Failed to logout: $errorMessage');
    }
  }
}

class GridButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const GridButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
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
