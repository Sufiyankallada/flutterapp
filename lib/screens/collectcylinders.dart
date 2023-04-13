import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:oru_app/reusables.dart';
import 'package:oru_app/screens/collectcylinders_mannually.dart';

import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/homepage.dart';

import 'package:http/http.dart' as http;
import 'package:oru_app/Scanners/scanner_to_collect.dart';

String dropDownvalueCustomer = "Select Customer";

class CollectCylinder extends StatefulWidget {
  List qrList;

  String accessToken;

  CollectCylinder({Key? mykey, required this.qrList, required this.accessToken})
      : super(key: mykey);

  @override
  State<CollectCylinder> createState() => _CollectCylinder();
}

class _CollectCylinder extends State<CollectCylinder> {
  List cylinderId = [];
  bool flag = false;
  bool cancel = false;
  List invalidCylinders = [];

  String dropDownvalueCustomer = "Select Customer";

  TextEditingController customerController = TextEditingController();
  List<String> customerNames = [];
  List customerIDs = [];

  @override
  void initState() {
    super.initState();

    fetchCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 73, 183, 202),
        title: const Text(
          'Collect Cylinders',
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
                        builder: (context) => ScannerToCollect(
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
          SizedBox(
            height: 60,
          ),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: dropDownvalueCustomer,
                  border: OutlineInputBorder(),
                  labelText: "Customer",
                ),
                controller: customerController),
            suggestionsCallback: (String pattern) async {
              return customerNames
                  .where((item) =>
                      item.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },
            itemBuilder: (BuildContext context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) {
              setState(() {
                dropDownvalueCustomer = suggestion;
                customerController.text = suggestion;
              });
            },
          ),
          SizedBox(
            height: 65,
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
          SizedBox(
            height: 10,
          ),

          buttons(context, "Submit", () {
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
          }),
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
                  builder: (context) => CollectCylindersMannually(
                        accessToken: widget.accessToken,
                      )),
            );
          }),
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

  void makePostRequestToCollect(
      String accessToken, List cylinderId, int customer) async {
    if (!cylinderId.isEmpty) {
      var url = Uri.parse('http://soc-erp.showcase.code7.in/api/collect');

      var requestBody = jsonEncode({
        "customer": customer,
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
                makePostRequestToCollect(widget.accessToken, cylinderId, 176);

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

  Future<void> fetchCustomerDetails() async {
    const url = 'http://soc-erp.showcase.code7.in/api/customers';
    final token = widget.accessToken;
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (Map i in data['customers']) {
        customerNames.add(i['name']);
        customerIDs.add(i['id']);
      }
    } else {
      // Handle error
    }
  }
}
