// @dart=2.9

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

  Widget gustosQuery(){
    return StreamProvider<List<Gustos>>.value(
      initialData: null,
      value: DatabaseConnect().gustos,
      child: Scaffold(
        body: ListaGustos(),
      ),
    );
  }

  Widget saveGusto(){
    return Container(
      child: Text(
        '',
        style: TextStyle(fontSize: 20),
      ),
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
              image: AssetImage("assets/images/background4.png"),
              fit: BoxFit.cover,
            ),
          ),
          // alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //lista de gustos por usuario
              Container(
                // child: SingleChildScrollView(
                //   child: FutureBuilder<List>(
                //     future: ,
                //   ),
                // ),
              ),
              Text(
                "GUSTO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xff05668D)),

                // textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(

                  controller: gustosController,
                  validator: (val) => val.isEmpty ? 'Introducir Gusto' : null,

                  onChanged: (val) {
                    print(gustosController);
                  },
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      fillColor: Color(0xffd9d9d9),
                      filled: true)
              ),
              ElevatedButton(

              ),


            ],
          ),
        ),
      ),


    );
  }



}