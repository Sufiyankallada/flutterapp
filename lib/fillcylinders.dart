import 'package:flutter/material.dart';
import 'package:oru_app/scanner.dart';

class FillCylinders extends StatefulWidget {
  List qrList;

  FillCylinders({Key? mykey, required this.qrList}) : super(key: mykey);

  @override
  State<FillCylinders> createState() => _FillCylindersState();
}

class _FillCylindersState extends State<FillCylinders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Scanner()));
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 50,
              ),
              alignment: Alignment.topCenter),

          SizedBox(
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
                    ListTile(
                      title: Text(widget.qrList[index]),
                      subtitle: Text((index + 1).toString()),
                      tileColor: Colors.grey[350],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              }),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.qrList.clear();
              });
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
