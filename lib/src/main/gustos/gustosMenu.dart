// @dart=2.9
import 'dart:io';

import 'package:cliente/src/main/gustos/gustoTile.dart';
import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
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

  bool inLogin = false;
  bool selectGustos = false;
  Future resultsLoaded;
  var empresas = [];
  var allRes = [];
  static List<String> finalTagList = [];
  List<String> selectedTags = [];

  var totalGustos = [];


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

    print("tags ${finalTagList}");
  }

  showAlert(BuildContext context, String user) {

    var text = "";

    fetchGustos();
    var gridList = finalTagList.toSet().toList();

    final items = gridList.map((e) => MultiSelectItem(e, e)).toList();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              content: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[

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
                          print(values);
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
                          print(totalGustos);
                          for(int i = 0; i<totalGustos.length; i++){
                            if(selectedTags.contains(totalGustos[i])){
                              selectGustos = false;
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Seleccionar gustos nuevos')));
                            }else{
                              selectGustos=true;
                            }
                          }
                          if(selectedTags.length<1){
                            selectGustos = false;
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Seleccionar por lo menos 1 gusto')));
                          }else if(selectedTags.length>=1&&selectGustos){
                              selectedTags.forEach((element) {
                                DatabaseConnect(uid: user).agregarGustos(element);
                              });
                              Navigator.pop(context);
                          }
                        },
                        child: Text("agregar"),
                      ),
                      Text(text, style: TextStyle(color: Colors.red, fontSize: 14)),

                    ],
                  ),




                ],
              ),
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       Navigator.pop(
            //           context);
            //     },
            //     child: Text("Agregar"),
            //   ),
            // ],
          );
        });
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

  Widget build(BuildContext context) {

    fetchGustos();

    RegExp expGusto = new RegExp(r"({gusto: )|(\,(.*)|(}))");
    final user = Provider.of<Usuario>(context);

    // if(!inLogin){
    //   Future.delayed(Duration.zero, () => showAlertPop(context));
    // }

    return Scaffold(

      appBar: AppBar(
        title: Text('Gustos'),
        backgroundColor: Color(0xff108aa6),
          actions: <Widget>[
          IconButton(
          onPressed: () async {
            Navigator.push(
                context, PageRouteBuilder(
                opaque: false,
                pageBuilder: (context,animation,secondaryAnimation) => GustoTile(uid: user.uid,list: finalTagList,totalGustos: totalGustos,),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));


                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                }
                )
              );
            },
          icon: Icon(Icons.search)),
          ]
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').snapshots(),
      builder: (context, snapshot2) {
        var gustos = snapshot2.data;
        
        var listaGusto = gustos.docs.map((e) => e.get("gusto")).toList();
        
          
        return  Stack(
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
                            itemCount: listaGusto.length,
                            itemBuilder: (BuildContext context, int index) {
                              // final empresa = GustosUser.fromSnapshot(empresas[index]);
                              // totalGustos.add(empresa.name);


                              return Dismissible(
                                key: /*Key(listaGustos[index].toString())*/UniqueKey(),
                                onDismissed: (direction)  {





                                    FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').doc(listaGusto[index]).delete();
                                    // listaGusto.removeAt(index);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text('Gusto Eliminado')));


                                },
                                background: Container(color: Colors.red),
                                child: new Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                        child: Card(
                                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                                            child: ListTile(
                                              title: Text(
                                                listaGusto[index],
                                                textAlign: TextAlign.center,
                                              ),

                                          ),
                                        ),
                                      ),
                                ),
                              );
                            }


                        ),


                      ),
                      // ElevatedButton(
                      //   onPressed: (){
                      //     setState(() {
                      //       Navigator.push(
                      //           context, MaterialPageRoute(builder: (context) => GustoTile(uid: user.uid,list: finalTagList,totalGustos: totalGustos,)));
                      //     });
                      //
                      //   },
                      //   child: Text("AGREGAR GUSTOS"),
                      //
                      //
                      // ),
                      // ),
                    ],
                  ),
                ),
              ),
            ]
        );
      },
      )
      );

    //   ),
    // );
  }
}