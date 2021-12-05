// @dart=2.9


import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/verGustos.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cliente/src/main/gustos/gustos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'gustosMenu.dart';

class GustoTile extends StatefulWidget {
  GustoTile({this.uid, this.list, this.totalGustos});


  final String uid;
  final List<String> list;
  final List<dynamic> totalGustos;


  @override
  GustoTileState createState() => GustoTileState();

}

class GustoTileState extends State<GustoTile> {

  bool selectGustos = false;
  String user;

  static List<String> finalTagList = [];
  List<String> selectedTags = [];
  var userGustos = [];


  @override
  void initState(){
    user = widget.uid;
    userGustos = widget.totalGustos;
    finalTagList = widget.list;
    super.initState();
  }

  // fetchGustos() async {
  //   List listaEmpresas = await FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').get().then((value) => value.docs);
  //   for(int i=0;i<listaEmpresas.length;i++){
  //     FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection("empresa").doc(
  //         listaEmpresas[i].id.toString()
  //     ).collection("etiquetas").snapshots().listen((CreateListTags));
  //   }
  // }
  //
  // CreateListTags(QuerySnapshot snapshot) async{
  //   var docs = snapshot.docs;
  //   for(var doc in docs){
  //     finalTagList.add(doc.get("etiquetas"));
  //   }
  //
  //   print("tags ${finalTagList}");
  // }
  //

  @override
  Widget build(BuildContext context){

    var totalGustos = userGustos.toSet().toList();

    var text = "";

    // fetchGustos();
    var gridList = finalTagList.toSet().toList();

    final items = gridList.map((e) => MultiSelectItem(e, e)).toList();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),

      body: AnimatedSwitcher(
            duration: const Duration(seconds: 3),
            transitionBuilder: (child, animation) {

            return ScaleTransition(
              scale: animation,
              child: child,
            );
            },
            child: Stack(

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
                        border: Border.all(color: Color(0xff2C73D2), width: 1.8),
                        color: Color(0x8f2C73D2),
                      ),
                      items: items,
                      title: Text("Seleccionar 3 gustos iniciales :", style:TextStyle(color: Colors.white, fontSize: 20),),
                      headerColor: Color(0xff2C73D2),
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
                        int i = 0;
                        // while(i<totalGustos.length){
                        //
                        //     if(selectedTags.contains(totalGustos[i])){
                        //       selectGustos = false;
                        //       ScaffoldMessenger
                        //           .of(context)
                        //           .showSnackBar(
                        //           SnackBar(
                        //               content: Text(
                        //                   'Seleccionar gustos nuevos')));
                        //       i++;
                        //     }else{
                        //       selectGustos=true;
                        //     }
                        //   }
                        // if(selectedTags.length<1){
                        //   selectGustos = false;
                        //   ScaffoldMessenger
                        //       .of(context)
                        //       .showSnackBar(
                        //       SnackBar(
                        //           content: Text(
                        //               'Seleccionar por lo menos 1 gusto')));
                        // }else
                          if(selectedTags.length>=1){
                          selectedTags.forEach((element) {
                            DatabaseConnect(uid: user).agregarGustos(element);
                          });
                          setState(() {
                            Navigator.pop(context);
                            // Navigator.of(context).popUntil((route) {
                            //   return route.settings.name ==
                            //       'mainMenu';
                            // });

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => GustosMenu()));
                          });
                          // Future.delayed(Duration.zero,(){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => GustosMenu()));
                          //
                          // });

                        }
                      },
                      child: Text("agregar"),
                    ),
                    Text(text, style: TextStyle(color: Colors.red, fontSize: 14)),

                  ],
                ),




              ],
            ),
          ),



    );




  }
}