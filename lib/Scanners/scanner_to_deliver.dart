import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oru_app/functions.dart';
import 'package:oru_app/screens/delivercylinder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:flutter_beep/flutter_beep.dart';
import 'package:http/http.dart' as http;

class ScannerToDeliver extends StatefulWidget {
  List cylinderIDs;
  List cylinders;
  String accessToken;

  ScannerToDeliver(
      {Key? mykey,
      required this.cylinderIDs,
      required this.cylinders,
      required this.accessToken})
      : super(key: mykey);

  @override
  State<ScannerToDeliver> createState() => _ScannerToDeliverState();
}

class _ScannerToDeliverState extends State<ScannerToDeliver> {
  Future<void> getCylinderData(int qrId, String accessToken) async {
    String url = 'http://soc-erp.showcase.code7.in/api/cylinder/qr';
    url += '?qr_id=$qrId';
    final token = widget.accessToken;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          cylinderID = data['cylinder']["id"];
          cylinderNumber = data['cylinder']["number"];
          cylindreType = data['cylinder']["type"];
        });
      } else {
        toast("QR code not valid");
      }
    } catch (e) {
      toast("check internet connectivity");
    }
  }

  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  int cylinderID = 0;
  String cylinderNumber = "";
  String cylindreType = "";

  QRViewController? controller;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget buidResult() => Container(
      padding: const EdgeInsets.all(10),
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 252, 255, 248)),
      child: Column(
        children: [
          Text(
            cylinderNumber,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
            maxLines: 3,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            cylindreType,
            style: TextStyle(fontSize: 20),
            maxLines: 3,
          ),
        ],
      ));

  Widget addButton() => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  try {
                    setState(() {
                      if (widget.cylinderIDs.contains(cylinderID)) {
                        toast(
                            "$cylinderNumber - $cylindreType \n is already added");
                      } else if (cylinderID != 0) {
                        widget.cylinderIDs.add(cylinderID);
                        widget.cylinders.add([cylinderNumber, cylindreType]);

                        toast("added  $cylinderNumber");
                      }
                    });
                  } catch (e) {}
                },
                child: const Text('add'))
          ],
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 20,
          borderWidth: 15,
          borderColor: Colors.blue,
        ),
      );

  /*void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }*/
  Barcode? lastScanned;

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      if (lastScanned?.code != barcode.code) {
        lastScanned = barcode;
        setState(() => this.barcode = barcode);

        //API

        getCylinderData(
            int.parse('${barcode.code}'.substring(4)), widget.accessToken);

        FlutterBeep.playSysSound(41);
        // Fluttertoast.showToast(
        //     msg: "Scanned: ${barcode.code}",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Scan Cylinders to deliver',
              style: TextStyle(color: Colors.black)),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliverCylinder(
                            cylinderIds: widget.cylinderIDs,
                            cylinders: widget.cylinders,
                            accessToken: widget.accessToken,
                          )));
            },
            icon: const Icon(Icons.arrow_back_rounded),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              color: const Color.fromARGB(255, 236, 215, 19),
              icon: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(snapshot.data!
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded);
                    } else {
                      return Container();
                    }
                  }),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
            // IconButton(
            //   color: Colors.black,
            //   icon: FutureBuilder(
            //       future: controller?.getCameraInfo(),
            //       builder: (context, snapshot) {
            //         if (snapshot.data != null) {
            //           return const Icon(Icons.switch_camera_rounded);
            //         } else {
            //           return Container();
            //         }
            //       }),
            //   onPressed: () async {
            //     await controller?.flipCamera();
            //     setState(() {});
            //   },
            // )
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Scaffold(
                  body: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      buildQrView(context),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Scaffold(
                  body: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(bottom: 70, child: buidResult()),
                      Positioned(bottom: 10, child: addButton()),
                    ],
                  ),
                ),
              ),
              Divider(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliverCylinder(
                                  cylinderIds: widget.cylinderIDs,
                                  cylinders: widget.cylinders,
                                  accessToken: widget.accessToken,
                                )));
                  },
                  child: Text("Submit")),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
