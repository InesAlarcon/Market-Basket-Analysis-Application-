// @dart=2.9

import 'package:cliente/src/main/gustos/agregarGusto.dart';
import 'package:cliente/src/main/gustos/verGustos.dart';
import 'package:cliente/src/main/search/searchMenu.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/gustos.dart';

class GustosUsuario extends StatefulWidget{
  GustosUsuario({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;



  @override
  GustosUsuarioState createState() => GustosUsuarioState();
}

class GustosUsuarioState extends State<GustosUsuario>{

  String docuid = '';

  final gustosController = TextEditingController();

  @override
  void initState(){
    super.initState();
    docuid = widget.uid;
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

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AgregarGusto(title: '', /*uid: uid*/)));

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
            context, MaterialPageRoute(builder: (context) => SearchMenu(/*uid: uid*/)));

      },
    );
  }

  @override
  Widget build(BuildContext context){




    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // title: Text(
        //      "search",
        //       style: TextStyle(color: Colors.white),
        //       ),
        backgroundColor: Color(0xff108aa6),
      ),
      body: Center(
        child: Container(

          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [Color(0xff464646), Color(0xff7c7c7c)]),
            image: DecorationImage(
              image: AssetImage("assets/images/background2.png"),
              fit: BoxFit.cover,
            ),
          ),
          // alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              botonVerGusto(),
              SizedBox(height: 40,),
              botonAgregarGusto(),


            ],
          ),
        ),
      ),


    );
  }



}