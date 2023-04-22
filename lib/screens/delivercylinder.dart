// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:oru_app/Scanners/scanner_to_deliver.dart';
import 'package:oru_app/reusables.dart';

import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/delivercylinder_manually.dart';
import 'package:oru_app/screens/homepage.dart';

import 'package:http/http.dart' as http;

class DeliverCylinder extends StatefulWidget {
  List cylinderIds;
  List cylinders;
  String accessToken;

  DeliverCylinder(
      {Key? mykey,
      required this.cylinderIds,
      required this.cylinders,
      required this.accessToken})
      : super(key: mykey);

  @override
  State<DeliverCylinder> createState() => _DeliverCylinder();
}

class _DeliverCylinder extends State<DeliverCylinder> {
  String dropDownvalueCustomer = "";

  TextEditingController customerController = TextEditingController();
  List<String> customerNames = [];
  List customerIDs = [];
  int customerId = 0;

  @override
  void initState() {
    super.initState();

    fetchCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 63, 93, 118),
        title: const Text(
          'Deliver Cylinders',
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
        padding: const EdgeInsets.all(20),
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScannerToDeliver(
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
            height: 30,
          ),
          SizedBox(
            height: 60,
          ),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: dropDownvalueCustomer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(width: 1, style: BorderStyle.none),
                  ),
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
              itemCount: widget.cylinderIds.length,
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
                              widget.cylinderIds.removeAt(index);
                              widget.cylinders.removeAt(index);
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
            if (widget.cylinderIds.isEmpty) {
              toast("Scan cylinders");
            } else if (dropDownvalueCustomer == "") {
              toast("Select customer");
            } else {
              setState(() {
                customerId =
                    customerIDs[customerNames.indexOf(dropDownvalueCustomer)];
              });
              _showConfirmationDialog();
            }
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
                  builder: (context) => DeliverMannually(
                        accessToken: widget.accessToken,
                      )),
            );
          })
        ],
      ),
    );
  }

  void makePostRequestToDeliver(String accessToken, int customer) async {
    if (widget.cylinderIds.isNotEmpty) {
      var url = Uri.parse('http://soc-erp.showcase.code7.in/api/deliver');

      var requestBody = jsonEncode({
        "customer": customer,
        "cylinders": widget.cylinderIds,
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
                makePostRequestToDeliver(widget.accessToken, customerId);

                setState(() {
                  widget.cylinderIds.clear();
                  widget.cylinders.clear();
                  dropDownvalueCustomer = "";
                  customerController.clear();
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
