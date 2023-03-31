import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:oru_app/functions.dart';
import 'package:oru_app/homepage.dart';
import 'package:oru_app/reusables.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 88, 185),
      appBar: AppBar(
        title: const Text("sreelu's",
            style: TextStyle(color: Color.fromARGB(255, 255, 253, 253))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 200, 10, 0),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.only(top: 70),

              //child:Text("sreelu's", style: TextStyle(color: Color.fromARGB(255, 255, 253, 253))),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('images/oxygen_cylinder_fill.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            reusableTextField(
              "Email",
              Icons.person,
              false,
              email,
            ),
            const SizedBox(
              height: 30,
            ),
            reusableTextField(
              "Password",
              Icons.lock_outline,
              true,
              password,
            ),
            const SizedBox(
              height: 30,
            ),
            signInSignUpButton("login", context, () {
              postRequest();
            }),
          ],
        ),
      ),
    );
  }

  Future<void> postRequest() async {
    final url = Uri.parse('http://soc-erp.showcase.code7.in/api/authenticate');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'email': email.text.toString(),
      'password': password.text.toString()
    };
    final jsonBody = json.encode(body);
    try {
      final response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        toast("Logined Successfully");

        // request successful, handle response data
        final responseData = json.decode(response.body);
        print(responseData['message']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      access_token: responseData["token"],
                    )));
        // ...
      } else if (response.statusCode == 400) {
        toast("Username and Password doesn't match");
        print('Request failed with status: ${response.statusCode}.');
      } else {
        toast("Enter valid email id");
      }
    } catch (e) {
      toast("Check internet connectivity");
    }
  }
}
