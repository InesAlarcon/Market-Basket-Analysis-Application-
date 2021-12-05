// @dart=2.9
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:cliente/src/main/mainMenu.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flip_card/flip_card.dart';
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
import 'package:url_launcher/url_launcher.dart';
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

  var ofertaData = [];
  var data;
  var datauser;

  InfinityPageController _pageController = InfinityPageController(
    initialPage: 0,
  );


  Icon subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  Icon favIcon = new Icon(Icons.favorite_border, color: Color(0xff108aa6));
  // get formKey => null;
  changeIconSub(){
    subscribeIcon = new Icon(Icons.check_rounded, color: Colors.green,);
  }
  changeIconUnSub(){
    subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  }

  changeIconFav(){
    favIcon = new Icon(Icons.favorite, color: Color(0xff108aa6));
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
  String sucursalid="";
  var pageData = [];
  var sucursalesList = [];
  bool notifs = false;
  bool subscript = false;

  @override
  void initState(){
    super.initState();
    pageid = widget.pageid;
    fetchOfertas();
    // userid = widget.userid;

    // print(pageid);
    // print(userid);


  }


  Future<void> launchApp(String url) async {

    if(await canLaunch(url)){
      await launch(
          url,
          headers: <String,String>{'header_key':'header_value'},
      );
    }

  }

  initPage(){
    SearchService().searchByID(pageid).then((QuerySnapshot docs){
      pageData = docs.docs.map((e) => {
        "id": e.id,
        "nombre": e.get("nombre"),
        "defaultRating": e.get("defaultRating"),
        "voteCount": e.get("voteCount"),
      }).toList();
      // print(pageData);
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

  fetchOfertas() async {

      FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection("ofertas").doc(pageid).collection("ofertas").snapshots().listen((event) {

        ofertaData = event.docs.map((e) => {
          "pageid": pageid,
          "id": e.id,
          "nombre": e.get("nombre"),
          "urlImage": e.get("urlImage"),
          "valor": e.get("valor"),
          "etiquetas": e.get("etiquetas"),
          "categorias": e.get("categorias"),
          "votos": e.get("votos"),
          "estado": e.get("estado"),
          "limiteOferta": e.get("limiteOferta"),
          "limiteUsuario": e.get("limiteUsuario"),
        }).toList();
        print(ofertaData);
        // oferList=ofertaData;
      });

  }
  
  Widget sucursalList(DocumentSnapshot snapshot){
    var sucursal = snapshot.data();
    // print("id: ${snapshot.id}");


    return  Column(
      children: <Widget>[
        SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),

            height: 420,
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
                SizedBox(
                  child: Text("Horario ${snapshot.get("nombre")}"),
                ),
                Container(
                  // height: 40,
                  // color: Colors.blue,
                  child: Card(
                    color: Color(0xd00081CF),
                    child:
                    Center(

                      child: ListTile(
                        // contentPadding: EdgeInsets.symmetric(),
                        dense: true,
                        leading: Text("Lunes",textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                        title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                        trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    ),
                  ),

                ),
                // SizedBox(height: 20,),
                Container(
                  child: Card(
                    color: Color(0xd00081CF),
                    child: ListTile(
                      dense: true,
                      leading: Text('Martes',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                      title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                      trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),

                ),
                Container(
                  child: Card(
                    color: Color(0xd00081CF),
                    child: ListTile(
                      dense: true,
                      leading: Text('Miércoles',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                      title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                      trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),

                ),
                Container(
                  child: Card(
                    color: Color(0xd00081CF),
                    child: ListTile(
                      dense: true,
                      leading: Text('Jueves',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                      title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                      trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),

                ),
                Container(
                  child: Card(
                    color: Color(0xd00081CF),
                    child: ListTile(
                      dense: true,
                      leading: Text('Viernes',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                      title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                      trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),

                ),
                Container(
                  child: Card(
                    color: Color(0xd00081CF),
                    child: ListTile(
                      dense: true,
                      leading: Text('Sabado',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                      title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                      trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),

                ),
                Container(
                  child: Card(
                    color: Color(0xd00081CF),
                    child: ListTile(
                      dense: true,
                      leading: Text('Domingo',textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 18)),
                      title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16),),
                      trailing: Text('5:00 PM', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 16),),
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
            height: 160,
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
                SizedBox(
                  child: Text("Contacto ${snapshot.get("nombre")}"),
                ),
                Container(
                  child: Card(
                    color: Color(0xcf3179ad),
                    child: ListTile(
                      dense: true,
                      leading: Text('Teléfono:',textAlign: TextAlign.left, style: TextStyle(color: Colors.black54, fontSize: 20)),
                      // title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                      trailing: Text(snapshot.get("telefono"), textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 20),),
                    ),
                  ),

                ),
                Container(
                  child: Card(
                    color: Color(0xcf3179ad),
                    child: ListTile(
                      dense: true,
                      leading: Text('Correo:',textAlign: TextAlign.left, style: TextStyle(color: Colors.black54, fontSize: 20)),
                      // title: Text('8:00 AM', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 20),),
                      trailing: Text(snapshot.get("correo"), textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 20),),
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
    );
  }
  
  Widget updateSucursal(String sucursalID){
    // print(sucursalid);
    print("sucursalID ${sucursalID}");

    

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.
        instanceFor(app: Firebase.app('businessApp')).collection(
            'empresa').
        doc(pageid).collection("sucursales").doc(sucursalID).snapshots(),
        builder: (context, snapshotSucursal) {
          // var sucursal = snapshotSucursal.data;
          
          if(!snapshotSucursal.hasData) return LinearProgressIndicator();
          return  sucursalList(snapshotSucursal.data);
          

          
        }
    );


    
  }

  Widget notificationButton(context,String uid){
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('usuario')
          .doc(uid).collection("suscripciones")
          .doc(pageid).snapshots(),
      // ignore: missing_return
      builder: (context, sub){
          if(!sub.hasData||!sub.data.exists){
            return IconButton(
              onPressed: () async {

              },
              icon: Icon(Icons.announcement_outlined),
              color: Colors.transparent,);
          }else{
            notifs = sub.data.get("notifs");
            if(notifs){
              return IconButton(
                  onPressed: () async {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 24,
                            title: Text(
                                "¿Quieres quitar las notificaciones?"
                            ),
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
                                  // subscript = true;
                                  setState(() {
                                    notifs = false;
                                  });
                                  DatabaseConnect(uid: uid)
                                      .modificarNotificacion(
                                      pageid, notifs);
                                  FirebaseMessaging.instance.unsubscribeFromTopic(data.id);
                                  Navigator.pop(
                                      context);
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Notificaciones a ${data['nombre']} Eliminadas')));
                                },
                                child: Text("Si"),
                              ),

                            ],
                          );
                        }
                    );


                  },
                  icon: Icon(Icons.add_alert));
            }
            else if(!notifs){
              return IconButton(
                onPressed: () async {
                  FirebaseMessaging.instance.subscribeToTopic(data.id);
                  setState(() {
                    notifs = true;
                  });
                  DatabaseConnect(uid: uid)
                      .modificarNotificacion(
                      pageid, notifs);
                },
                icon: Icon(Icons.add_alert_outlined),
                color: Colors.black38,
              );
            }
          }
      },


    );
    // if(notifs&&subscript){
    //   return IconButton(
    //       onPressed: () async {
    //           showDialog(
    //               barrierDismissible: true,
    //               context: context,
    //               builder: (context) {
    //                 return AlertDialog(
    //                   elevation: 24,
    //                   title: Text(
    //                       "¿Quieres quitar las notificaciones?"
    //                   ),
    //                   actions: [
    //                     TextButton(
    //                       onPressed: () {
    //                         Navigator.pop(
    //                             context);
    //                       },
    //                       child: Text("No"),
    //                     ),
    //                     TextButton(
    //                       onPressed: () {
    //                         subscript = true;
    //                         setState(() {
    //                           notifs = false;
    //                         });
    //                         FirebaseMessaging.instance.unsubscribeFromTopic(data.id);
    //                         Navigator.pop(
    //                             context);
    //                         ScaffoldMessenger
    //                             .of(context)
    //                             .showSnackBar(
    //                             SnackBar(
    //                                 content: Text(
    //                                     'Notificaciones a ${data['nombre']} Eliminadas')));
    //                       },
    //                       child: Text("Si"),
    //                     ),
    //
    //                   ],
    //                 );
    //               }
    //           );
    //
    //
    //       },
    //       icon: Icon(Icons.announcement));
    // }
    // else if((!notifs)&&(subscript)){
    //   return IconButton(
    //       onPressed: () async {
    //         FirebaseMessaging.instance.subscribeToTopic(data.id);
    //         setState(() {
    //           notifs = true;
    //         });
    //       },
    //       icon: Icon(Icons.announcement_outlined),
    //       color: Colors.black87,
    //   );
    // }
    // else if((!notifs)&&(!subscript)){
    //   return IconButton(
    //       onPressed: () async {
    //
    //       },
    //       icon: Icon(Icons.announcement_outlined),
    //       color: Colors.transparent,);
    // }
  }

  DecorationImage imagePick(String img){
    RegExp imgExp = new RegExp(r"(http)");
    Uint8List bytes;

    if(imgExp.hasMatch(img)){
      return DecorationImage(
        image: NetworkImage(
          img,
        ),
        fit: BoxFit.cover,
      );
    }else{
      final UriData data = Uri.parse(img).data;

      bytes = data.contentAsBytes();

      return DecorationImage(
        image: MemoryImage(
          bytes
        ),
        fit: BoxFit.cover,
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    bool selected = true;
    final user = Provider.of<Usuario>(context);

    DocumentSnapshot snapshotDoc;
    initPage();
    fetchOfertas();

    return new Scaffold(
      body: StreamBuilder<DocumentSnapshot>(

        stream: FirebaseFirestore.
        instanceFor(app: Firebase.app('businessApp')).collection('empresa').
        doc(pageid).snapshots(),

        builder: (context,snapshot) {

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection("ofertas").snapshots(),

            builder: (context, snapoferta) {

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

                          return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.
                          instance.collection(
                          'usuario').
                          doc(user.uid).collection("ratings").doc(pageid).snapshots(),
                          builder: (context, snapRating) {



                            bool test = false;
                            bool getVoteCount = false;
                            double empRate = 0.0;
                            double ratings = 0.0;

                            var rateQuery;
                            if(!snapRating.hasData||!snapRating.data.exists){
                              test = false;
                              getVoteCount = false;
                              empRate = 0.0;
                              ratings = 0.0;
                            }
                            else{
                              rateQuery = snapRating.data;
                              test = rateQuery.get("voteCount");
                              empRate = rateQuery.get("rating");
                              ratings = rateQuery.get("rating");
                              getVoteCount = rateQuery.get("voteCount");
                            }


                            var stores = snapshotStores.data;



                            data = snapshot.data;
                            bool issub = false;


                            bool ct = false;
                            double inlat = 0.0;
                            double inlng = 0.0;
                            int vc = 0;
                            int idx = 0;
                            String sucursalNombre = "";

                            String sucursal;

                            String image;


                            Uint8List bytes;

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
                                "urlImage");

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

                            sucursalesList = stores.docs.map((e) => {
                              "id": e.id,
                              "nombre": e.get("nombre")
                            }).toList();

                            // print(sucursalesList);

                            for(int i = 0; i<stores.size; i++){



                              // print(stores.docs[i]["nombre"]);
                              sucursalNombre = stores.docs[i]["nombre"].toString();
                              inlat = stores.docs[i]["latitud"]+0.0;
                              inlng = stores.docs[i]["longitud"]+0.0;

                              markersMap.add( Marker(
                                markerId: MarkerId("${i}"),
                                position: LatLng(inlat,inlng),
                                infoWindow: InfoWindow(
                                  title: sucursalNombre,
                                  snippet: "Tel: ${stores.docs[i]["telefono"]}",

                                ),




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
                              image = data["urlImage"];

                              final UriData img = Uri.parse(image).data;

                              bytes = img.contentAsBytes();

                              // print("ok ct");
                            } else if (!imageb) {
                              imageID = imageID.toString().replaceAll(exp, "");
                            }

                            double rate = data["defaultRating"]  + 0.0;


                            for (int i = 0; i < snapshot2.data.size; i++) {
                              if (snapshot2.data.docs[i]["id"] == pageid) {
                                issub = true;
                                changeIconSub();
                              }
                            }



                            return Container(
                              // height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xff81d8fc), Color(0xff2C73D2)])
                              ),
                              child: CustomScrollView(
                                slivers: [

                                  SliverAppBar(


                                    backgroundColor: Color(0xff2C73D2),
                                    iconTheme: IconThemeData(
                                      color: Colors.black38,
                                    ),
                                    actions: <Widget>[
                                      notificationButton(context,user.uid),
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

                                          if (!getVoteCount) SizedBox(


                                            child: RatingBar.builder(
                                              itemSize: 15,

                                              initialRating: data["defaultRating"] +0.0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                // print(rating);
                                                empRate = rating;

                                              },
                                            ),

                                          )
                                          else SizedBox(
                                            child: RatingBarIndicator(
                                              rating: data["defaultRating"]+0.0,
                                              itemBuilder: (context, index) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                            ),
                                          ),
                                          if (!getVoteCount) SizedBox(
                                              height: 30,
                                              width: 70,
                                              child: Card(
                                                // shape: RoundedRectangleBorder(
                                                //   side: BorderSide(
                                                //     color: Colors.white,
                                                //     width: 1,
                                                //   ),
                                                //   borderRadius: BorderRadius.circular(5),
                                                // ),
                                                // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                                                color: Color(0xffffb938),
                                                // child: Center(
                                                child: ListTile(
                                                  title: Align(
                                                    alignment: Alignment(0.0,-3.5),
                                                    child: Text('Calificar', style: TextStyle( fontSize: 8),textAlign: TextAlign.center),),
                                                  onTap: () async {
                                                    bool vote = true;

                                                    setState(() {
                                                      changeIconUnSub();
                                                    });
                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
                                                    DatabaseConnect(uid: user.uid).ratingSubs(pageid, empRate, vote);
                                                    BusinessDatabaseConnect().voteEmpresa(pageid, vote);
                                                    Future.delayed(Duration(milliseconds: 500),(){
                                                      setState(() {
                                                        BusinessDatabaseConnect().rateEmpresa(pageid, vote, empRate);
                                                      });
                                                    });
                                                    // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(content: Text('Calificación de ${data["nombre"]} modificada')));
                                                  },
                                                ),
                                              )
                                          )
                                          else SizedBox(
                                              height: 30,
                                              width: 70,
                                              child: Card(
                                                // shape: RoundedRectangleBorder(
                                                //   side: BorderSide(
                                                //     color: Colors.white,
                                                //     width: 1,
                                                //   ),
                                                //   borderRadius: BorderRadius.circular(5),
                                                // ),
                                                // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                                                color: Color(0xfffa4d6a),
                                                // child: Center(
                                                child: ListTile(
                                                  title: Align(
                                                    alignment: Alignment(0.0,-3.5),
                                                    child: Text('Quitar', style: TextStyle( fontSize: 8, color: Colors.white),textAlign: TextAlign.center),),
                                                  onTap: () async {
                                                    showDialog(
                                                        barrierDismissible: true,
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            elevation: 24,
                                                            title: Text(
                                                                "¿Quieres quitar tu calificación?"
                                                            ),
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
                                                                  DatabaseConnect(uid: user.uid).ratingSubs(pageid, 0.0, vote);
                                                                  BusinessDatabaseConnect().rateEmpresa(pageid, vote, ratings);
                                                                  Future.delayed(Duration(milliseconds: 500),(){
                                                                    setState(() {
                                                                      BusinessDatabaseConnect().voteEmpresa(pageid, vote);
                                                                    });
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                      .showSnackBar(
                                                                      SnackBar(
                                                                          content: Text(
                                                                              'Calificación a ${data["empresa"]} Eliminada')));
                                                                },
                                                                child: Text("Si"),
                                                              ),

                                                            ],
                                                          );
                                                        }
                                                    );
                                                    setState(() {
                                                      test = false;
                                                    });

                                                  },
                                                ),
                                              )
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 80,
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
                                                              "¿Quieres quitar tu suscripción?"
                                                          ),
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
                                                                subscript = false;
                                                                notifs = false;
                                                                FirebaseMessaging.instance.unsubscribeFromTopic(data.id);

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                    'usuario')
                                                                    .doc(user.uid)
                                                                    .collection(
                                                                    'suscripciones')
                                                                    .doc(
                                                                    data.id)
                                                                    .delete();
                                                                BusinessDatabaseConnect()
                                                                    .subEmpresa(
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
                                                  // print(data.id);
                                                  bool vote = true;
                                                  subscript = true;
                                                  notifs = true;
                                                  FirebaseMessaging.instance.subscribeToTopic(data.id);

                                                  DatabaseConnect(uid: user.uid)
                                                      .agregarSuscripcion(
                                                      data['nombre'], rate, voteC,
                                                      pageid);
                                                  BusinessDatabaseConnect()
                                                      .subEmpresa(pageid, vote);
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
                                              color: Color(0xff2C73D2),
                                            ),
                                          ),


                                        ],
                                      ),

                                      background:
                                      Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)])
                                            ),),
                                          Column(

                                            children: <Widget>[
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                width: 230,
                                                height: 230,
                                                // color: Color(0xFFFFFFFF),
                                                child: FittedBox(
                                                  child: Center(
                                                    child: DropShadowImage(
                                                      borderRadius: 15,
                                                      blurRadius: 0,
                                                      offset: Offset(2,5),
                                                      scale: 1.01,
                                                      image: Image.memory(
                                                        bytes,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      // image: Image.network(
                                                      //   image,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),

                                      // background:
                                      // fit: BoxFit.cover,

                                    ),
                                    pinned: true,
                                    expandedHeight: 300,
                                    // MediaQuery
                                    //     .of(context)
                                    //     .size
                                    //     .height * 0.305,
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


                                            SizedBox(height: 150),


                                          ],
                                        ),
                                        if(!ct) Center(
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(

                                              borderRadius: new BorderRadius
                                                  .vertical(
                                                bottom: Radius.circular(10),
                                              ),
                                              color: Color(0xffFFFFFF),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(
                                                      0.3),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child:
                                              Stack(
                                                children: <Widget>[
                                                  // Stroked text as border.
                                                  // Text(
                                                  //   data["nombre"],
                                                  //   style: TextStyle(
                                                  //     fontSize: 25,
                                                  //     foreground: Paint()
                                                  //       ..style = PaintingStyle.stroke
                                                  //       ..strokeWidth = 3
                                                  //       ..color = Colors.deepPurpleAccent,
                                                  //   ),
                                                  // ),
                                                  // Solid text as fill.
                                                  Text(
                                                    data["nombre"],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Text(
                                              //   ,
                                              //   textAlign: TextAlign.center,
                                              //   style: TextStyle(
                                              //       color: Colors.white,
                                              //       fontSize: 25),
                                              // ),
                                            ),

                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: <Widget>[


                                              SizedBox(height: 50),
                                              StreamBuilder <QuerySnapshot>(
                                                  stream: FirebaseFirestore.
                                                  instanceFor(app: Firebase.app('businessApp')).
                                                  collection('ofertas').doc(pageid).collection("ofertas").
                                                  snapshots(),
                                                  builder: (context, snapshot1) {
                                                    int idx = 0;
                                                    var useroferta = snapoferta.data;
                                                    var oferta = snapshot1.data;





                                                    for(int k = 0;k<ofertaData.length;k++){
                                                      if(ofertaData[k]["estado"]=="activo"){
                                                        for(int m=0;m<useroferta.size;m++){

                                                          if(useroferta.docs[m]["ofertaID"]==ofertaData[k]["id"]){

                                                            if((useroferta.docs[m]["limite"]==0)||(useroferta.docs[m]["estado"]==false)){

                                                              ofertaData.removeAt(k);

                                                            }
                                                          }

                                                        }
                                                      }else{
                                                        for(int m=0;m<useroferta.size;m++) {
                                                          if (useroferta.docs[m]["ofertaID"] == ofertaData[k]["id"]) {
                                                            DatabaseConnect(uid: user.uid).likeOferta(useroferta.docs[m]["ofertaID"],true,false,false,useroferta.docs[m]["limite"],useroferta.docs[m]["urlImage"],useroferta.docs[m]["nombre"],useroferta.docs[m]["valor"],useroferta.docs[m]["idEmpresa"]);
                                                          }
                                                        }

                                                        ofertaData.removeAt(k);
                                                      }




                                                    }




                                                    return SizedBox(
                                                      height: 200,
                                                      child: InfinityPageView(
                                                          itemCount: ofertaData.length,
                                                          controller: _pageController,
                                                          onPageChanged: (
                                                              int index) =>
                                                              setState(() =>
                                                              idx = index),
                                                          itemBuilder: (_, i) {
                                                            bool isfav = false;
                                                            for (int j = 0; j < useroferta.size; j++) {
                                                              if (useroferta.docs[j]["ofertaID"] == ofertaData[i]["id"]) {
                                                                isfav = true;
                                                                changeIconFav();
                                                              }
                                                            }


                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 7),

                                                              child: FlipCard(
                                                                direction: FlipDirection.VERTICAL,
                                                                front: Card(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .all(Radius
                                                                        .circular(5)),
                                                                  ),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    // height: 50,
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 0),
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
                                                                      image: imagePick(ofertaData[i]["urlImage"]),

                                                                    ),
                                                                    //     child: Stack(
                                                                    //       children: <Widget>[
                                                                    //         Container(
                                                                    //           // height: ,
                                                                    //           width: MediaQuery.of(context).size.width,
                                                                    //           // color: Colors.amber,
                                                                    //           child: Row(
                                                                    //             crossAxisAlignment: CrossAxisAlignment.center,
                                                                    //             // mainAxisAlignment: MainAxisAlignment.center,
                                                                    //
                                                                    //             children: <Widget>[
                                                                    //               Container(
                                                                    //                 width: 200,
                                                                    //                 // height: 100,
                                                                    //                 decoration: BoxDecoration(
                                                                    //                   borderRadius: BorderRadius
                                                                    //                       .all(Radius
                                                                    //                       .circular(
                                                                    //                       5)),
                                                                    //                   // boxShadow: <BoxShadow>[
                                                                    //                   //   BoxShadow(
                                                                    //                   //       color: Colors.black,
                                                                    //                   //       offset: Offset(0, 4),
                                                                    //                   //       blurRadius: 10,
                                                                    //                   //       spreadRadius: 2)
                                                                    //                   // ],
                                                                    //                   // border: Border.all(color: Colors.grey, width: 2),
                                                                    //                   image: DecorationImage(
                                                                    //                     image: NetworkImage(
                                                                    //                       oferta.docs[i]["urlImage"],
                                                                    //                       ),
                                                                    //                       fit: BoxFit.fill,),
                                                                    //
                                                                    //                   ),
                                                                    //                 ),
                                                                    //               SizedBox(
                                                                    //                 width: 30,
                                                                    //               ),
                                                                    //               Column(
                                                                    //                 mainAxisAlignment: MainAxisAlignment.start,
                                                                    //
                                                                    //                 children: <Widget>[
                                                                    //                   Text(
                                                                    //                     oferta.docs[i]["nombre"],
                                                                    //                     style: TextStyle(
                                                                    //                         fontSize: 20,
                                                                    //                         color: Colors
                                                                    //                             .white),
                                                                    //
                                                                    //
                                                                    //                     //AGREGAR SECCION DE RECOMENDACION GUSTOS, FILTRADO POR TAGS DE GUSTOS AGREGADOS
                                                                    //
                                                                    //
                                                                    //                   ),
                                                                    //                 ]
                                                                    //               ),
                                                                    //
                                                                    //             ],
                                                                    //           ),
                                                                    //         ),
                                                                    //   ],
                                                                    //
                                                                    // ),
                                                                    child: Stack(
                                                                      children: <Widget>[Container(
                                                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                                                          child: Align(
                                                                            alignment: Alignment.topRight,
                                                                            child: Stack(
                                                                              children: <Widget>[
                                                                                // Stroked text as border.
                                                                                Text(
                                                                                  ofertaData[i]["nombre"],
                                                                                  style: GoogleFonts.oswald(
                                                                                    foreground:  Paint()
                                                                                      ..style = PaintingStyle.stroke
                                                                                      ..strokeWidth = 2
                                                                                      ..color = Colors.black54,
                                                                                    textStyle: Theme.of(context).textTheme.headline4,
                                                                                    fontSize: 25,
                                                                                    fontWeight: FontWeight.w700,

                                                                                  ),
                                                                                  // textAlign: TextAlign.center,
                                                                                ),
                                                                                // Solid text as fill.
                                                                                Text(
                                                                                  ofertaData[i]["nombre"],
                                                                                  style: GoogleFonts.oswald(
                                                                                    shadows: <Shadow>[
                                                                                      Shadow(
                                                                                        offset: Offset(3.5, 3.5),
                                                                                        blurRadius: 3.0,
                                                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                                                      ),
                                                                                    ],
                                                                                    textStyle: Theme.of(context).textTheme.headline4,
                                                                                    fontSize: 25,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Colors.white.withOpacity(0.9),
                                                                                  ),
                                                                                  // textAlign: TextAlign.center,
                                                                                ),
                                                                              ],
                                                                            )
                                                                          )
                                                                      ),
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                          child: Align(
                                                                            alignment: Alignment.bottomLeft,

                                                                            child: Container(
                                                                              height: 45,
                                                                              width: 45,
                                                                              decoration: BoxDecoration(
                                                                                boxShadow: <BoxShadow>[
                                                                                  BoxShadow(
                                                                                      color: Colors.black54,
                                                                                      offset: Offset(0, 0),
                                                                                      blurRadius: 4,
                                                                                      spreadRadius: 1)
                                                                                ],
                                                                                borderRadius: BorderRadius
                                                                                    .all(Radius
                                                                                    .circular(12)),
                                                                                color: Colors.white,
                                                                              ),

                                                                              child: Stack(
                                                                                children: <Widget>[
                                                                                  Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: IconButton(
                                                                                      iconSize: 30,
                                                                                      onPressed: (){

                                                                                        if(isfav){
                                                                                          bool vote = false;
                                                                                          setState(() {
                                                                                            isfav = false;
                                                                                            FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('ofertas').doc(ofertaData[i]["id"]).delete();
                                                                                            BusinessDatabaseConnect().likeOferta(pageid, ofertaData[i]["id"], vote);
                                                                                          });

                                                                                        }else{
                                                                                          bool vote = true;
                                                                                          setState(() {

                                                                                            isfav = true;
                                                                                            DatabaseConnect(uid: user.uid).likeOferta(ofertaData[i]["id"],isfav,true,false,ofertaData[i]["limiteUsuario"],ofertaData[i]["urlImage"],ofertaData[i]["nombre"],ofertaData[i]["valor"]+0.0,ofertaData[i]["pageid"]);
                                                                                            BusinessDatabaseConnect().likeOferta(pageid, ofertaData[i]["id"], vote);
                                                                                            ScaffoldMessenger.of(context)
                                                                                                .showSnackBar(SnackBar(
                                                                                                content: Text(
                                                                                                    'Te gusta ${ofertaData[i]["nombre"]}')));
                                                                                          });
                                                                                        }

                                                                                      },
                                                                                      icon: Icon(isfav
                                                                                          ? Icons.favorite
                                                                                          : Icons.favorite_border),
                                                                                      color: Color(0xff2C73D2),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                ),
                                                                back: Card(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .all(Radius
                                                                        .circular(5)),
                                                                  ),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    // height: 50,
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 20),
                                                                    alignment: Alignment
                                                                        .center,
                                                                    //
                                                                    child: Stack(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          // height: ,
                                                                          width: MediaQuery.of(context).size.width,
                                                                          // color: Colors.amber,
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            // mainAxisAlignment: MainAxisAlignment.center,

                                                                            children: <Widget>[
                                                                              Container(
                                                                                  width: 150,
                                                                                  // height: 200,
                                                                                  child: InkWell(
                                                                                    onTap: (){
                                                                                      showDialog(
                                                                                          barrierDismissible: true,
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return AlertDialog(
                                                                                              elevation: 24,
                                                                                              title: Text(
                                                                                                  "¿Quieres usar la oferta?"
                                                                                              ),
                                                                                              content: Row(
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    width: 130,
                                                                                                    height: 130,
                                                                                                    child: QrImage(
                                                                                                      data: ofertaData[i]["id"],
                                                                                                      size: MediaQuery
                                                                                                          .of(context)
                                                                                                          .size
                                                                                                          .height,
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(

                                                                                                    height: 120,
                                                                                                    child: Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment
                                                                                                            .center,
                                                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                                                            .start,
                                                                                                        children: <Widget>[
                                                                                                          SizedBox(
                                                                                                            height: 40,
                                                                                                            // width: 200,
                                                                                                            child: Text(
                                                                                                              ofertaData[i]["nombre"],
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  color: Colors
                                                                                                                      .black54),
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 40,
                                                                                                            // width: 200,
                                                                                                            child: Text(
                                                                                                              "GTQ ${ofertaData[i]["valor"]}",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  color: Colors
                                                                                                                      .black54),
                                                                                                            ),
                                                                                                          ),

                                                                                                        ]
                                                                                                    ),
                                                                                                  ),

                                                                                                ],
                                                                                              ),
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
                                                                                                    bool vote = true;
                                                                                                    DatabaseConnect(
                                                                                                        uid: user.uid)
                                                                                                        .likeOferta(
                                                                                                        ofertaData[i]["id"],isfav,true,true,ofertaData[i]["limiteUsuario"],ofertaData[i]["urlImage"],ofertaData[i]["nombre"],ofertaData[i]["valor"],ofertaData[i]["pageid"]);
                                                                                                    BusinessDatabaseConnect()
                                                                                                        .useOferta(
                                                                                                        pageid,
                                                                                                        ofertaData[i]["id"],
                                                                                                        vote);
                                                                                                    Navigator.pop(
                                                                                                        context);
                                                                                                  },
                                                                                                  child: Text("Si"),
                                                                                                ),

                                                                                              ],
                                                                                            );
                                                                                          }
                                                                                      );
                                                                                    },
                                                                                    child: QrImage(
                                                                                      data: ofertaData[i]["id"],
                                                                                      size: MediaQuery
                                                                                          .of(context)
                                                                                          .size
                                                                                          .height,
                                                                                    ),
                                                                                  )
                                                                                // child: QrImage(
                                                                                //   data: oferta.docs[i].id,
                                                                                //   size: MediaQuery.of(context).size.height,
                                                                                // ),
                                                                              ),
                                                                              // SizedBox(
                                                                              //   width: 30,
                                                                              // ),
                                                                              Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: <Widget>[
                                                                                    SizedBox(
                                                                                      height: 40,
                                                                                      width: 200,
                                                                                      child: Card(
                                                                                        color: Color(0xff87b3ed),
                                                                                        elevation: 10,
                                                                                        child: Text(
                                                                                          ofertaData[i]["nombre"],
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                              fontSize: 20,
                                                                                              color: Colors
                                                                                                  .black54),
                                                                                        ),
                                                                                      ),
                                                                                    ),


                                                                                    SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 40,
                                                                                      width: 200,
                                                                                      child: Card(
                                                                                        color: Color(0xff87b3ed),
                                                                                        elevation: 10,
                                                                                        child: Text(
                                                                                          "GTQ ${ofertaData[i]["valor"]}",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                              fontSize: 20,
                                                                                              color: Colors
                                                                                                  .black54),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],

                                                                    ),
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
                                                      color: Colors.black12
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
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
                                                            zoomGesturesEnabled: true,
                                                            markers: markersMap,
                                                            onMapCreated: onMapCreated,
                                                            initialCameraPosition: CameraPosition(
                                                              target: LatLng(
                                                                  inlat, inlng),
                                                              zoom: 12,
                                                            ),
                                                            myLocationButtonEnabled: false,
                                                            zoomControlsEnabled: true,
                                                          ),
                                                        ),

                                                      ]
                                                  ),
                                                ),

                                              ),
                                              SizedBox(height: 50),
                                              Container(

                                                // padding: EdgeInsets
                                                //     .symmetric(
                                                //     horizontal: 10),
                                                // width: MediaQuery
                                                //     .of(context)
                                                //     .size
                                                //     .width * 0.9,
                                                // height: 500,
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
                                                  child:Wrap(
                                                    // shrinkWrap: true,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                        height: 640,
                                                        child: PageView.builder(
                                                          itemCount: sucursalesList.length,
                                                          controller: PageController(viewportFraction: 0.9),
                                                          onPageChanged: (
                                                          int index) =>
                                                          setState(() =>
                                                          idx = index),
                                                          itemBuilder: (_, i) {
                                                            print(sucursalesList[i]['id']);
                                                            return updateSucursal(sucursalesList[i]['id']);
                                                          }
                                                          ),
                                                        ),

                                                        // DropdownButton<String>(
                                                        //   hint: new Text("Seleccionar Sucursal"),
                                                        //   value: sucursal,
                                                        //   onChanged: (String newStore){
                                                        //     setState(() {
                                                        //       sucursalid = newStore;
                                                        //       // sucursal=newStore;
                                                        //       // sucursalid = sucursalNombre;
                                                        //     });
                                                        //
                                                        //     // print("sucursal ${sucursalNombre}");
                                                        //
                                                        //   },
                                                        //   items: sucursalesList.map((sucursal){
                                                        //     return new DropdownMenuItem(
                                                        //       child: new Text(sucursal['nombre']),
                                                        //       value: sucursal['id'].toString(),
                                                        //     );
                                                        //   }
                                                        //
                                                        //   ).toList(),
                                                        //
                                                        // ),
                                                        // if(!(sucursalid == null||sucursalid=="")) updateSucursal(sucursalid),


                                                      ]
                                                  ),

                                                ),

                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 45),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                                  // width: 400,
                                                  height: 60,
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
                                                        offset: Offset(0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[

                                                      Container(

                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(

                                                          borderRadius: new BorderRadius.all(
                                                            const Radius.circular(
                                                                10),
                                                          ),
                                                          // color: Color(0xff055475),
                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/ig.png"),
                                                            fit: BoxFit.fill,

                                                          ),
                                                        ),


                                                        child: InkWell(
                                                          onTap: (){

                                                            launchApp(data["instagram"]);
                                                          },

                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(

                                                          borderRadius: new BorderRadius.all(
                                                            const Radius.circular(
                                                                10),

                                                          ),
                                                          // color: Color(0xff055475),
                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/fb.png"),
                                                            fit: BoxFit.fill,

                                                          ),
                                                        ),


                                                        child: InkWell(
                                                          onTap: (){

                                                            launchApp(data["facebook"]);
                                                          },

                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(

                                                          borderRadius: new BorderRadius.all(
                                                            const Radius.circular(
                                                                10),

                                                          ),
                                                          // color: Color(0xff055475),
                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/tw.png"),
                                                            fit: BoxFit.fitHeight,

                                                          ),
                                                        ),


                                                        child: InkWell(
                                                          onTap: (){

                                                            launchApp(data["twitter"]);
                                                          },

                                                        ),
                                                      ),
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
                              ),

                            );


                          });

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


