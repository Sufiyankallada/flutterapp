import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/homepage.dart';
import 'package:oru_app/reusables.dart';

class Addcustomer extends StatefulWidget {
  String accessToken;

  Addcustomer({Key? mykey, required this.accessToken}) : super(key: mykey);

  @override
  State<Addcustomer> createState() => _AddcustomerState();
}

class _AddcustomerState extends State<Addcustomer> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController contactName = TextEditingController();
  TextEditingController contactMobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 73, 183, 202),
          title: const Text(
            'Add Customers',
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
          padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: Column(
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
              reusableTextField2(
                "Name",
                Icons.person,
                name,
              ),
              const SizedBox(
                height: 30,
              ),
              reusableTextField2(
                "Address",
                Icons.house_outlined,
                address,
              ),
              const SizedBox(
                height: 30,
              ),
              numberTextFeildWithIcon(
                "Phone",
                false,
                phone,
                Icons.phone,
              ),
              const SizedBox(
                height: 30,
              ),
              reusableTextField2(
                "Email",
                Icons.email_outlined,
                email,
              ),
              const SizedBox(
                height: 30,
              ),
              reusableTextField2(
                "gst",
                Icons.store_mall_directory,
                gst,
              ),
              const SizedBox(
                height: 30,
              ),
              reusableTextField2(
                "Contact-name",
                Icons.person,
                contactName,
              ),
              const SizedBox(
                height: 30,
              ),
              numberTextFeildWithIcon(
                "contact-mobile",
                false,
                contactMobile,
                Icons.phone_android_outlined,
              ),
              const SizedBox(
                height: 30,
              ),

              signInSignUpButton("submit", context, () {
                _showConfirmationDialog();
              }),
            ],
          ),
        ));
  }

  Future<void> postRequest(String accessToken) async {
    final url = Uri.parse('http://soc-erp.showcase.code7.in/api/customers');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    final body = {
      "name": name.text.toString(),
      "address": address.text.toString(),
      "phone": phone.text.toString(),
      'email': email.text.toString(),
      "gst": gst.text.toString(),
      "contact_name": contactName.text.toString(),
      "contact_mobile": contactMobile.text.toString()
    };
    final jsonBody = json.encode(body);
    try {
      final response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        toast("Customer added Successfully");

        // request successful, handle response data
        final responseData = json.decode(response.body);
        print(responseData['message']);
        Navigator.of(context).pop();
        // ...
      } else if (response.statusCode == 400) {
        toast("Error adding Customers");
        print('Request failed with status: ${response.statusCode}.');
      } else {
        toast("Enter valid email id");
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

                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
