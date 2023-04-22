import 'package:flutter/material.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/reusables.dart';
import 'package:oru_app/screens/addcylinders.dart';
import 'package:oru_app/screens/collectcylinders.dart';
import 'package:oru_app/screens/delivercylinder.dart';

import 'package:oru_app/screens/fillcylinders.dart';

import 'package:oru_app/screens/loginpage.dart';

import '../drawer1.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'addcustomer.dart';

class HomePage extends StatefulWidget {
  String access_token;
  HomePage({Key? mykey, required this.access_token}) : super(key: mykey);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
    });
  }

  String? name = "";
  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

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
          // flexibleSpace: Container(
          //   height: 50,
          //   width: 50,
          //   margin: EdgeInsets.fromLTRB(48, 35, 227, 0),
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('images/socerp.png'),
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          title: Text("GROWLINE"),
          backgroundColor: Color.fromARGB(255, 63, 93, 118),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.9,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(name!,
                    style: TextStyle(
                        color: Colors.white,
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
        body: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
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
                                      cylinderIds: [],
                                      cylinders: [],
                                      accessToken: widget.access_token,
                                    )));
                      }),
                      GB("Deliver Cylinders", Icons.delivery_dining, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliverCylinder(
                                    cylinderIds: [],
                                    cylinders: [],
                                    accessToken: widget.access_token)));
                      }),
                      GB("Manual", Icons.account_balance_wallet_rounded, () {}),
                      GB("Collect", Icons.local_shipping, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CollectCylinder(
                                    cylinderIds: [],
                                    cylinders: [],
                                    accessToken: widget.access_token)));
                      }),
                      (name == "Growline")
                          ? GB("Add Customer", Icons.person, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addcustomer(
                                          accessToken: widget.access_token)));
                            })
                          : Text(""),
                      (name == "Growline")
                          ? GB("Add New Cylinder", Icons.add, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCylinder(
                                          accessToken: widget.access_token)));
                            })
                          : Text(""),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
