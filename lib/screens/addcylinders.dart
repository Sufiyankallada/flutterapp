import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:http/http.dart' as http;
import 'package:oru_app/Scanners/scanner_to_getQR.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/homepage.dart';
import 'package:oru_app/reusables.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddCylinder extends StatefulWidget {
  String accessToken;

  AddCylinder({Key? mykey, required this.accessToken}) : super(key: mykey);

  @override
  State<AddCylinder> createState() => _AddCylinderState();
}

class _AddCylinderState extends State<AddCylinder> {
  DateTime _selectedDate = DateTime(2000);

  Future<void> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      QR = prefs.getString('QR')!;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TextEditingController cylindernumber = TextEditingController();
  TextEditingController Manufacturer = TextEditingController();
  TextEditingController suppliername = TextEditingController();
  TextEditingController phone = TextEditingController();

  TextEditingController contactName = TextEditingController();
  TextEditingController tare_weight = TextEditingController();
  TextEditingController capacity = TextEditingController();
  TextEditingController datec = TextEditingController();
  TextEditingController cylinderController = TextEditingController();
  TextEditingController QRcode = TextEditingController();
  String dropDownvalueCylinder = "";

  List<String> cylinderTypes = [];
  List cylinderTypeId = [];

  int cylinderTypeID = 0;
  String date = "";
  String QR = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDate = DateTime(2000);
    });
    fetchCylinderDetails();
    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 73, 183, 202),
          title: const Text(
            'Add Cylinder',
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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 90,
              //   margin: EdgeInsets.fromLTRB(60, 0, 60, 60),

              //   //child:Text("sreelu's", style: TextStyle(color: Color.fromARGB(255, 255, 253, 253))),
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('images/logo3.png'),
              //       fit: BoxFit.fill,
              //     ),
              //   ),
              // ),
              Text(
                "  QR code",
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: numberTextFeildWithIcon(
                      QR,
                      false,
                      QRcode,
                      Icons.qr_code,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScannerToGetQr(
                                        accessToken: widget.accessToken)));
                          },
                          icon: Icon(Icons.qr_code)))
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      hintText: dropDownvalueCylinder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(width: 1, style: BorderStyle.none),
                      ),
                      labelText: "Cylinder Type",
                    ),
                    controller: cylinderController),
                suggestionsCallback: (String pattern) async {
                  return cylinderTypes
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
                    dropDownvalueCylinder = suggestion;
                    cylinderController.text = suggestion;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "   Cylinder Number",
                style: TextStyle(fontSize: 16),
              ),
              numberTextFeildWithIcon(
                "Cylinder Number",
                false,
                cylindernumber,
                Icons.arrow_right,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "   Supplier name",
                style: TextStyle(fontSize: 16),
              ),
              reusableTextField2(
                "Supplier name",
                Icons.person,
                suppliername,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "   Manufacturer",
                style: TextStyle(fontSize: 16),
              ),
              reusableTextField2(
                "Manufacturer",
                Icons.precision_manufacturing,
                Manufacturer,
              ),

              const SizedBox(
                height: 30,
              ),
              Text(
                "   Manufacturing date",
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: reusableTextField2(
                      _selectedDate == null
                          ? 'No date selected'
                          : ' ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                      Icons.date_range_rounded,
                      datec,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: IconButton(
                    icon: Icon(Icons.date_range_sharp),
                    onPressed: () => _selectDate(context),
                  ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "   Capacity                               Tare Weight ",
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                      child: numberTextFeild("in liters", false, capacity)),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: numberTextFeild("in Kg", false, tare_weight)),
                ],
              ),

              SizedBox(
                height: 50,
              ),

              signInSignUpButton("submit", context, () {
                if (cylinderController.text == "") {
                  toast("Select cylinder type");
                }

                if (dropDownvalueCylinder != "") {
                  setState(() {
                    if (QRcode.text != "") {
                      QR = QRcode.text;
                    }
                    cylinderTypeID = cylinderTypeId[
                        cylinderTypes.indexOf(dropDownvalueCylinder)];
                  });
                  if (QR == "00000") {
                    toast("Enter QR ID");
                  } else if (cylindernumber.text == "") {
                    toast("Enter Cylinder number");
                  } else if (cylinderController.text == "") {
                    toast("Select cylinder type");
                  } else {
                    _showConfirmationDialog();
                  }
                }
              }),
            ],
          ),
        ));
  }

  Future<void> postRequest(String accessToken) async {
    final url = Uri.parse('http://soc-erp.showcase.code7.in/api/cylinder');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    final body = {
      "number": cylindernumber.text.toString(),
      "type": cylinderTypeID,
      "supplier_name": suppliername.text.toString(),
      "manufacture": Manufacturer.text.toString(),
      "manufacturing-date": date,
      "water-capacity": capacity.text.toString(),
      "tare-weight": tare_weight.text.toString(),
      "qr_codes": [QR]
    };
    final jsonBody = json.encode(body);
    try {
      final response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        // request successful, handle response data
        final responseData = json.decode(response.body);
        toast(responseData['message']);

        // ...
      } else if (response.statusCode == 400) {
        toast("Error adding Customers");
        toast('Request failed with status: ${response.statusCode}.');
      } else if (response.statusCode == 500) {
        final responseData = json.decode(response.body);
        toast(responseData['message']);
      }
    } catch (e) {
      toast("Check internet connectivity");
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
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Proceed'),
              onPressed: () {
                postRequest(widget.accessToken);
                setState(() {
                  QR = "00000";
                });

                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchCylinderDetails() async {
    const url = 'http://soc-erp.showcase.code7.in/api/cylinder-types';
    final token = widget.accessToken;
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (Map i in data['types']) {
        cylinderTypes.add(i['name']);
        cylinderTypeId.add(i['id']);
      }
    } else {
      // Handle error
    }
  }
}
