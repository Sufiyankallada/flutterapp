// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oru_app/reusables.dart';
import 'package:oru_app/screens/fillcylinder_mannually.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/homepage.dart';
import 'package:oru_app/Scanners/scanner_to_fill.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class FillCylinders extends StatefulWidget {
  List cylinderIds;
  List cylinders;
  String accessToken;

  FillCylinders(
      {Key? mykey,
      required this.cylinderIds,
      required this.accessToken,
      required this.cylinders})
      : super(key: mykey);

  @override
  State<FillCylinders> createState() => _FillCylindersState();
}

class _FillCylindersState extends State<FillCylinders> {
  TextEditingController purity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 63, 93, 118),
        title: const Text(
          'Fill Cylinders',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(access_token: widget.accessToken)));
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scanner(
                              accessToken: widget.accessToken,
                              cylinderIDs: widget.cylinderIds,
                              cylinders: widget.cylinders,
                            )));
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 50,
              ),
              alignment: Alignment.topCenter),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "   Purity",
            style: TextStyle(fontSize: 17),
          ),
          numberTextFeild("0 to 100", true, purity),

          const SizedBox(
            height: 30,
          ),

          // Text("${widget.qrList[0]}")
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.cylinders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(widget.cylinders[index][0]),
                        subtitle: Text(widget.cylinders[index][1]),
                        tileColor: Colors.white70,
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.cylinders.removeAt(index);
                              widget.cylinderIds.removeAt(index);
                            });
                          },
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red[700],
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 63, 93, 118),
              minimumSize: const Size(80, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // Set the radius to create a rounded button
              ),
            ),
            onPressed: () {
              if (widget.cylinders.isEmpty) {
                toast("Scan QR code");
              } else {
                if (purity.text == "") {
                  toast("Enter purity");
                } else {
                  _showConfirmationDialog();
                }
              }
            },
            child: const Text(
              "Submit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(thickness: 1),

          const SizedBox(
            height: 10,
          ),
          buttons(context, "Manual Entries", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FillMannually(
                        accessToken: widget.accessToken,
                      )),
            );
          })
        ],
      ),
    );
  }

  void makePostRequestToFill(
      String accessToken, List cylinderId, int purity) async {
    if (cylinderId.isNotEmpty) {
      var url = Uri.parse('http://soc-erp.showcase.code7.in/api/fill');

      var requestBody = jsonEncode({
        "purity": purity,
        "cylinders": cylinderId,
        "manual-cylinders": [],
        "remarks": "string"
      });

      var response = await http.post(url, body: requestBody, headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      });

      if (response.statusCode != 200) {
        toast("Error");
      } else {
        toast("submitted");
      }
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to submit?'),
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
                makePostRequestToFill(widget.accessToken, widget.cylinderIds,
                    int.parse(purity.text));
                purity.clear();

                setState(() {
                  widget.cylinders.clear();
                  widget.cylinderIds.clear();
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(''),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
