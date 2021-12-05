// @dart=2.9

import 'package:cliente/src/main/negocio/negocioPage.dart';
import 'package:cliente/src/main/suscripciones/ratingSub.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../usuario.dart';

class GustosUser {
  String name;


  GustosUser(
      this.name,

      );

  GustosUser.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot['gusto'];
}

class EmpresaSus {
  String name;
  double rating;
  String id;
  bool vote;

  EmpresaSus(
      this.name,
      this.rating,
      this.id,
      this.vote,
      );

  EmpresaSus.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot['empresa'], rating = snapshot['rating'], id = snapshot['id'], vote = snapshot["voteCount"];
}

class EmpresaSusSearch {
  String name;
  double rating;
  String id;
  int vote;

  EmpresaSusSearch(
      this.name,
      this.rating,
      this.id,
      this.vote,
      );

  EmpresaSusSearch.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot['empresa'], rating = snapshot['rating'], id = snapshot.id, vote = snapshot["voteCount"];
}

class EmpresaRecommend{
  String name;
  double rating;
  String type;

  EmpresaRecommend(
      this.name,
      this.rating,
      this.type,
      );

  EmpresaRecommend.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) : name = snapshot.get('nombre'), rating = snapshot.get('defaultRating'), type = snapshot.get('type');
}

enum Filtros {TODO, GUSTOS}

Widget SearchResultGusto(DocumentSnapshot snapshot){
  final empresa = GustosUser.fromSnapshot(snapshot);
  print(empresa.name);


  return new Container(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(
              empresa.name,
              textAlign: TextAlign.center,
            ),

          ),
        ),
      ),
  );


}


Widget SearchResultSus(DocumentSnapshot snapshot, context){

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
  bool test = true;

  // initPage(empresa.id);

  double empRate = empresa.rating;

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
              RatingBar.builder(
                        itemSize: 20,

                        initialRating: empresa.rating,
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
                      ),
              SizedBox(
                height: 5,
              ),

              SizedBox(
                height: 60,
                width: 60,
                child: IconButton(

                  onPressed: (){
                    if(empresa.vote){
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
                                    BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
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
                    }
                    else{
                      bool vote = true;


                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
                      DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, empRate, vote);
                      BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                      // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
                    }
                  },

                  iconSize: 20,
                  icon: Icon(empresa.vote
                      ? Icons.check_rounded
                      : Icons.add),
                  color: Color(0xff108aa6),
                ),
              )

              // if (!empresa.vote) SizedBox(
              //   height: 60,
              //   width: 120,
              //   child: Card(
              //     // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              //     color: Colors.orange.shade300,
              //     // child: Center(
              //     child: ListTile(
              //       title: Align(
              //         alignment: Alignment.center,
              //         child: Text('Calificar', style: TextStyle( fontSize: 20),textAlign: TextAlign.center),),
              //       onTap: () async {
              //         bool vote = true;
              //
              //         // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
              //         DatabaseConnect(uid: user.uid).ratingSubs(empresa.name, empRate, vote);
              //         BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
              //         // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
              //         ScaffoldMessenger.of(context)
              //             .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
              //       },
              //     ),
              //   )
              // )
              // else SizedBox(
              // height: 60,
              // width: 120,
              //   child: Card(
              //     // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              //     color: Colors.redAccent,
              //     // child: Center(
              //     child: ListTile(
              //       title: Align(
              //         alignment: Alignment.center,
              //         child: Text('Quitar Calificación', style: TextStyle( fontSize: 15),textAlign: TextAlign.center),),
              //       onTap: () async {
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
              //                       BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
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
              //
              //         // bool vote = false;
              //         // // Navigator.push(context, MaterialPageRoute(builder: (context) => RatingSub(empresa: empresa.name,rating: empresa.rating)));
              //         //
              //         // // BusinessDatabaseConnect().voteEmpresa(empresa.id, vote);
              //         // ScaffoldMessenger.of(context)
              //         //     .showSnackBar(SnackBar(content: Text('Calificación de ${empresa.name} modificada')));
              //       },
              //     ),
              //   )
              // ),

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