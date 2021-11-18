// @dart=2.9

import 'dart:async';
import 'dart:math' as math; // import this
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cliente/src/main/gustoAdder.dart';
import 'package:cliente/src/main/calificar/calificarCompra.dart';
import 'package:cliente/src/main/gustos/gustosMenu.dart';
import 'package:cliente/src/main/negocio/negocioPage.dart';
import 'package:cliente/src/main/search/searchMenuTest.dart';
import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/main/suscripciones/ratingSub.dart';
import 'package:cliente/src/main/suscripciones/suscripcionMenu.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/main/gustos/gustosUsuario.dart';
import 'package:cliente/src/services/firestoreStart.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/usuario.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../main.dart';


class MainMenu extends StatefulWidget {
MainMenu({Key key, this.title, /*required this.uid*/}) : super(key: key);


  final String title;

@override
MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> with TickerProviderStateMixin{

  getToken(String user) async {
    String token = await FirebaseMessaging.instance.getToken();
    print(token);

    if(token!=null){
      var tokenRef = FirebaseFirestore.instance.collection("usuario").doc(user).update(
          {
            'token': token,
          });
    }

  }
  String docuid='';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final controller = DragSelectGridViewController();
  TabController _controller;
  int _currentPage = 0;

  FirebaseApp businessApp = Firebase.app('businessApp');

  // FirebaseFunctions functions = FirebaseFunctions.instanceFor(app: Firebase.app('businessApp')).;
  FirebaseMessaging message = FirebaseMessaging.instance;


  final pagecontroller = PageController();

  InfinityPageController _pageController = InfinityPageController(
    initialPage: 0,
  );

  static List<String> finalTagList = [];
  static List<String> finalOfertasList = [];

  List<String> selectedTags = [];


  bool addTags = false;
  bool inLogin = false;
  var ofertaData = [];
  var oferList = [];


  var listaRecRating = [];
  var finalList = [];
  var allTags =[];


  @override
  void initState(){
    super.initState();

    // fetchOfertas();


    _controller = TabController(length: ofertaData.length, vsync: this);
    controller.addListener(rebuild);
    Timer.periodic(Duration(seconds: 7), (Timer timer) {

      if(ofertaData.length==0){
        _currentPage = 0;
      }else{
        if (_currentPage < ofertaData.length) {
          _currentPage++;
          // print(_currentPage);
        } else {
          _currentPage = 0;
        }
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });






    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,

            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blueAccent,

                playSound: true,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    // getToken();
  }

  void showNotification(){

  }



  @override
  void dispose(){
    controller.removeListener(rebuild);
    super.dispose();
  }


  void _incrementCounter(int ind) {
    setState(() {
      _controller.index = ind;
    });
  }

  void rebuild() => setState((){});

  Icon subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  Icon favIcon = new Icon(Icons.favorite_border, color: Color(0xff108aa6));
  // get formKey => null;
  changeIconSub(){
    subscribeIcon = new Icon(Icons.check_rounded, color: Colors.green,);
    // subscribeIcon = new
  }

  changeIconUnSub(){
    subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  }

  changeIconFav(){
    favIcon = new Icon(Icons.favorite, color: Color(0xff108aa6));
  }


  Widget background(){

    // oferList.add({
    //   "autor": "hola",
    //   "text": "hi",
    //
    // });
    // print(oferList);
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
  // 0xcf6397ff
  //menu de abajo
  void settings(String user){
    showModalBottomSheet(
        context: context,
        builder: (context){
      return Container(
        height: 200,
        margin: new EdgeInsets.only(
          top: 20,
          left: 0,
          right: 0,
            ),
        padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20
        ),
        decoration: BoxDecoration(
            // border: Border(
            //   top: BorderSide(
            //     color: Colors.white,
            //     width: 10,
            //   ),
            //   left: BorderSide(
            //       color: Colors.white,
            //       width: 10,
            //   ),
            //   right: BorderSide(
            //     color: Colors.white,
            //     width: 10,
            //   ),
            // ),
            //
            // border: Border.all(color: Colors.white),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
            color: Color(0xb000528E),

        ),
        // child: Center(
          child:
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('usuario').doc(user).snapshots(),
            builder: (context, snapUser) {

              var userData = snapUser.data;

              return Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: Card(
                      color: Color(0xd000528E),
                      child: ListTile(
                        leading: Icon(Icons.account_circle_outlined, color: Colors.white,),
                        title: Text(userData.get("username"), textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    ),

                  ),
                  Container(
                    child: Card(
                      color: Color(0xd000528E),
                      child: ListTile(
                        leading: Icon(Icons.settings, color: Colors.white,),
                        title: Text('Ajustes', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),

                      ),
                    ),

                  ),
                ],
              );
            }
          ),


        // ),
      );
    });
  }

  //drawer izquierdo
  Widget drawerPrincipal(){
    return Theme(data: Theme.of(context).copyWith(
        canvasColor: Color(0xefedeff5),
      ),

      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff2C73D2),Color(0x00edeff5) ],
              ),
            ),
            child: Row(
              children: <Widget>[
                // Text(
                //   'OFER',
                //   style: GoogleFonts.oswald(
                //     textStyle: Theme.of(context).textTheme.headline4,
                //     fontSize: 40,
                //     fontWeight: FontWeight.w700,
                //     color: Color(0xffFFC75F),
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      'OFER',
                      style: GoogleFonts.oswald(
                        foreground:  Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black54,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,

                      ),
                      // textAlign: TextAlign.center,
                    ),
                    // Solid text as fill.
                    Text(
                      'OFER',
                      style: GoogleFonts.oswald(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffFFC75F),
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      'PLUS',
                      style: GoogleFonts.oswald(
                        foreground:  Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black54,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,

                      ),
                    //   // textAlign: TextAlign.center,
                    ),
                    // Solid text as fill.
                    Text(
                      'PLUS',
                      style: GoogleFonts.oswald(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffFFFFFF),
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ],
                ),
                // Text(
                //   'PLUS',
                //   style: GoogleFonts.oswald(
                //     textStyle: Theme.of(context).textTheme.headline4,
                //     fontSize: 40,
                //     fontWeight: FontWeight.w700,
                //     color: Colors.white,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          ),

          Container(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            color: Color(0xcaFF9671),
              child: ListTile(
                title: Text('Suscripciones', style: TextStyle(color: Colors.white, fontSize: 20),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SuscripcionMenu()));
                },
              ),
            ),
          ),
          Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),

              color: Color(0xcaffd17d),
              child: ListTile(
                title: Text('Gustos', style: TextStyle(color: Colors.white, fontSize: 20),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GustosMenu()));
                },
              ),
            ),
          ),

          Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),

              color: Color(0xca63c4ff),
              child: ListTile(
                 title: Text('Calificar Compras', style: TextStyle(color: Colors.white, fontSize: 20),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CalificarCompra()));
                },
                  ),
            ),
          ),
          Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),

              color: Color(0xca48e06c),
              child: ListTile(
                    title: Text('Puntos', style: TextStyle(color: Colors.white, fontSize: 20),),

                ),
              ),
            ),
          ],
        )
      ),
    );
  }


  void gustosVerify(context) async {
    RegExp expGusto = new RegExp(r"({gusto: )|(})");

    final user = Provider.of<Usuario>(context);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').get();

    listaRecRating = snapshot.docs.map((doc) {
      String gustos = doc.data().toString().replaceAll(expGusto, '');
      return gustos;
    }).toList();
    // print(listaRecRating);
  }


  Widget buildListRec(QuerySnapshot snapshot1, QuerySnapshot snapshot2, String uid){
    final user = Provider.of<Usuario>(context);
    var listaFiltro = [];
    // print(snapshot2.size);
    for(int i = 0; i < snapshot1.size; i++){
      // print(snapshot1.docs[i].id);
      for(int j = 0; j < snapshot2.size; j++){
        // print(snapshot2.docs[j]["gusto"]);
        if(snapshot2.docs[j]["gusto"]==snapshot1.docs[i]["type"]){
          // print(snapshot1.docs[i]["type"]);
          listaFiltro.add(snapshot1.docs[i]["type"]);
        }
      }

    }


    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //    Container(
    //      height: 30,
    //      width: 100,
    //      decoration: BoxDecoration(
    //        color: Color(0xff108aa6),
    //        borderRadius: new BorderRadius.all(
    //          Radius.circular(10),
    //
    //        ),
    //        boxShadow: [
    //          BoxShadow(
    //            color: Colors.black26
    //                .withOpacity(0.5),
    //            spreadRadius: 5,
    //            blurRadius: 7,
    //            offset: Offset(0,
    //                3), // changes position of shadow
    //          ),
    //        ],
    //      ),
    //    ),
    //     ListView.builder(
    //         itemCount: snapshot1.docs.length,
    //         // ignore: missing_return
    //         itemBuilder: (context, index){
    //           final doc = snapshot1.docs[index];
    //           final double num = doc["defaultRating"]+0.0;
    //           if(listaFiltro.isNotEmpty){
    //             if(listaFiltro.contains(doc["type"])){
    //               return new InkWell(
    //                   onTap: ()  {
    //                     Navigator.push(
    //                         context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id,)));
    //                   },
    //
    //                   child: Container(
    //                     height: 100,
    //                     decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: new BorderRadius.all(Radius.circular(10))
    //
    //                     ),
    //
    //                     margin: EdgeInsets.all(10),
    //
    //                     child: Row(
    //                       children: <Widget>[
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         Container(
    //                           padding: EdgeInsets.all(10),
    //                           width: 170,
    //                           // color: Colors.amber,
    //                           alignment: Alignment.topLeft,
    //                           child: Text(
    //                             doc["nombre"],
    //                             // textAlign: TextAlign.center,
    //                             style: TextStyle(fontSize: 22),
    //                           ),
    //                         ),
    //                         Column(
    //                           children: <Widget>[
    //                             SizedBox(
    //                               height: 20,
    //                             ),
    //                             RatingBarIndicator(
    //                               rating: num,
    //                               itemBuilder: (context, index) => Icon(
    //                                 Icons.star,
    //                                 color: Colors.amber,
    //                               ),
    //                               itemCount: 5,
    //                               itemSize: 20,
    //                               itemPadding: EdgeInsets.all(1),
    //                             ),
    //                             SizedBox(
    //                               height: 20,
    //                               child: Text("votos ${doc["voteCount"]}",style: TextStyle(color: Colors.grey),),
    //                             ),
    //
    //                           ],
    //                         ),
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         Container(
    //                           // color: Colors.red,
    //                             child: Material(
    //                               color: Colors.transparent,
    //                               child: Center(
    //                                 child: Ink(
    //                                   decoration: BoxDecoration(
    //                                     color: Color(0xff108aa6),
    //                                     borderRadius: new BorderRadius.all(
    //                                       Radius.circular(10),
    //
    //                                     ),
    //                                   ),
    //                                   child: IconButton(
    //
    //                                     onPressed: (){
    //                                       print(doc.id);
    //                                       final int voteC = doc["voteCount"]+1;
    //                                       final bool vote = true;
    //                                       DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
    //                                       // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);
    //                                       setState(() {
    //                                         // changeIcon();
    //
    //                                       });
    //                                       ScaffoldMessenger.of(context)
    //                                           .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
    //                                     },
    //                                     icon: Icon(Icons.add, color: Colors.white,),
    //                                   ),
    //                                 ),
    //                               ),
    //                             )),
    //                       ],
    //                     ),
    //                   )
    //               );
    //             }
    //           }
    //           else{
    //             return new InkWell(
    //                 onTap: ()  {
    //                   Navigator.push(
    //                       context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id,)));
    //                   // context, MaterialPageRoute(builder: (context) => RatingSub()));
    //                 },
    //
    //                 child: Container(
    //                   height: 100,
    //                   decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: new BorderRadius.all(Radius.circular(10))
    //
    //                   ),
    //
    //                   margin: EdgeInsets.all(10),
    //
    //                   child: Row(
    //                     children: <Widget>[
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.all(10),
    //                         width: 170,
    //                         // color: Colors.amber,
    //                         alignment: Alignment.topLeft,
    //                         child: Text(
    //                           doc["nombre"],
    //                           // textAlign: TextAlign.center,
    //                           style: TextStyle(fontSize: 22),
    //                         ),
    //                       ),
    //                       Column(
    //                         children: <Widget>[
    //                           SizedBox(
    //                             height: 20,
    //                           ),
    //                           RatingBarIndicator(
    //                             rating: num,
    //                             itemBuilder: (context, index) => Icon(
    //                               Icons.star,
    //                               color: Colors.amber,
    //                             ),
    //                             itemCount: 5,
    //                             itemSize: 20,
    //                             itemPadding: EdgeInsets.all(1),
    //                           ),
    //                           SizedBox(
    //                             height: 20,
    //                             child: Text("votos ${doc["voteCount"]}",style: TextStyle(color: Colors.grey),),
    //                           ),
    //
    //                         ],
    //                       ),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Container(
    //                         // color: Colors.red,
    //                           child: Material(
    //                             color: Colors.transparent,
    //                             child: Center(
    //                               child: Ink(
    //                                 decoration: BoxDecoration(
    //                                   color: Color(0xff108aa6),
    //                                   borderRadius: new BorderRadius.all(
    //                                     Radius.circular(10),
    //
    //                                   ),
    //                                 ),
    //                                 child: IconButton(
    //
    //                                   onPressed: (){
    //                                     print(doc.id);
    //                                     final int voteC = doc["voteCount"]+1;
    //                                     // ignore: missing_return
    //                                     final bool vote = true;
    //                                     DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
    //                                     // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);
    //                                     setState(() {
    //                                       // changeIcon();
    //
    //                                     });
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
    //                                   },
    //                                   icon: Icon(Icons.add, color: Colors.white,),
    //                                 ),
    //                               ),
    //                             ),
    //                           )),
    //
    //
    //                     ],
    //                   ),
    //                 )
    //             );
    //           }
    //
    //         }
    //
    //     ),
    //
    //   ],
    // );
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('suscripciones').snapshots(),
        builder: (context, snapshotSus) {
          var sus = snapshotSus.data;


          return SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: snapshot1.docs.length,
                // ignore: missing_return
                itemBuilder: (context, index){
                  bool issub = false;
                  // print(snapshot1.docs[index].id);
                  // print(sus.docs.length);

                  if(sus.docs.length==1){
                    // print(sus.docs[0].id);
                    if (sus.docs[0].id == snapshot1.docs[index].id) {
                      // print(sus.docs[0].id);
                      issub = true;
                      changeIconSub();
                    }
                  }else if (sus.docs.length>1){
                    for (int j = 0; j < snapshot2.docs.length; j++) {
                      if (sus.docs[j].id == snapshot1.docs[index].id) {
                        issub = true;
                        changeIconSub();
                      }
                    }
                  }else{
                    issub = false;
                  }

                  final doc = snapshot1.docs[index];
                  final double num = doc["defaultRating"] +0.0;
                  if(listaFiltro.isNotEmpty){
                    if(listaFiltro.contains(doc["type"])){

                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.all(Radius.circular(10))

                        ),

                        margin: EdgeInsets.all(10),

                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                              child: Icon(FontAwesome.beer),
                            ),
                            InkWell(
                              onTap: ()  {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id)));
                              },

                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: 170,
                                // color: Colors.amber,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  doc["nombre"],
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),



                                RatingBarIndicator(
                                  rating: num,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding: EdgeInsets.all(1),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Text("votos ${doc["voteCount"]}",style: TextStyle(color: Colors.grey),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              // color: Colors.red,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Color(0xff2C73D2),
                                        borderRadius: new BorderRadius.all(
                                          Radius.circular(10),

                                        ),
                                      ),
                                      child: IconButton(

                                        onPressed: () {



                                          if (issub) {
                                            bool vote = false;
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
                                                          FirebaseMessaging.instance.unsubscribeFromTopic(doc.id);
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'usuario')
                                                              .doc(user.uid)
                                                              .collection(
                                                              'suscripciones')
                                                              .doc(
                                                              doc.id)
                                                              .delete();
                                                          BusinessDatabaseConnect()
                                                              .subEmpresa(
                                                              doc.id, vote);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger
                                                              .of(context)
                                                              .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Suscripción a ${doc['nombre']} Eliminada')));
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
                                          }
                                          else {

                                            int vote = 0;
                                            bool subvote = true;
                                            FirebaseMessaging.instance.subscribeToTopic(doc.id);
                                            print("subscribed to topic ${doc.id}");
                                            DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, vote, doc.id);
                                            BusinessDatabaseConnect()
                                                .subEmpresa(doc.id, subvote);
                                            setState(() {
                                              changeIconUnSub();
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Suscrito a ${doc['nombre']}')));
                                          }





                                          // print(doc.id);

                                          // DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                                          // // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);

                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                                        },
                                        icon: Icon(issub
                                      ? Icons.check_rounded
                                          : Icons.add),
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                )),



                          ],
                        ),

                      );


                      // return new InkWell(
                      //     onTap: ()  {
                      //       Navigator.push(
                      //           context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id,)));
                      //     },
                      //
                      //     child: Container(
                      //       height: 100,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: new BorderRadius.all(Radius.circular(10))
                      //
                      //       ),
                      //
                      //       margin: EdgeInsets.all(10),
                      //
                      //       child: Row(
                      //         children: <Widget>[
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Container(
                      //             padding: EdgeInsets.all(10),
                      //             width: 170,
                      //             // color: Colors.amber,
                      //             alignment: Alignment.topLeft,
                      //             child: Text(
                      //               doc["nombre"],
                      //               // textAlign: TextAlign.center,
                      //               style: TextStyle(fontSize: 22),
                      //             ),
                      //           ),
                      //           Column(
                      //             children: <Widget>[
                      //               SizedBox(
                      //                 height: 20,
                      //               ),
                      //               RatingBarIndicator(
                      //                 rating: num,
                      //                 itemBuilder: (context, index) => Icon(
                      //                   Icons.star,
                      //                   color: Colors.amber,
                      //                 ),
                      //                 itemCount: 5,
                      //                 itemSize: 20,
                      //                 itemPadding: EdgeInsets.all(1),
                      //               ),
                      //               SizedBox(
                      //                 height: 20,
                      //                 child: Text("votos ${doc["voteCount"]}",style: TextStyle(color: Colors.grey),),
                      //               ),
                      //
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Container(
                      //             // color: Colors.red,
                      //               child: Material(
                      //                 color: Colors.transparent,
                      //                 child: Center(
                      //                   child: Ink(
                      //                     decoration: BoxDecoration(
                      //                       color: Color(0xff108aa6),
                      //                       borderRadius: new BorderRadius.all(
                      //                         Radius.circular(10),
                      //
                      //                       ),
                      //                     ),
                      //                     child: IconButton(
                      //
                      //                       onPressed: (){
                      //                         print(doc.id);
                      //                         final int voteC = doc["voteCount"]+1;
                      //                         final bool vote = true;
                      //                         DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                      //                         // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);
                      //                         setState(() {
                      //                           // changeIcon();
                      //
                      //                         });
                      //                         ScaffoldMessenger.of(context)
                      //                             .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                      //                       },
                      //                       icon: Icon(Icons.add, color: Colors.white,),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               )),
                      //         ],
                      //       ),
                      //     )
                      // );
                    }
                  }
                  else{
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(Radius.circular(10))

                      ),

                      margin: EdgeInsets.all(10),

                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                            // child: Icon(Ionicons.ios_beer,color: Colors.deepPurpleAccent,),
                          ),
                          InkWell(
                            onTap: ()  {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id)));
                            },

                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 170,
                              // color: Colors.amber,
                              alignment: Alignment.topLeft,
                              child: Text(
                                doc["nombre"],
                                // textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),



                              RatingBarIndicator(
                                rating: num,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding: EdgeInsets.all(1),
                              ),
                              SizedBox(
                                height: 20,
                                child: Text("votos ${doc["voteCount"]}",style: TextStyle(color: Colors.grey),),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            // color: Colors.red,
                              child: Material(
                                color: Colors.transparent,
                                child: Center(
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2C73D2),
                                      borderRadius: new BorderRadius.all(
                                        Radius.circular(10),

                                      ),
                                    ),
                                    child: IconButton(

                                      onPressed: (){



                                        if (issub) {
                                          bool vote = false;
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
                                                        FirebaseMessaging.instance.unsubscribeFromTopic(doc.id);
                                                        // FirebaseMessaging.instance.unsubscribeFromTopic("ofertas");

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                            'usuario')
                                                            .doc(user.uid)
                                                            .collection(
                                                            'suscripciones')
                                                            .doc(
                                                            doc.id)
                                                            .delete();
                                                        BusinessDatabaseConnect()
                                                            .subEmpresa(
                                                            doc.id, vote);
                                                        Navigator.pop(
                                                            context);
                                                        ScaffoldMessenger
                                                            .of(context)
                                                            .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'Suscripción a ${doc['nombre']} Eliminada')));
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
                                        }
                                        else {

                                          int vote = 0;
                                          bool subvote = true;
                                          FirebaseMessaging.instance.subscribeToTopic(doc.id);
                                          // FirebaseMessaging.instance.subscribeToTopic("ofertas");
                                          print("subscribed to topic ${doc.id}");
                                          DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, vote, doc.id);
                                          BusinessDatabaseConnect()
                                              .subEmpresa(doc.id, subvote);
                                          setState(() {
                                            changeIconUnSub();
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Suscrito a ${doc['nombre']}')));
                                        }





                                        // print(doc.id);

                                        // DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                                        // // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);

                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                                      },
                                      icon: Icon(issub
                                          ? Icons.check_rounded
                                          : Icons.add),
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              )),



                        ],
                      ),

                    );
                    // return new InkWell(
                    //     onTap: ()  {
                    //       Navigator.push(
                    //           context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id,)));
                    //       // context, MaterialPageRoute(builder: (context) => RatingSub()));
                    //     },
                    //
                    //     child: Container(
                    //       height: 100,
                    //       decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: new BorderRadius.all(Radius.circular(10))
                    //
                    //       ),
                    //
                    //       margin: EdgeInsets.all(10),
                    //
                    //       child: Row(
                    //         children: <Widget>[
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Container(
                    //             padding: EdgeInsets.all(10),
                    //             width: 170,
                    //             // color: Colors.amber,
                    //             alignment: Alignment.topLeft,
                    //             child: Text(
                    //               doc["nombre"],
                    //               // textAlign: TextAlign.center,
                    //               style: TextStyle(fontSize: 22),
                    //             ),
                    //           ),
                    //           Column(
                    //             children: <Widget>[
                    //               SizedBox(
                    //                 height: 20,
                    //               ),
                    //               RatingBarIndicator(
                    //                 rating: num,
                    //                 itemBuilder: (context, index) => Icon(
                    //                   Icons.star,
                    //                   color: Colors.amber,
                    //                 ),
                    //                 itemCount: 5,
                    //                 itemSize: 20,
                    //                 itemPadding: EdgeInsets.all(1),
                    //               ),
                    //               SizedBox(
                    //                 height: 20,
                    //                 child: Text("votos ${doc["voteCount"]}",style: TextStyle(color: Colors.grey),),
                    //               ),
                    //
                    //             ],
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Container(
                    //             // color: Colors.red,
                    //               child: Material(
                    //                 color: Colors.transparent,
                    //                 child: Center(
                    //                   child: Ink(
                    //                     decoration: BoxDecoration(
                    //                       color: Color(0xff108aa6),
                    //                       borderRadius: new BorderRadius.all(
                    //                         Radius.circular(10),
                    //
                    //                       ),
                    //                     ),
                    //                     child: IconButton(
                    //
                    //                       onPressed: (){
                    //                         print(doc.id);
                    //                         final int voteC = doc["voteCount"]+1;
                    //                         // ignore: missing_return
                    //                         final bool vote = true;
                    //                         DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                    //                         // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);
                    //                         setState(() {
                    //                           // changeIcon();
                    //
                    //                         });
                    //                         ScaffoldMessenger.of(context)
                    //                             .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                    //                       },
                    //                       icon: Icon(Icons.add, color: Colors.white,),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )),
                    //
                    //
                    //         ],
                    //       ),
                    //     )
                    // );
                  }

                }

            ),
          );
        });





  }


  fetchOfertas() async {
    List listaEmpresas = await FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('ofertas').get().then((value) => value.docs);
    for(int i=0;i<listaEmpresas.length;i++){
      // print(listaEmpresas[i].id);
      FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection("ofertas").doc(
          listaEmpresas[i].id.toString()
      ).collection("ofertas").snapshots().listen((event) {

        ofertaData = event.docs.map((e) => {
          "pageid": listaEmpresas[i].id.toString(),
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
        // print(ofertaData);
        // oferList=ofertaData;
      });
    }
  }


  fetchGustos() async {
    List listaEmpresas = await FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').get().then((value) => value.docs);
    for(int i=0;i<listaEmpresas.length;i++){
      FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection("empresa").doc(
          listaEmpresas[i].id.toString()
      ).collection("etiquetas").snapshots().listen((CreateListTags));
    }
  }

  CreateListTags(QuerySnapshot snapshot) async{
    var docs = snapshot.docs;
    for(var doc in docs){
      finalTagList.add(doc.get("etiquetas"));
    }

    // print("tags ${finalTagList}");
  }

  showAlert(BuildContext context, String user, int sizeTags) async {
    final isSelected = controller.value.isSelecting;
    var text = "";

    fetchGustos();
    var gridList = finalTagList.toSet().toList();

    final items = gridList.map((e) => MultiSelectItem(e, e)).toList();

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context)
      {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[

                // Container(
                //   width: double.infinity,
                //   height: 400,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: Colors.white
                //   ),
                //   padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                //   child: Text("Seleccionar gustos iniciales",
                //       style: TextStyle(fontSize: 24),
                //       textAlign: TextAlign.center
                //   ),
                // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(
                        height: 100,

                      ),
                      MultiSelectChipField(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0xff108aa6), width: 1.8),
                          color: Color(0xefdae3f7),
                        ),
                        items: items,
                        title: Text("Seleccionar 3 gustos iniciales :", style:TextStyle(color: Colors.white, fontSize: 20),),
                        headerColor: Color(0xff108aa6),
                        textStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                        chipColor: Color(0xff6c80a3),
                        chipShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        selectedChipColor: Color(0xcf008da6),
                        selectedTextStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                        onTap: (values){
                          selectedTags = values;
                          // print(values);
                        },

                      ),
                      // Container(
                      //   height: 300,
                      //   padding: EdgeInsets.symmetric(vertical: 50),
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child:
                      //   ),
                      //
                      //
                      // ),
                      ElevatedButton(
                        onPressed: (){
                          if(selectedTags.length<3&&sizeTags==2){
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Seleccionar por lo menos 3 gustos')));

                          }else{
                          selectedTags.forEach((element) {
                            DatabaseConnect(uid: user).agregarGustos(element);
                            
                          });

                          Navigator.of(context).popUntil((route) {
                            return route.settings.name ==
                                'mainMenu';
                          });



                          }
                        },
                        child: Text("agregar"),
                      ),
                      Text(text, style: TextStyle(color: Colors.red, fontSize: 14)),
                    ],
                  ),




              ],
            )
        );
      });
  }
  showAlertPop(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          // Navigator.of(context).popUntil((route) {
          //   return route.settings.name ==
          //       'mainMenu';
          // });
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                setState(() {
                  inLogin = true;
                });
                  Navigator.of(context).popUntil((route) {
                    return route.settings.name == 'mainMenu';});
                },
              child: Text("CONTINUAR"),
            ),
          );
        });
  }

  Widget buildListGus(String user, QuerySnapshot oferta, QuerySnapshot docGus){
    var gridList = finalTagList.toSet().toList();



    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: background(),
        ),
        Column(
          children: <Widget>[

            FutureBuilder<Widget>(
              future: showOfertas(context, oferta, user),
              builder: (context,AsyncSnapshot<Widget> snapshot){

                if(snapshot.hasData)
                  return snapshot.data;

                return Container(child: CircularProgressIndicator(),);
              },


            ),
            SizedBox(
              height: 40,

            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: gridList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // final empresa = GustosUser.fromSnapshot(empresas[index]);
                    // totalGustos.add(empresa.name);
                    bool istag = false;


                    for(int k = 0; k < docGus.docs.length;k++){
                      if(docGus.docs[k]["gusto"]==gridList[index]){
                        istag = true;

                      }
                    }
                    return  new Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Card(
                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                          child: ListTile(
                            title: Text(
                              gridList[index],
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(

                              onPressed: () {



                                if (istag) {
                                  bool vote = false;
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          elevation: 24,
                                          title: Text(
                                              "¿Quieres quitar tu gusto?"
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
                                                FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                    'usuario')
                                                    .doc(user)
                                                    .collection(
                                                    'gustos')
                                                    .doc(
                                                    gridList[index])
                                                    .delete();
                                                // BusinessDatabaseConnect()
                                                //     .voteEmpresa(
                                                //     pageid, vote);
                                                Navigator.pop(
                                                    context);
                                                ScaffoldMessenger
                                                    .of(context)
                                                    .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Gusto ${gridList[index]} Eliminado')));
                                              },
                                              child: Text("Si"),
                                            ),

                                          ],
                                        );
                                      }
                                  );

                                  setState(() {
                                    istag = false;
                                  });
                                }
                                else {

                                  int vote = 0;
                                  DatabaseConnect(uid: user).agregarGustos(gridList[index]);
                                  // BusinessDatabaseConnect()
                                  //     .voteEmpresa(pageid, vote);
                                  setState(() {
                                    // changeIconUnSub();
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                          'Gusto ${gridList[index]} agregado')));
                                }





                                // print(doc.id);

                                // DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                                // // BusinessDatabaseConnect().voteEmpresa(doc.id, vote);

                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                              },
                              icon: Icon(istag
                                  ? Icons.check_rounded
                                  : Icons.add),
                              color: Color(0xff2C73D2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }


              ),

            ),
          ],
        ),

      ],
    );


  }

  Future<Widget> showOfertas(BuildContext context, QuerySnapshot snapoferta, String user) async{

    if(ofertaData.isEmpty){
      fetchOfertas();
    }


    var ofer = ofertaData.toSet().toList();
    // print(ofer.length);
    // var ofertas = finalOfertasList.toSet().toList();
    int idx = 0;

    // rebuild();

    for(int k = 0;k<ofer.length;k++){
      if(ofer[k]["estado"]=="activo"){
        for(int m=0;m<snapoferta.size;m++){

          if(snapoferta.docs[m]["ofertaID"]==ofer[k]["id"]){

            if((snapoferta.docs[m]["limite"]==0)||(snapoferta.docs[m]["estado"]==false)){
              // print("USUARIO ${snapoferta.docs[m]["ofertaID"]}");
              // print("OFERTAS ${ofer[k]["id"]}");
              // DatabaseConnect(
              //     uid: user)
              //     .likeOferta(
              //     snapoferta.docs[m]["ofertaID"],true,true,false,snapoferta.docs[m]["limite"]);
              ofer.removeAt(k);
              ofertaData.removeAt(k);

            }
          }

        }
      }else{

        for(int m=0;m<snapoferta.size;m++) {
          if (snapoferta.docs[m]["ofertaID"] == ofer[k]["id"]) {
            DatabaseConnect(
                  uid: user)
                  .likeOferta(
                  snapoferta.docs[m]["ofertaID"],true,false,false,snapoferta.docs[m]["limite"]);


          }
        }
      }




    }

    // print(ofer.length);

    return SizedBox(
      height: 200,
      child: InfinityPageView(
          itemCount: ofer.length,
          controller: _pageController,
          onPageChanged: (int index) {

            setState(() {
              idx = index;
              _incrementCounter(index);
            });


          },

          itemBuilder: (_, i) {
            // print("LENGTH ${ofertaData.length}");// print(i);
            bool isfav = false;
            if(snapoferta.size == 0){

                isfav = false;
                changeIconFav();

            }
            else{
              for (int j = 0; j < snapoferta.size; j++) {
                if(ofer.length==0){
                    isfav = false;
                    changeIconFav();

                }else{
                  if (snapoferta.docs[j]["ofertaID"] == ofer[i]["id"]) {
                    isfav = true;
                    changeIconFav();
                  }
                }

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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    // height: 50,
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
                      image: imagePick(ofer[i]["urlImage"]),


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
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,

                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius
                                    .all(Radius
                                    .circular(12)),
                                color: Colors.white,
                              ),

                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment
                                        .center,
                                    child: IconButton(
                                      iconSize: 30,
                                      onPressed: () {
                                        if (isfav) {
                                          bool vote = false;
                                          setState(() {
                                            isfav = false;
                                            FirebaseFirestore
                                                .instance
                                                .collection(
                                                'usuario')
                                                .doc(
                                                user)
                                                .collection(
                                                'ofertas')
                                                .doc(ofer[i]["id"])
                                                .delete();
                                            BusinessDatabaseConnect()
                                                .likeOferta(
                                                ofer[i]["pageid"],
                                                ofer[i]["id"],
                                                vote);
                                          });
                                        } else {
                                          bool vote = true;
                                          setState(() {
                                            isfav = true;
                                            DatabaseConnect(
                                                uid: user)
                                                .likeOferta(
                                                ofer[i]["id"],isfav,true,false,ofer[i]["limiteUsuario"]);
                                            BusinessDatabaseConnect()
                                                .likeOferta(
                                                ofer[i]["pageid"],
                                                ofer[i]["id"],
                                                vote);
                                            ScaffoldMessenger
                                                .of(context)
                                                .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Te gusta ${ofer[i]["nombre"]}')));
                                          });
                                        }
                                      },
                                      icon: Icon(isfav
                                          ? Icons.favorite
                                          : Icons
                                          .favorite_border),
                                      color: Color(
                                          0xff2C73D2),
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          // color: Colors.amber,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center,
                            // mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Container(
                                width: 200,
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
                                                    data: ofer[i]["id"],
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
                                                            ofer[i]["nombre"],
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
                                                            "GTQ ${ofer[i]["valor"]}",
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
                                                      uid: user)
                                                      .likeOferta(
                                                      ofer[i]["id"],isfav,true,true,ofer[i]["limiteUsuario"]);
                                                  BusinessDatabaseConnect()
                                                      .useOferta(
                                                      ofer[i]["pageid"],
                                                      ofer[i]["id"],
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
                                    data: ofer[i]["id"],
                                    size: MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                  ),
                                )
                                // child:
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .end,
                                  children: <Widget>[
                                    Text(
                                      ofer[i]["nombre"],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors
                                              .black54),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "GTQ ${ofer[i]["valor"]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors
                                              .black54),
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
    fetchOfertas();
    fetchGustos();
    final user = Provider.of<Usuario>(context);
    int idx = 0;

    FirestoreStart().connectFS2();

    getToken(user.uid);
    // gustosVerify(context);
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState.openDrawer(),
          icon: Icon(Icons.menu),
        ),



        actions: <Widget>[
          IconButton(
              onPressed: () async {
                // setState(() {
                  // tempSearchStore = [];
                // BusinessDatabaseConnect().getEmpresa();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMenuTest()));

          // return searchBar();
                // });


              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () => settings(user.uid),
              icon: Icon(Icons.more_horiz)
          ),
        ],
        centerTitle: false,
        // title: Text(
        //      "search",
        //       style: TextStyle(color: Colors.white),
        //       ),
        backgroundColor: Color(0xff2C73D2),
            ),

      drawer: drawerPrincipal(),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').snapshots(),
        builder: (context, snapshot2) {

          var dataGustos = snapshot2.data;


          // if (dataGustos.size < 3) {
          //   // // Future.delayed(Duration.zero, () => showAlert(context, user.uid, dataGustos.size));
          //   // Future.delayed(Duration.zero, () => Navigator.push(
          //   //     context, MaterialPageRoute(builder: (context) => GustosUsuario(uid: user.uid,list: finalTagList,totalGustos: dataGustos.size,))));
          //
          // }else if(!inLogin){
          //   Future.delayed(Duration.zero, () => showAlertPop(context));
          // }

          var ofer = ofertaData.toSet().toList();
          var ofertas = finalOfertasList.toSet().toList();
          int idx = 0;
          bool isfav = false;


          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('usuario').doc(
                  user.uid).collection("ofertas").snapshots(),

              builder: (context, snapoferta) {

                var oferta = snapoferta.data;
                // print(ofer.length);

                return PageView(
                  children: <Widget>[
                    Stack(
                fit: StackFit.expand,
                  children: <Widget>[
                    background(),


                    Column(

                      // shrinkWrap: true,
                      children: <Widget>[

                        FutureBuilder<Widget>(
                          future: showOfertas(context, oferta, user.uid),
                          builder: (context,AsyncSnapshot<Widget> snapshot){

                            if(snapshot.hasData)
                              return snapshot.data;

                            return Container(child: CircularProgressIndicator(),);
                          },


                        ),
                        // showOfertas(context,oferta,user.uid),
                        // SizedBox(
                        //   height: 180,
                        //   child: PageView.builder(
                        //       itemCount: ofer.length,
                        //       controller: PageController(/*viewportFraction: 0.9*/),
                        //       onPageChanged: (int index) =>
                        //           setState(() =>
                        //           idx = index),
                        //       itemBuilder: (_, i) {
                        //         for (int j = 0; j < snapoferta.data.size; j++) {
                        //           if (snapoferta.data.docs[j]["ofertaID"] == ofer[i]["id"]) {
                        //             isfav = true;
                        //             changeIconFav();
                        //           }
                        //         }
                        //         return Padding(
                        //           padding: EdgeInsets
                        //               .symmetric(
                        //               horizontal: 7),
                        //
                        //           child: FlipCard(
                        //             direction: FlipDirection.VERTICAL,
                        //             front: Card(
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius
                        //                     .all(Radius
                        //                     .circular(5)),
                        //               ),
                        //               child: Container(
                        //                 width: MediaQuery
                        //                     .of(context)
                        //                     .size
                        //                     .width,
                        //                 // height: 50,
                        //                 padding: EdgeInsets
                        //                     .symmetric(
                        //                     vertical: 20),
                        //                 alignment: Alignment
                        //                     .center,
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
                        //                       ofer[i]["urlImage"],
                        //                     ),
                        //                     fit: BoxFit.cover,),
                        //
                        //                 ),
                        //                 //     child: Stack(
                        //                 //       children: <Widget>[
                        //                 //         Container(
                        //                 //           // height: ,
                        //                 //           width: MediaQuery.of(context).size.width,
                        //                 //           // color: Colors.amber,
                        //                 //           child: Row(
                        //                 //             crossAxisAlignment: CrossAxisAlignment.center,
                        //                 //             // mainAxisAlignment: MainAxisAlignment.center,
                        //                 //
                        //                 //             children: <Widget>[
                        //                 //               Container(
                        //                 //                 width: 200,
                        //                 //                 // height: 100,
                        //                 //                 decoration: BoxDecoration(
                        //                 //                   borderRadius: BorderRadius
                        //                 //                       .all(Radius
                        //                 //                       .circular(
                        //                 //                       5)),
                        //                 //                   // boxShadow: <BoxShadow>[
                        //                 //                   //   BoxShadow(
                        //                 //                   //       color: Colors.black,
                        //                 //                   //       offset: Offset(0, 4),
                        //                 //                   //       blurRadius: 10,
                        //                 //                   //       spreadRadius: 2)
                        //                 //                   // ],
                        //                 //                   // border: Border.all(color: Colors.grey, width: 2),
                        //                 //                   image: DecorationImage(
                        //                 //                     image: NetworkImage(
                        //                 //                       oferta.docs[i]["urlImage"],
                        //                 //                       ),
                        //                 //                       fit: BoxFit.fill,),
                        //                 //
                        //                 //                   ),
                        //                 //                 ),
                        //                 //               SizedBox(
                        //                 //                 width: 30,
                        //                 //               ),
                        //                 //               Column(
                        //                 //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 //
                        //                 //                 children: <Widget>[
                        //                 //                   Text(
                        //                 //                     oferta.docs[i]["nombre"],
                        //                 //                     style: TextStyle(
                        //                 //                         fontSize: 20,
                        //                 //                         color: Colors
                        //                 //                             .white),
                        //                 //
                        //                 //
                        //                 //                     //AGREGAR SECCION DE RECOMENDACION GUSTOS, FILTRADO POR TAGS DE GUSTOS AGREGADOS
                        //                 //
                        //                 //
                        //                 //                   ),
                        //                 //                 ]
                        //                 //               ),
                        //                 //
                        //                 //             ],
                        //                 //           ),
                        //                 //         ),
                        //                 //   ],
                        //                 //
                        //                 // ),
                        //                 child: Stack(
                        //                   children: <Widget>[
                        //                     Container(
                        //                       padding: EdgeInsets.symmetric(
                        //                           horizontal: 5),
                        //                       child: Align(
                        //                         alignment: Alignment.bottomLeft,
                        //
                        //                         child: Container(
                        //                           height: 45,
                        //                           width: 45,
                        //                           decoration: BoxDecoration(
                        //                             borderRadius: BorderRadius
                        //                                 .all(Radius
                        //                                 .circular(12)),
                        //                             color: Colors.white,
                        //                           ),
                        //
                        //                           child: Stack(
                        //                             children: <Widget>[
                        //                               Align(
                        //                                 alignment: Alignment
                        //                                     .center,
                        //                                 child: IconButton(
                        //                                   iconSize: 30,
                        //                                   onPressed: () {
                        //                                     if (isfav) {
                        //                                       bool vote = false;
                        //                                       setState(() {
                        //                                         isfav = false;
                        //                                         FirebaseFirestore
                        //                                             .instance
                        //                                             .collection(
                        //                                             'usuario')
                        //                                             .doc(
                        //                                             user.uid)
                        //                                             .collection(
                        //                                             'ofertas')
                        //                                             .doc(ofer[i]["id"])
                        //                                             .delete();
                        //                                         BusinessDatabaseConnect()
                        //                                             .likeOferta(
                        //                                             ofer[i]["pageid"],
                        //                                             ofer[i]["id"],
                        //                                             vote);
                        //                                       });
                        //                                     } else {
                        //                                       bool vote = true;
                        //                                       setState(() {
                        //                                         isfav = true;
                        //                                         DatabaseConnect(
                        //                                             uid: user
                        //                                                 .uid)
                        //                                             .likeOferta(
                        //                                             ofer[i]["id"]);
                        //                                         BusinessDatabaseConnect()
                        //                                             .likeOferta(
                        //                                             ofer[i]["pageid"],
                        //                                             ofer[i]["id"],
                        //                                             vote);
                        //                                         ScaffoldMessenger
                        //                                             .of(context)
                        //                                             .showSnackBar(
                        //                                             SnackBar(
                        //                                                 content: Text(
                        //                                                     'Te gusta ${ofer[i]["nombre"]}')));
                        //                                       });
                        //                                     }
                        //                                   },
                        //                                   icon: Icon(isfav
                        //                                       ? Icons.favorite
                        //                                       : Icons
                        //                                       .favorite_border),
                        //                                   color: Color(
                        //                                       0xff108aa6),
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //
                        //             ),
                        //             back: Card(
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius
                        //                     .all(Radius
                        //                     .circular(5)),
                        //               ),
                        //               child: Container(
                        //                 width: MediaQuery
                        //                     .of(context)
                        //                     .size
                        //                     .width,
                        //                 // height: 50,
                        //                 padding: EdgeInsets
                        //                     .symmetric(
                        //                     vertical: 20),
                        //                 alignment: Alignment
                        //                     .center,
                        //                 //
                        //                 child: Stack(
                        //                   children: <Widget>[
                        //                     Container(
                        //                       // height: ,
                        //                       width: MediaQuery
                        //                           .of(context)
                        //                           .size
                        //                           .width,
                        //                       // color: Colors.amber,
                        //                       child: Row(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .center,
                        //                         // mainAxisAlignment: MainAxisAlignment.center,
                        //
                        //                         children: <Widget>[
                        //                           Container(
                        //                             width: 200,
                        //                             // height: 200,
                        //                             child: QrImage(
                        //                               data: ofer[i]["id"],
                        //                               size: MediaQuery
                        //                                   .of(context)
                        //                                   .size
                        //                                   .height,
                        //                             ),
                        //                           ),
                        //                           SizedBox(
                        //                             width: 30,
                        //                           ),
                        //                           Column(
                        //                               mainAxisAlignment: MainAxisAlignment
                        //                                   .start,
                        //                               crossAxisAlignment: CrossAxisAlignment
                        //                                   .end,
                        //                               children: <Widget>[
                        //                                 Text(
                        //                                   ofer[i]["nombre"],
                        //                                   style: TextStyle(
                        //                                       fontSize: 20,
                        //                                       color: Colors
                        //                                           .black54),
                        //                                 ),
                        //                                 SizedBox(
                        //                                   height: 20,
                        //                                 ),
                        //                                 Text(
                        //                                   "GTQ ${ofer[i]["valor"]}",
                        //                                   style: TextStyle(
                        //                                       fontSize: 20,
                        //                                       color: Colors
                        //                                           .black54),
                        //                                 ),
                        //                               ]
                        //                           ),
                        //
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //
                        //                 ),
                        //               ),
                        //
                        //             ),
                        //           ),
                        //
                        //
                        //         );
                        //       }
                        //   ),
                        //   // child:
                        // ),


                        SizedBox(
                          height: 40,
                          child: TabPageSelector(controller: _controller),

                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instanceFor(
                                app: Firebase.app('businessApp')).collection(
                                'empresa').snapshots(),
                            builder: (context, snapshot1) {
                              if (!snapshot1.hasData)
                                return LinearProgressIndicator();
                              return Expanded(child: buildListRec(
                                  snapshot1.data, snapshot2.data, user.uid));
                            }
                        ),



                        // gustosVerify(context);
                        // if(!snapshot.hasData) return LinearProgressIndicator();
                        // return Expanded(child: buildListRec(snapshot.data));


                        // new Expanded(
                        //   child:
                        //   ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: empresas.length,
                        //     physics: ScrollPhysics(),
                        //     itemBuilder: (BuildContext context, int index){
                        //
                        //       return recommendEmpresa(empresas[index], context);
                        //     },
                        //     // crossAxisAlignment: CrossAxisAlignment.center,
                        //     // mainAxisAlignment: MainAxisAlignment.center,
                        //
                        //
                        //   ),
                        // ),
                        // ),
                        // ),
                        // ),

                        // ),

                      ],
                    ),
                    // ),


                    // ),

                  ],
                  // child: Image.asset("assets/images/background.png"),

                ),

                    buildListGus(user.uid,oferta, snapshot2.data),

                  ],

                );


              });
        }
        ),

      );




  }


}