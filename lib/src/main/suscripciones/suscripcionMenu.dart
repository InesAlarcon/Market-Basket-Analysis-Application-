// @dart=2.9
import 'dart:io';

import 'package:cliente/src/main/negocio/negocioPage.dart';
import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../usuario.dart';

class SuscripcionMenu extends StatefulWidget {
  @override
  SuscripcionMenuState createState() => SuscripcionMenuState();
}

class SuscripcionMenuState extends State<SuscripcionMenu> {
  // This holds a list of fiction users
  // You can use data fetched from a database or cloud as well
  TextEditingController searchController = TextEditingController();


  Future resultsLoaded;
  var empresas = [];
  var allRes = [];

  Icon subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  changeIconUnSub(){
    subscribeIcon = new Icon(Icons.add, color: Color(0xff108aa6),);
  }

  @override
  initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getEmpresas();
  }

  onSearchChanged(){
    print(searchController.text);
  }


  searchResultsList() {
    var showResults = [];

    if(searchController.text != "") {
      for(var empresaSnapshot in allRes){
        var title = GustosUser.fromSnapshot(empresaSnapshot).name.toLowerCase();

        if(title.contains(searchController.text.toLowerCase())) {
          showResults.add(empresaSnapshot);
          print(showResults);

        }
      }

    } else {
      showResults = List.from(allRes);
      print(showResults);
    }
    setState(() {
      empresas = showResults;
    });
  }


  getEmpresas() async {
    final user = Provider.of<Usuario>(context);

    var list = await FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('suscripciones').get();
    setState(() {
      allRes = list.docs;
      print(allRes);
    });
    searchResultsList();
    return "Completado";

  }

  Widget searchResSus(DocumentSnapshot snapshot, context){

    var pageData = [];

    // initPage(String pageid){
    //   SearchService().searchByID(pageid).then((QuerySnapshot docs){
    //     pageData = docs.docs.map((e) => {
    //       "id": e.id,
    //       "nombre": e.get("nombre"),
    //       "defaultRating": e.get("defaultRating"),
    //       "voteCount": e.get("voteCount"),
    //     }).toList();
    //     print("PageDATA ${pageData}");
    //   });
    // }

    final user = Provider.of<Usuario>(context);
    final empresa = EmpresaSus.fromSnapshot(snapshot);
    print(empresa.name);
    print(empresa.id);
    print(empresa.vote);
    bool test = empresa.vote;

    // initPage(empresa.id);

    double empRate = empresa.rating;

    ValueNotifier valNot = ValueNotifier(empresa.rating);

    return new Container(
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
          ),
          InkWell(
            onTap: ()  {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: empresa.id)));
            },

            child: Container(
              padding: EdgeInsets.all(10),
              width: 200,
              // color: Colors.amber,
              alignment: Alignment.topLeft,
              child: Text(
                empresa.name,
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


              ValueListenableBuilder<dynamic>(
                  valueListenable: valNot,
                  builder: (context,value,_){
                    return RatingBar.builder(
                      itemSize: 20,

                      initialRating: value,
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
                        print(rating);
                        empRate = rating;

                      },
                    );
                  }

              ),
              // RatingBar.builder(
              //   itemSize: 20,
              //
              //   initialRating: empresa.rating,
              //   minRating: 1,
              //   direction: Axis.horizontal,
              //   allowHalfRating: true,
              //   itemCount: 5,
              //   itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              //   itemBuilder: (context, _) => Icon(
              //     Icons.star,
              //     color: Colors.amber,
              //   ),
              //   onRatingUpdate: (rating) {
              //     print(rating);
              //     empRate = rating;
              //
              //   },
              // ),
              SizedBox(
                height: 5,
              ),

              // SizedBox(
              //   height: 60,
              //   width: 60,
              //   child: Card(
              //         // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              //         color: Colors.orange.shade300,
              //         child: IconButton(
              //
              //     onPressed: (){
              //       if(empresa.vote){
              //         showDialog(
              //             barrierDismissible: true,
              //             context: context,
              //             builder: (context) {
              //               return AlertDialog(
              //                 elevation: 24,
              //                 title: Text(
              //                     "¿Quieres quitar tu calificación?"
              //                 ),
              //                 actions: [
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.pop(
              //                           context);
              //                     },
              //                     child: Text("No"),
              //                   ),
              //                   TextButton(
              //                     onPressed: () {
              //                       bool vote = false;
              //                       DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, 0.0, vote);
              //                       BusinessDatabaseConnect().rateEmpresa(empresa.id, vote, empresa.rating);
              //                       Future.delayed(Duration(milliseconds: 500),(){
              //                         setState(() {
              //                           BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
              //                         });
              //                       });
              //                       Navigator.pop(
              //                           context);
              //                       ScaffoldMessenger
              //                           .of(context)
              //                           .showSnackBar(
              //                           SnackBar(
              //                               content: Text(
              //                                   'Calificación a ${empresa.name} Eliminada')));
              //                     },
              //                     child: Text("Si"),
              //                   ),
              //
              //                 ],
              //               );
              //             }
              //         );
              //         setState(() {
              //           test = false;
              //         });
              //       }
              //       else{
              //         bool vote = true;
              //
              //         setState(() {
              //           changeIconUnSub();
              //         });
              //         // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
              //         DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, empRate, vote);
              //         BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
              //         Future.delayed(Duration(milliseconds: 500),(){
              //           setState(() {
              //             BusinessDatabaseConnect().rateEmpresa(empresa.id, vote, empRate);
              //           });
              //         });
              //         // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
              //         ScaffoldMessenger.of(context)
              //             .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
              //       }
              //     },
              //
              //     iconSize: 20,
              //     icon: Icon(test
              //         ? Icons.remove_circle_outline
              //         : Icons.star),
              //     color: Color(0xff108aa6),
              //   ),
              //   ),
              // )

              if (!empresa.vote) SizedBox(
                height: 60,
                width: 120,
                child: Card(
                  // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  color: Colors.orange.shade300,
                  // child: Center(
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.center,
                      child: Text('Calificar', style: TextStyle( fontSize: 20),textAlign: TextAlign.center),),
                    onTap: () async {
                      bool vote = true;

                                    setState(() {
                                      changeIconUnSub();
                                    });
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
                                    DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, empRate, vote);
                                    BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                    Future.delayed(Duration(milliseconds: 500),(){
                                      setState(() {
                                        BusinessDatabaseConnect().rateEmpresa(empresa.id, vote, empRate);
                                      });
                                    });
                                    // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
                    },
                  ),
                )
              )
              else SizedBox(
              height: 60,
              width: 120,
                child: Card(
                  // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  color: Colors.redAccent,
                  // child: Center(
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.center,
                      child: Text('Quitar Calificación', style: TextStyle( fontSize: 15),textAlign: TextAlign.center),),
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
                                                  DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, 0.0, vote);
                                                  BusinessDatabaseConnect().rateEmpresa(empresa.id, vote, empresa.rating);
                                                  Future.delayed(Duration(milliseconds: 500),(){
                                                    setState(() {
                                                      BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                                    });
                                                  });
                                                  Navigator.pop(
                                                      context);
                                                  ScaffoldMessenger
                                                      .of(context)
                                                      .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Calificación a ${empresa.name} Eliminada')));
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

                      // bool vote = false;
                      // // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
                      //
                      // // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
                    },
                  ),
                )
              ),

            ],
          ),




        ],
      ),

      //
      // // child: Padding(
      //   // padding: EdgeInsets.only(top: 3.0),
      //   // child: Center(
      //     child: Card(
      //     margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      //     child: ListTile(
      //
      //       title: Text(
      //         empresa.name,
      //         // textAlign: TextAlign.center,
      //         style: TextStyle(fontSize: 22),
      //       ),
      //       isThreeLine: true,
      //       trailing: RatingBar.builder(
      //         itemSize: 20,
      //
      //         initialRating: empresa.rating,
      //         minRating: 1,
      //         direction: Axis.horizontal,
      //         allowHalfRating: true,
      //         itemCount: 5,
      //         itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
      //         itemBuilder: (context, _) => Icon(
      //           Icons.star,
      //           color: Colors.amber,
      //         ),
      //         onRatingUpdate: (rating) {
      //           print(rating);
      //         },
      //       ),
      //       subtitle: Container(
      //
      //         // width: 140,
      //         // decoration: BoxDecoration(
      //         //
      //         // border: Border.all(color: Colors.black),
      //         //   borderRadius: new BorderRadius.all(Radius.circular(5)
      //         // ),
      //         // color: Colors.orange.shade100,
      //
      //       // ),
      //       //   child: Center(
      //         child: Card(
      //           margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      //           color: Colors.orange.shade300,
      //           // child: Center(
      //             child: ListTile(
      //               title: Align(
      //                 alignment: Alignment.center,
      //                 child: Text('Calificar', style: TextStyle( fontSize: 20),textAlign: TextAlign.center),),
      //               onTap: (){
      //                 Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
      //               },
      //             ),
      //           ) ,
      //
      //
      //         // ),
      //     // ),
      //   ),
      // ),
      // ),

    );


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


  Widget build(BuildContext context) {
    RegExp expGusto = new RegExp(r"({gusto: )|(\,(.*)|(}))");
    final user = Provider.of<Usuario>(context);

    return Scaffold(

        appBar: AppBar(
          title: Text('Suscripciones'),
          backgroundColor: Color(0xff2C73D2),

        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('suscripciones').snapshots(),
          builder: (context, snapshotSus) {


            var sus = snapshotSus.data;



            return Stack(
                children: <Widget> [

                  background(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          // TextField(
                          //   controller: searchController,
                          //
                          //   decoration: InputDecoration(
                          //       labelText: 'Search', suffixIcon: Icon(Icons.search)),
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: sus.size,
                                itemBuilder: (BuildContext context, int index) {
                                  bool test = sus.docs[index]["voteCount"];
                                  double empRate = sus.docs[index]["rating"];

                                  return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.
                                  instance.collection(
                                  'usuario').
                                  doc(user.uid).collection("ratings").doc(sus.docs[index]["id"]).snapshots(),
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
                                      empRate = rateQuery.get("rating")+0.0;
                                      ratings = rateQuery.get("rating")+0.0;
                                      getVoteCount = rateQuery.get("voteCount");
                                    }


                                    return Dismissible(
                                      key: /*Key(listaGustos[index].toString())*/UniqueKey(),
                                      onDismissed: (direction)  {
                                        // final empresa = EmpresaSus.fromSnapshot(empresas[index]);
                                        // int vote = empresa.vote;
                                        bool voteVal = false;


                                        // setState(()  {
                                        // vote--;
                                        FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('suscripciones').doc(sus.docs[index]["id"]).delete();
                                        BusinessDatabaseConnect().subEmpresa(sus.docs[index]["id"], voteVal);
                                        // empresas.removeAt(index);
                                        // });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text('Suscripción a ${sus.docs[index]["empresa"]} Eliminada')));


                                      },
                                      background: Container(
                                          color: Colors.red,
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      child: new Container(
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
                                            ),
                                            InkWell(
                                              onTap: ()  {
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: sus.docs[index]["id"])));
                                              },

                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                width: 200,
                                                // color: Colors.amber,
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  sus.docs[index]["empresa"],
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


                                                // ValueListenableBuilder<dynamic>(
                                                //     valueListenable: valNot,
                                                //     builder: (context,value,_){
                                                //       return RatingBar.builder(
                                                //         itemSize: 20,
                                                //
                                                //         initialRating: value,
                                                //         minRating: 1,
                                                //         direction: Axis.horizontal,
                                                //         allowHalfRating: true,
                                                //         itemCount: 5,
                                                //         itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                //         itemBuilder: (context, _) => Icon(
                                                //           Icons.star,
                                                //           color: Colors.amber,
                                                //         ),
                                                //         onRatingUpdate: (rating) {
                                                //           print(rating);
                                                //           empRate = rating;
                                                //
                                                //         },
                                                //       );
                                                //     }
                                                //
                                                // ),
                                                if(!getVoteCount) RatingBar.builder(
                                                  itemSize: 20,

                                                  initialRating: ratings+0.0,
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
                                                    print(rating);
                                                    empRate = rating;

                                                  },
                                                )
                                                else RatingBarIndicator(
                                                  rating: ratings+0.0,
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),

                                                // SizedBox(
                                                //   height: 60,
                                                //   width: 60,
                                                //   child: Card(
                                                //         // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                                                //         color: Colors.orange.shade300,
                                                //         child: IconButton(
                                                //
                                                //     onPressed: (){
                                                //       if(empresa.vote){
                                                //         showDialog(
                                                //             barrierDismissible: true,
                                                //             context: context,
                                                //             builder: (context) {
                                                //               return AlertDialog(
                                                //                 elevation: 24,
                                                //                 title: Text(
                                                //                     "¿Quieres quitar tu calificación?"
                                                //                 ),
                                                //                 actions: [
                                                //                   TextButton(
                                                //                     onPressed: () {
                                                //                       Navigator.pop(
                                                //                           context);
                                                //                     },
                                                //                     child: Text("No"),
                                                //                   ),
                                                //                   TextButton(
                                                //                     onPressed: () {
                                                //                       bool vote = false;
                                                //                       DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, 0.0, vote);
                                                //                       BusinessDatabaseConnect().rateEmpresa(empresa.id, vote, empresa.rating);
                                                //                       Future.delayed(Duration(milliseconds: 500),(){
                                                //                         setState(() {
                                                //                           BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                                //                         });
                                                //                       });
                                                //                       Navigator.pop(
                                                //                           context);
                                                //                       ScaffoldMessenger
                                                //                           .of(context)
                                                //                           .showSnackBar(
                                                //                           SnackBar(
                                                //                               content: Text(
                                                //                                   'Calificación a ${empresa.name} Eliminada')));
                                                //                     },
                                                //                     child: Text("Si"),
                                                //                   ),
                                                //
                                                //                 ],
                                                //               );
                                                //             }
                                                //         );
                                                //         setState(() {
                                                //           test = false;
                                                //         });
                                                //       }
                                                //       else{
                                                //         bool vote = true;
                                                //
                                                //         setState(() {
                                                //           changeIconUnSub();
                                                //         });
                                                //         // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
                                                //         DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, empRate, vote);
                                                //         BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                                //         Future.delayed(Duration(milliseconds: 500),(){
                                                //           setState(() {
                                                //             BusinessDatabaseConnect().rateEmpresa(empresa.id, vote, empRate);
                                                //           });
                                                //         });
                                                //         // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                                //         ScaffoldMessenger.of(context)
                                                //             .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
                                                //       }
                                                //     },
                                                //
                                                //     iconSize: 20,
                                                //     icon: Icon(test
                                                //         ? Icons.remove_circle_outline
                                                //         : Icons.star),
                                                //     color: Color(0xff108aa6),
                                                //   ),
                                                //   ),
                                                // )

                                                if (!getVoteCount) SizedBox(
                                                    height: 60,
                                                    width: 120,
                                                    child: Card(
                                                      // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                                                      color: Colors.orange.shade300,
                                                      // child: Center(
                                                      child: ListTile(
                                                        title: Align(
                                                          alignment: Alignment.center,
                                                          child: Text('Calificar', style: TextStyle( fontSize: 20),textAlign: TextAlign.center),),
                                                        onTap: () async {
                                                          bool vote = true;

                                                          setState(() {
                                                            changeIconUnSub();
                                                          });
                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
                                                          DatabaseConnect(uid: user.uid).ratingSubs(sus.docs[index]["id"], empRate, vote);
                                                          BusinessDatabaseConnect().voteEmpresa(sus.docs[index]["id"], vote);
                                                          Future.delayed(Duration(milliseconds: 500),(){
                                                            setState(() {
                                                              BusinessDatabaseConnect().rateEmpresa(sus.docs[index]["id"], vote, empRate);
                                                            });
                                                          });
                                                          // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(SnackBar(content: Text('Calificación de ${sus.docs[index]["empresa"]} modificada')));
                                                        },
                                                      ),
                                                    )
                                                )
                                                else SizedBox(
                                                    height: 60,
                                                    width: 120,
                                                    child: Card(
                                                      // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                                                      color: Color(0xfffa4d6a),

                                                      // child: Center(
                                                      child: ListTile(
                                                        title: Align(
                                                          alignment: Alignment.center,
                                                          child: Text('Quitar Calificación', style: TextStyle( fontSize: 15, color: Colors.white),textAlign: TextAlign.center),),
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
                                                                        DatabaseConnect(uid: user.uid).ratingSubs(sus.docs[index]["id"], 0.0, vote);
                                                                        BusinessDatabaseConnect().rateEmpresa(sus.docs[index]["id"], vote, rateQuery.get("rating"));
                                                                        Future.delayed(Duration(milliseconds: 500),(){
                                                                          setState(() {
                                                                            BusinessDatabaseConnect().voteEmpresa(sus.docs[index]["id"], vote);
                                                                          });
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                        ScaffoldMessenger
                                                                            .of(context)
                                                                            .showSnackBar(
                                                                            SnackBar(
                                                                                content: Text(
                                                                                    'Calificación a ${sus.docs[index]["empresa"]} Eliminada')));
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

                                              ],
                                            ),




                                          ],
                                        ),

                                      ),
                                    );
                                  });

                                }


                            ),


                          )

                          // ),
                        ],
                      ),
                    ),
                  ),
                ]
            );


            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('empresa').doc(user.uid).collection('suscripciones').snapshots(),
              builder: (context, snapshotEmp) {




              }
            );
          }
        ),



    );

    //   ),
    // );
  }
}