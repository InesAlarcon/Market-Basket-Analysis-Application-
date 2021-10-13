// @dart=2.9

import 'dart:async';

import 'package:cliente/src/main/calificar/calificarCompra.dart';
import 'package:cliente/src/main/gustos/verGustos.dart';
import 'package:cliente/src/main/gustos/gustosMenu.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/gustos.dart';

class RatingSub extends StatefulWidget{



  @override
  RatingSubState createState() => RatingSubState();
}

class RatingSubState extends State<RatingSub>{

  Completer<GoogleMapController> controllerGmaps = Completer();

  void onMapCreated(GoogleMapController controller) {
    controllerGmaps.complete(controller);
  }

  static const initialCameraPos = CameraPosition(
    target: LatLng(14.650971808857525, -90.54174756616695),
    zoom: 14,
  );

  Widget background(){
    return Container(
      // height: MediaQuery.of(context).size.height,
      // height: ,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff464646), Color(0xff7c7c7c)]),
        image: DecorationImage(
          image: AssetImage("assets/images/background2.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){



    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // title: Text(
        //      "search",
        //       style: TextStyle(color: Colors.white),
        //       ),
        backgroundColor: Color(0xff108aa6),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: initialCameraPos,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),

      );

  }



}