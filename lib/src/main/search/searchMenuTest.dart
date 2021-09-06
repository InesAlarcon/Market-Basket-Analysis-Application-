// @dart=2.9
import 'dart:io';

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


class SearchMenuTest extends StatefulWidget {
  @override
  SearchMenuTestState createState() => new SearchMenuTestState();
}

class SearchMenuTestState extends State<SearchMenuTest> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchBy(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==  true) {
          if (element['name'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }

      });

    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }

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


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context);

    return new Scaffold(
        appBar: new AppBar(
          title: Text('Empresas'),
          backgroundColor: Color(0xff108aa6),

        ),
        body:Stack(
            children: <Widget> [
              background(),
              ListView(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    onChanged: (val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.arrow_back),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Buscar por nombre',
                        hintStyle: TextStyle( color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
                SizedBox(height: 10.0),

                ListView(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),

                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                          elevation: 2.0,
                          child: Container(
                            height: 50,
                              child: ListTile(
                                leading: IconButton(
                                  onPressed: (){
                                    DatabaseConnect(uid: user.uid).agregarSuscripcion(element['name']);

                                  },
                                    icon: Icon(Icons.add,color: Color(0xff108aa6),),
                                  ),
                                  title: Text(element['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                trailing: IconButton(
                                  onPressed: (){
                                    DatabaseConnect(uid: user.uid).agregarSuscripcion(element['name']);

                                  },
                                  icon: Icon(Icons.star,color: Colors.orangeAccent,),
                                ),
                              )
                          )

                      );
                    }).toList())
                 ])
                ]
        )

    );
  }
}

