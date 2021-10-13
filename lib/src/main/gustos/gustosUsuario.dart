// @dart=2.9

import 'package:cliente/src/main/calificar/calificarCompra.dart';
import 'package:cliente/src/main/gustos/verGustos.dart';
import 'package:cliente/src/main/gustos/gustosMenu.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/gustos.dart';
import 'package:flutter_icons/flutter_icons.dart';
class GustosUsuario extends StatefulWidget{
  GustosUsuario({this.uid, this.list, this.totalGustos}) ;

  final List<String> list;
  final int totalGustos;
  final String uid;



  @override
  GustosUsuarioState createState() => GustosUsuarioState();
}

class GustosUsuarioState extends State<GustosUsuario>{

  String docuid = '';
  bool selectGustos = false;
  String user;

  static List<String> finalTagList = [];
  List<String> selectedTags = [];
  int userGustos;

  final gustosController = TextEditingController();

  @override
  void initState(){
    docuid = widget.uid;
    user = widget.uid;
    userGustos = widget.totalGustos;
    finalTagList = widget.list;
    super.initState();
  }

  // Widget gustosQuery(){
  //   return StreamProvider<List<Gustos>>.value(
  //     initialData: null,
  //     value: DatabaseConnect().gustos,
  //     child: Scaffold(
  //       body: ListaGustos(),
  //     ),
  //   );
  // }

  Widget saveGusto(){
    return Container(
      child: Text(
        '',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget botonAgregarGusto(){
    return ElevatedButton(
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff6D597A), Color(0xff355070)])),
        child: Column(
          children: <Widget>[
            Text(
              'AGREGAR GUSTOS',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: () async {

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => AgregarGusto(title: '', /*uid: uid*/)));

      },
    );
  }

  Widget botonVerGusto(){
    return ElevatedButton(
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff6D597A), Color(0xff355070)])),
        child: Column(
          children: <Widget>[
            Text(
              'VER GUSTOS',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: () async {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GustosMenu(/*uid: uid*/)));

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizeTags = userGustos;

    var text = "";

    // fetchGustos();
    var gridList = finalTagList.toSet().toList();

    final items = gridList.map((e) => MultiSelectItem(e, e)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
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
                title: Text("Seleccionar 3 gustos iniciales :",
                  style: TextStyle(color: Colors.white, fontSize: 20),),
                headerColor: Color(0xff108aa6),
                textStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(color: Colors.white)),
                chipColor: Color(0xff6c80a3),
                chipShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                selectedChipColor: Color(0xcf008da6),
                selectedTextStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(color: Colors.white)),
                onTap: (values) {
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
                onPressed: () {
                  if(selectedTags.length<3){
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
                    Future.delayed(Duration.zero,(){
                      Navigator.of(context).popUntil((route) {
                        return route.settings.name ==
                            'mainMenu';
                      });
                    });




                  }
                },
                child: Text("agregar"),
              ),
              Text(text, style: TextStyle(color: Colors.red, fontSize: 14)),
              ElevatedButton(
                onPressed: () {

                    Navigator.of(context).popUntil((route) {
                      return route.settings.name ==
                          'mainMenu';
                    });

                },
                child: Text("Menu Principal"),
              ),
            ],
          ),


        ],
      ),

    );
  }
}