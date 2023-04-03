import 'package:flutter/material.dart';
import "package:oru_app/fillcylinders.dart";
import 'package:oru_app/reusables.dart';
import 'package:oru_app/Drawer1.dart';

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
        backgroundColor: Color.fromARGB(255, 170, 229, 238),
        appBar: AppBar(
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
                  Navigator.pop(context);
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
                    GridButton(
                        color: Colors.green[100]!,
                        icon: Icons.add_circle_outline,
                        label: "Fill Cylinders",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FillCylinders(
                                        qrList: [],
                                        accessToken: widget.access_token,
                                      )));
                        }),
                    GridButton(
                        color: Colors.blue[100]!,
                        icon: Icons.delivery_dining,
                        label: "Deliver Cylinders",
                        onPressed: () {}),
                    GridButton(
                        color: Colors.pink[100]!,
                        icon: Icons.directions_bike,
                        label: "Pickup",
                        onPressed: () {}),
                    GridButton(
                        color: Colors.orange[100]!,
                        icon: Icons.local_shipping,
                        label: "Unloading",
                        onPressed: () {}),
                    GridButton(
                        color: Colors.purple[100]!,
                        icon: Icons.person,
                        label: "Manual",
                        onPressed: () {}),
                    GridButton(
                        color: Colors.teal[100]!,
                        icon: Icons.add,
                        label: "Add New Cylinder",
                        onPressed: () {}),
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
            title: const Text("Really"),
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
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          );
        });
    return exitApp != null ? exitApp : false;
    //return exitApp ?? false;
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
