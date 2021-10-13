// @dart=2.9

import 'package:cliente/src/main/gustos/verGustos.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/services/firestoreStart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/gustos.dart';
import 'package:cliente/src/usuario.dart';

class CalificarCompra extends StatefulWidget{
  CalificarCompra({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;



  @override
  CalificarCompraState createState() => CalificarCompraState();
}

class CalificarCompraState extends State<CalificarCompra>{




  final gustosController = TextEditingController();





  Widget saveGusto(String user){

    // FirestoreStart().connectFS2();

    // print("USER "+user);
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
              'buscar',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: () async {
        try{
          // print("USER "+user);
          // BusinessDatabaseConnect().getOfertas();

          // BusinessDatabaseConnect().agregarEmpresa(gustosController.text);
          // DatabaseConnect(uid: user).agregarGustos(gustosController.text);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => VerGustos( /*uid: uid*/)));
          }catch(e){
          print(e.toString());
          return null;
         }

      },
    );
  }

  @override
  Widget build(BuildContext context){
    final user = Provider.of<Usuario>(context);

    BusinessDatabaseConnect().getOfertas();

    // return StreamBuilder<UserData>(
    //   stream: DatabaseConnect(uid: user.uid).userData,
    //   builder: (context, snapshot){
    //
    //     if(snapshot.hasData){
    //
    //     }

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
                  //lista de gustos por usuario
                  Container(
                    // child: SingleChildScrollView(
                    //   child: FutureBuilder<List>(
                    //     future: ,
                    //   ),
                    // ),
                  ),
                  Text(
                    "No. de Factura",
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
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          fillColor: Color(0xffd9d9d9),
                          filled: true)
                  ),
                  SizedBox(height: 10,),


                  saveGusto(user.uid),


                ],
              ),
            ),
          ),


        );
      // },


    // );


  }



}