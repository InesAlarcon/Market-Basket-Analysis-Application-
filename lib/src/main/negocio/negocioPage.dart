// @dart=2.9
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cliente/src/main/mainMenu.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../usuario.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class NegocioPage extends StatefulWidget {
  NegocioPage({this.pageid});

  final String pageid;
  // final String userid;
  // final String pagetitle;



  @override
  NegocioPageState createState() => new NegocioPageState();
}

class NegocioPageState extends State<NegocioPage> {

  Set<Marker> markersMap = HashSet<Marker>();

  var data;
  var datauser;




  Icon subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  changeIconSub(){
    subscribeIcon = new Icon(Icons.check_rounded, color: Colors.green,);
  }
  changeIconUnSub(){
    subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  }

  GoogleMapController mapControl;
  Completer<GoogleMapController> controllerGmaps = Completer();

  void onMapCreated(GoogleMapController controller) {
    controllerGmaps.complete(controller);
    // setState(() {
    //   markersMap.add(
    //       Marker(
    //         markerId: MarkerId("0"),
    //         position: LatLng(data["lat"],data["lng"]),
    //         infoWindow: InfoWindow(
    //           title: data["nombre"],
    //
    //         ),
    //   )
    //   );
    // }
    // );

  }
  //
  // static const initialCameraPos = CameraPosition(
  //     target: LatLng(inlat, inlng),
  //     zoom: 14,
  // );
  //
  
  String pageid;
  String userid;
  var pageData = [];

  @override
  void initState(){
    super.initState();
    pageid = widget.pageid;
    // userid = widget.userid;

    print(pageid);
    // print(userid);


  }

  initPage(){
    SearchService().searchByID(pageid).then((QuerySnapshot docs){
      pageData = docs.docs.map((e) => {
        "id": e.id,
        "nombre": e.get("nombre"),
        "defaultRating": e.get("defaultRating"),
        "voteCount": e.get("voteCount"),
      }).toList();
      print(pageData);
    });
  }


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

  // Widget scaffBuild(context, DocumentSnapshot snapshot){
  //
  //
  //   new Scaffold(
  //     body: CustomScrollView(
  //       slivers: [
  //         SliverAppBar(
  //           flexibleSpace: FlexibleSpaceBar(
  //             title: Text(
  //                 snapshot.get("nombre")
  //             ),
  //
  //           ),
  //         ),
  //         SliverList(delegate: SliverChildListDelegate([
  //           Column(
  //             children: <Widget>[
  //               background()
  //             ],
  //           ),
  //
  //         ]
  //         ))
  //       ],
  //     ),
  //   );
  // }


  // void createMarkers(){
  //   StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.
  //     instanceFor(app: Firebase.app('businessApp')).collection('empresa').
  //     doc(pageid).collection("sucursales").snapshots(),
  //     builder: (context,snapshotStores){
  //       var stores = snapshotStores.data;
  //
  //       for(int i = 0; i<stores.size; i++){
  //        return Marker(
  //          markerId: MarkerId("${i}"),
  //
  //        );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    bool selected = true;
    final user = Provider.of<Usuario>(context);

    DocumentSnapshot snapshotDoc;
    initPage();


    return new Scaffold(
      body: StreamBuilder<DocumentSnapshot>(

        stream: FirebaseFirestore.
        instanceFor(app: Firebase.app('businessApp')).collection('empresa').
        doc(pageid).snapshots(),

        builder: (context,snapshot) {

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.
            instanceFor(app: Firebase.app('businessApp')).collection('ofertas').
            doc(pageid).snapshots(),

            builder: (context, snapshot1) {

              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.
                  instanceFor(app: Firebase.app('businessApp')).collection(
                      'empresa').
                  doc(pageid).collection("sucursales").snapshots(),
                  builder: (context, snapshotStores) {

                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('usuario')
                            .doc(user.uid).collection("suscripciones")
                            .snapshots(),
                        builder: (context, snapshot2) {

                          var stores = snapshotStores.data;
                          String sucursalNombre = "";


                          data = snapshot.data;
                          bool issub = false;
                          bool ct = false;
                          double inlat = 0.0;
                          double inlng = 0.0;
                          int vc = 0;
                          int idx = 0;

                          String telefono = "";

                          String imageID = "https://drive.google.com/file/d/1wNjSyvKN3EgOOmNHRpX6n6M-VYj9pVdg/view?usp=sharing";
                          RegExp exp = new RegExp(
                              r"(https://drive.google.com/file/d/)|(/view\?usp=sharing)");


                          var latb = snapshotStores.data.toString().contains(
                              "latitud");
                          var lngb = snapshot.data.toString().contains(
                              "longitud");
                          var ctb = snapshot.data.data().toString().contains(
                              "companyTitle");
                          var vcb = snapshot.data.data().toString().contains(
                              "voteCount");
                          var imageb = snapshot.data.data().toString().contains(
                              "imageUrl");

                          if (latb) {
                            print("ok lat");
                          } else if (!latb) {
                            inlat = 14.6349;
                          }

                          if (lngb) {
                            print("ok ct");
                          } else if (!lngb) {
                            inlng = -90.5069;
                          }

                          for(int i = 0; i<stores.size; i++){
                            print(stores.docs[i]["nombre"]);
                            sucursalNombre = stores.docs[i]["nombre"].toString();
                            inlat = stores.docs[i]["latitud"]+0.0;
                            inlng = stores.docs[i]["longitud"]+0.0;

                            markersMap.add( Marker(
                              markerId: MarkerId("${i}"),
                              position: LatLng(inlat,inlng),
                              infoWindow: InfoWindow(title: sucursalNombre,),
                              onTap: (){
                                setState(() {
                                  telefono = stores.docs[i]["telefono"];
                                });

                              }
                            ));
                          }



                          if (ctb) {
                            ct = data["companyTitle"];
                            // print("ok ct");
                          }

                          if (vcb) {
                            vc = data["voteCount"];
                            // print("ok vc");
                          } else if (!vcb) {
                            vc++;
                          }

                          if (imageb) {
                            imageID =
                                data["imageUrl"].toString().replaceAll(exp, "");
                            print("ok ct");
                          } else if (!imageb) {
                            imageID = imageID.toString().replaceAll(exp, "");
                          }

                          double rate = data["defaultRating"] + 0.0;


                          for (int i = 0; i < snapshot2.data.size; i++) {
                            if (snapshot2.data.docs[i]["id"] == pageid) {
                              issub = true;
                              changeIconSub();
                            }
                          }


                          return CustomScrollView(
                            slivers: [

                              SliverAppBar(

                                backgroundColor: Colors.white,
                                iconTheme: IconThemeData(
                                  color: Colors.black38,
                                ),
                                actions: <Widget>[
                                  IconButton(
                                      onPressed: () async {
                                        int count = 0;
                                        Navigator.of(context).popUntil((route) {
                                          return route.settings.name ==
                                              'mainMenu';
                                        });
                                      },
                                      icon: Icon(Icons.home)),
                                ],
                                flexibleSpace: FlexibleSpaceBar(
                                  titlePadding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  centerTitle: false,
                                  title: Row(
                                    children: <Widget>[
                                      // SizedBox(
                                      //   child: Text(
                                      //     data["nombre"],
                                      //     textAlign: TextAlign.center,
                                      //     style: TextStyle(color: Colors.black, fontSize: 12),
                                      //   ),
                                      // ),
                                      //
                                      // SizedBox(
                                      //   width: 30,
                                      // ),

                                      SizedBox(
                                        child: RatingBarIndicator(
                                          rating: rate,
                                          itemBuilder: (context, index) =>
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                          itemCount: 5,
                                          itemSize: 17,
                                          itemPadding: EdgeInsets.all(1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 70,
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 50,
                                        child: IconButton(

                                          onPressed: () {
                                            int voteC = vc;

                                            if (issub) {
                                              showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      elevation: 24,
                                                      title: Text(
                                                          "¿Quieres quitar tu suscripción?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("No"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            bool vote = false;
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'usuario')
                                                                .doc(user.uid)
                                                                .collection(
                                                                'suscripciones')
                                                                .doc(
                                                                data["nombre"])
                                                                .delete();
                                                            BusinessDatabaseConnect()
                                                                .voteEmpresa(
                                                                pageid, vote);
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                .of(context)
                                                                .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        'Suscripción a ${data['nombre']} Eliminada')));
                                                          },
                                                          child: Text("Si"),
                                                        ),

                                                      ],
                                                    );
                                                  }
                                              );

                                              setState(() {
                                                issub = false;
                                              });
                                            } else {
                                              print(data.id);
                                              bool vote = true;
                                              DatabaseConnect(uid: user.uid)
                                                  .agregarSuscripcion(
                                                  data['nombre'], rate, voteC,
                                                  pageid);
                                              BusinessDatabaseConnect()
                                                  .voteEmpresa(pageid, vote);
                                              setState(() {
                                                changeIconUnSub();
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Suscrito a ${data['nombre']}')));
                                            }
                                          },
                                          iconSize: 20,
                                          icon: Icon(issub
                                              ? Icons.check_rounded
                                              : Icons.add),
                                          color: Color(0xff108aa6),
                                        ),
                                      ),


                                    ],
                                  ),

                                  background: Column(

                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 230,
                                        height: 230,
                                        child: FittedBox(
                                          child: Center(
                                            child: Image.network(
                                              "https://drive.google.com/uc?export=view&id=${imageID}",
                                              fit: BoxFit.fill,),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  // background:
                                  // fit: BoxFit.cover,

                                ),
                                pinned: true,
                                expandedHeight: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.305,
                              ),
                              SliverList(delegate: SliverChildListDelegate([
                                Stack(

                                  children: <Widget>[

                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 2,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                              color: Colors.black12,

                                              boxShadow: [
                                                BoxShadow(
                                                  offset: const Offset(
                                                      3.0, 3.0),
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                ),
                                              ]
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.symmetric(horizontal: 1),
                                        //   child:
                                        //   ),
                                        // ),


                                        SizedBox(height: 540),
                                        // Padding(
                                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                                        //   child: Divider(
                                        //     color: Colors.black26,
                                        //     thickness: 2,
                                        //   ),
                                        // ),
                                        Container(
                                          height: 600,
                                          margin: new EdgeInsets.only(
                                            top: 5,
                                            left: 0,
                                            right: 0,
                                          ),
                                          // padding: EdgeInsets.symmetric(
                                          //     vertical: 20,
                                          //     horizontal: 20),
                                          decoration: BoxDecoration(

                                            borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(
                                                  10),
                                              topRight: const Radius.circular(
                                                  7),
                                            ),
                                            // color: Color(0xff055475),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/background2.png"),
                                              fit: BoxFit.fill,

                                            ),
                                          ),
                                          // child: Image(
                                          //     image: AssetImage("assets/images/background2.png"),
                                          //     fit: BoxFit.cover
                                          // ),
                                        ),

                                      ],
                                    ),
                                    if(!ct) Center(
                                      child: Container(
                                        height: 40,
                                        width: 300,
                                        decoration: BoxDecoration(

                                          borderRadius: new BorderRadius
                                              .vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            data["nombre"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ),

                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        children: <Widget>[


                                          SizedBox(height: 50),
                                          StreamBuilder <DocumentSnapshot>(
                                              stream: FirebaseFirestore
                                                  .instanceFor(
                                                  app: Firebase.app(
                                                      'businessApp'))
                                                  .collection('ofertas').doc(
                                                  pageid)
                                                  .snapshots(),
                                              builder: (context, snapshot1) {
                                                int idx = 0;
                                                return SizedBox(
                                                  height: 170,
                                                  child: PageView.builder(
                                                      itemCount: 5,
                                                      controller: PageController(/*viewportFraction: 0.9*/),
                                                      onPageChanged: (
                                                          int index) =>
                                                          setState(() =>
                                                          idx = index),
                                                      itemBuilder: (_, i) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              horizontal: 7),

                                                          child: Card(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                  .circular(5)),
                                                            ),
                                                            child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 20),
                                                              alignment: Alignment
                                                                  .center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                    .circular(
                                                                    5)),
                                                                // boxShadow: <BoxShadow>[
                                                                //   BoxShadow(
                                                                //       color: Colors.black,
                                                                //       offset: Offset(0, 4),
                                                                //       blurRadius: 10,
                                                                //       spreadRadius: 2)
                                                                // ],
                                                                // border: Border.all(color: Colors.grey, width: 2),
                                                                image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/darkblue.jpg"),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                "OFERTA ${i + 1}",
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: Colors
                                                                        .white),


                                                                //AGREGAR SECCION DE RECOMENDACION GUSTOS, FILTRADO POR TAGS DE GUSTOS AGREGADOS


                                                              ),
                                                            ),
                                                          ),


                                                        );
                                                      }
                                                  ),
                                                  // child:
                                                );
                                              }
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.9,
                                            height: 300,
                                            decoration: BoxDecoration(

                                              borderRadius: new BorderRadius
                                                  .all(
                                                Radius.circular(10),
                                              ),
                                              color: Color(0xffefeeec),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),

                                            child: Center(
                                              child: Stack(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          5),
                                                      decoration: BoxDecoration(

                                                        borderRadius: new BorderRadius
                                                            .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: GoogleMap(
                                                        markers: markersMap,
                                                        onMapCreated: onMapCreated,
                                                        initialCameraPosition: CameraPosition(
                                                          target: LatLng(
                                                              inlat, inlng),
                                                          zoom: 14,
                                                        ),
                                                        myLocationButtonEnabled: false,
                                                        zoomControlsEnabled: false,
                                                      ),
                                                    ),

                                                  ]
                                              ),
                                            ),

                                          ),
                                          SizedBox(height: 260),
                                          Container(

                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal: 30),
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.9,
                                            height: 500,
                                            // decoration: BoxDecoration(
                                            //
                                            //   borderRadius: new BorderRadius
                                            //       .all(
                                            //     Radius.circular(10),
                                            //   ),
                                            //   color: Color(0xffc3d3e3),
                                            //   boxShadow: [
                                            //     BoxShadow(
                                            //       color: Colors.black54
                                            //           .withOpacity(0.5),
                                            //       spreadRadius: 5,
                                            //       blurRadius: 7,
                                            //       offset: Offset(0,
                                            //           3), // changes position of shadow
                                            //     ),
                                            //   ],
                                            // ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                                      height: 400,
                                                      decoration: BoxDecoration(
                                                        borderRadius: new BorderRadius
                                                            .all(
                                                          Radius.circular(10),
                                                        ),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26
                                                                .withOpacity(0.5),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xd000528E),
                                                              child: ListTile(
                                                                leading: Text('Lunes',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
                                                                title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                          // SizedBox(height: 20,),
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xd000528E),
                                                              child: ListTile(
                                                                leading: Text('Martes',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
                                                                title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xd000528E),
                                                              child: ListTile(
                                                                leading: Text('Miercoles',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
                                                                title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xd000528E),
                                                              child: ListTile(
                                                                leading: Text('Jueves',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
                                                                title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xd000528E),
                                                              child: ListTile(
                                                                leading: Text('Sabado',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
                                                                title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xd000528E),
                                                              child: ListTile(
                                                                leading: Text('Domingo',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
                                                                title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(height: 20,),

                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius: new BorderRadius
                                                            .all(
                                                          Radius.circular(10),
                                                        ),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26
                                                                .withOpacity(0.5),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Card(
                                                              color: Color(0xcf3179ad),
                                                              child: ListTile(
                                                                leading: Text('Telefono:',textAlign: TextAlign.left, style: TextStyle(color: Colors.black54, fontSize: 20)),
                                                                // title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                trailing: Text(telefono, textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 20),),
                                                              ),
                                                            ),

                                                          ),
                                                          // SizedBox(height: 20,),


                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),

                                                ],
                                              ),
                                            ),

                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),


                              ]))
                            ],
                          );
                        }
                    );
                  }
              );
            },
          );
        }
        ),
    );
      }


  }


