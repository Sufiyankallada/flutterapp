import 'package:flutter/material.dart';
import 'package:oru_app/reusables.dart';

class FillMannually extends StatefulWidget {
  const FillMannually({super.key});

  @override
  State<FillMannually> createState() => _FillMannuallyState();
}

class _FillMannuallyState extends State<FillMannually> {
  TextEditingController cylinderNumber = TextEditingController();
  List<String> cylinderTypes = ["1", "2", "3"];
  List<String> customer = ["1", "2", "3"];
  String dropDownvalueCylinder = "Select Cylinder type";
  String dropDownvalueCustomer = "Select Customer";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Cylinder",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            reusableTextField("Cylinder Number", Icons.format_list_numbered,
                false, cylinderNumber),
            SizedBox(
              height: 30,
            ),
            Text("Cylinder Type"),
            DropdownButton<String>(
              items: cylinderTypes.map((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropDownvalueCylinder = value.toString();
                });
              },
              hint: Text(dropDownvalueCylinder),
              dropdownColor: Color.fromARGB(255, 255, 255, 255),
              style: TextStyle(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Customer"),
            DropdownButton<String>(
              items: cylinderTypes.map((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropDownvalueCustomer = value.toString();
                });
              },
              hint: Text(
                dropDownvalueCustomer,
              ),
              dropdownColor: Color.fromARGB(255, 255, 255, 255),
              style: TextStyle(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
              elevation: 4,
            ),
            const SizedBox(
              height: 30,
            ),
            buttons(context, "Add", () {})
          ],
        ),
      ),
    );
  }
}
