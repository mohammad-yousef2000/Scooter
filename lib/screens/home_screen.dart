// ignore_for_file: unnecessary_new, prefer_final_fields, prefer_const_constructors, import_of_legacy_library_into_null_safe, unnecessary_this, duplicate_ignore, constant_identifier_names, non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../read data/Cards.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screens/es_screen.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

const double PIN_VISIBLE_POS = 20;
const double PIN_INV_POS = -220;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();

  DatabaseReference _SLocation = FirebaseDatabase.instance.ref('Scooter 01');
  //late StreamSubscription _DStream;

  Future<Uint8List> getbytesfromassets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  late double latitude;
  late double longitude;

  void mf() {
    _SLocation.child('LatT').onValue.listen((event) {
      setState(() {
        latitude = event.snapshot.value as double;
      });
    });
  }

  void mf1() {
    _SLocation.child('LonT').onValue.listen((event) {
      setState(() {
        longitude = event.snapshot.value as double;
      });
    });
  }

  @override
  void initState() {
    mf();
    mf1();
    super.initState();
  }

  double pinPillPosition = PIN_INV_POS;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  void esPAge() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const esPage()));
  }

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(30.5852, 36.2384), zoom: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                markers: markers,
                mapToolbarEnabled: false,
                initialCameraPosition: initialCameraPosition,
                zoomControlsEnabled: false,
                onTap: (LatLng loc) {
                  setState(() {
                    this.pinPillPosition = PIN_INV_POS;
                  });
                },
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: pinPillPosition,
              child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    children: [
                      Container(
                          color: Colors.grey.shade900,
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  ClipOval(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.greenAccent),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.deepPurple.shade400)),
                                      onPressed: (() => showDialog(
                                          context: context,
                                          builder: ((context) => AlertDialog(
                                                title: Text("Payment "),
                                                actions: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            16),
                                                        CardNumberInputFormatter(),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Card number ",
                                                        prefixIcon: Icon(
                                                            Icons.credit_card),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  "Full name",
                                                              prefixIcon: Icon(
                                                                  Icons
                                                                      .person)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            LengthLimitingTextInputFormatter(
                                                                3),
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "CVV",
                                                                  prefixIcon:
                                                                      Icon(Icons
                                                                          .password)),
                                                        )),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child:
                                                                TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            LengthLimitingTextInputFormatter(
                                                                4),
                                                            CardMonthInputFormatter()
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "MM/YY",
                                                                  prefixIcon:
                                                                      Icon(Icons
                                                                          .calendar_month)),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      TextButton(
                                                          onPressed: (() =>
                                                              Navigator.pop(
                                                                  context)),
                                                          child:
                                                              Text('Cancel')),
                                                      SizedBox(
                                                        width: 160,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const esPage()));
                                                          },
                                                          child: Text('ok')),
                                                    ],
                                                  ),
                                                ],
                                                content: Text(
                                                    "Please note that renting a scooter will cost you 1\$ and for every minute 0.20\$ "),
                                              )))),
                                      child: const Text("Reserve"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: const [
                                  Text(
                                    'Scooter 01',
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              )
                            ],
                          ))
                    ],
                  )),
            ),
          ],
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(left: 30, bottom: 590),
            child: Row(children: [
              FloatingActionButton(
                backgroundColor: Colors.deepPurple.shade400,
                onPressed: () async {},
                mini: true,
                child: Icon(
                  Icons.qr_code_scanner,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(child: Container()),
              FloatingActionButton(
                backgroundColor: Colors.deepPurple.shade400,
                mini: true,
                onPressed: () async {
                  setState(() {
                    _currentLocation();
                  });
                  showPinsOnMap();
                },
                child: Icon(
                  Icons.my_location,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ])));
  }

  void showPinsOnMap() async {
    final Uint8List marker = await getbytesfromassets('assets/es4.png', 100);
    setState(() {
      markers.add(Marker(
        markerId: MarkerId("plz"),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.fromBytes(marker),
        onTap: () {
          setState(() {
            pinPillPosition = PIN_VISIBLE_POS;
          });
        },
      ));
    });
  }
}
