// @dart=2.9
import 'dart:io';

import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../usuario.dart';

class GustosMenu extends StatefulWidget {
  @override
  GustosMenuState createState() => GustosMenuState();
}

class GustosMenuState extends State<GustosMenu> {
  // This holds a list of fiction users
  // You can use data fetched from a database or cloud as well
  TextEditingController searchController = TextEditingController();
  

  Future resultsLoaded;
  var empresas = [];
  var allRes = [];

  
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
        var title = Empresa.fromSnapshot(empresaSnapshot).name.toLowerCase();

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

    var list = await FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').get();
    setState(() {
      allRes = list.docs;
      print(allRes);
    });
    searchResultsList();
    return "Completado";
    
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
        title: Text('Gustos'),
        backgroundColor: Color(0xff108aa6),

      ),
      body: Stack(
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
                          itemCount: empresas.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                                key: /*Key(listaGustos[index].toString())*/UniqueKey(),
                                onDismissed: (direction)  {
                                  final empresa = Empresa.fromSnapshot(empresas[index]);



                                setState(()  {
                                  FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').doc(empresa.name).delete();
                                  empresas.removeAt(index);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Gusto Eliminado')));


                                },
                              background: Container(color: Colors.red),
                              child: SearchResultGusto(empresas[index]),
                            );
                          }


                        ),


                      )

                      // ),
                    ],
                  ),
            ),
              ),
          ]
          )
        );

    //   ),
    // );
  }
}