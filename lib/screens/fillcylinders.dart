import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oru_app/reusables.dart';
import 'package:oru_app/screens/fillcylinder_mannually.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/homepage.dart';
import 'package:oru_app/Scanners/scanner_to_fill.dart';
import 'package:http/http.dart' as http;

class FillCylinders extends StatefulWidget {
  List qrList;

  String accessToken;

  FillCylinders({Key? mykey, required this.qrList, required this.accessToken})
      : super(key: mykey);

  @override
  State<FillCylinders> createState() => _FillCylindersState();
}

class _FillCylindersState extends State<FillCylinders> {
  List cylinderId = [];
  bool flag = false;
  bool cancel = false;
  List invalidCylinders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 73, 183, 202),
        title: const Text(
          'Fill Cylinders',
          style: TextStyle(
              color: Colors.black,
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
        padding: const EdgeInsets.all(20),
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scanner(
                              accessToken: widget.accessToken,
                              qrList: widget.qrList,
                            )));
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 50,
              ),
              alignment: Alignment.topCenter),

          const SizedBox(
            height: 30,
          ),

          // Text("${widget.qrList[0]}")
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.qrList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(widget.qrList[index]),
                        subtitle: Text((index + 1).toString()),
                        tileColor: Colors.white70,
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (invalidCylinders
                                  .contains(widget.qrList[index])) {
                                invalidCylinders.remove(widget.qrList[index]);
                              }
                              widget.qrList.removeAt(index);
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
              backgroundColor: Color.fromARGB(255, 63, 93, 118),
              minimumSize: Size(80, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // Set the radius to create a rounded button
              ),
            ),
            onPressed: () {
              update();
              if (flag) {
                toast("some QR codes are not valid");
              }
              flag = false;

              if (widget.qrList.isEmpty) {
                setState(() {
                  cancel = false;
                });
              }
              if (widget.qrList.isNotEmpty) _showConfirmationDialog();
            },
            child: const Text(
              "Submit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(thickness: 1),

          SizedBox(
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

  void update() {
    for (int i = 0; i < widget.qrList.length; i++) {
      fetchCylinderByQr(widget.qrList[i]);
    }
    setState(() {
      cancel = true;
    });
  }

  Future fetchCylinderByQr(String qrId) async {
    String url = 'http://soc-erp.showcase.code7.in/api/cylinder/qr';
    url += '?qr_id=$qrId';
    final token = widget.accessToken;
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (!cylinderId.contains(data["cylinder"]["id"])) {
        setState(() {
          cylinderId.add(data["cylinder"]["id"]);
        });
      }
    } else {
      if (!invalidCylinders.contains(qrId)) {
        setState(() {
          invalidCylinders.add(qrId);
        });
      }
      flag = true;
    }
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
        setState(() {
          cancel = false;
        });
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
                setState(() {
                  cylinderId.clear();
                });

                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () {
                if (flag) {
                  toast("some QR codes are not valid");
                }
                makePostRequestToFill(widget.accessToken, cylinderId, 40);

                flag = false;
                cylinderId.clear();
                if (widget.qrList.isEmpty) {
                  setState(() {
                    cancel = false;
                  });
                }
                setState(() {
                  widget.qrList.clear();
                  widget.qrList.addAll(invalidCylinders);
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
