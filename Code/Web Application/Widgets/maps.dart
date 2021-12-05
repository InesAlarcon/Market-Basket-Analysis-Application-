import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class getMap extends StatefulWidget {
   final num lat;
   final num lng;
   getMap({required this.lat, required this.lng});


  @override
  _getMapState createState() => _getMapState(lat: this.lat, lng: this.lng);
}

class _getMapState extends State<getMap> {
  num lng;
  num lat;
  late LatLng myLatlng;


  _getMapState({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {


    print(lat);
    print(lng);

    String htmlId = Random().nextInt(1000).toString();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (viewId) {


      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = new LatLng(lat,lng);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);


      // Another marker
      Marker(
        MarkerOptions()
          ..position = new LatLng(lat,lng)
          ..map = map,
      );

      return elem;
    });
    return HtmlElementView(viewType: htmlId);
  }
  }

