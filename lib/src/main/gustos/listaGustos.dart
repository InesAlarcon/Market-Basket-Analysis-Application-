// @dart=2.9

import 'dart:collection';

import 'package:cliente/src/main/gustos/gustosUsuario.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cliente/src/usuario.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/gustos.dart';
import 'package:cliente/src/main/gustos/gustoTile.dart';

class ListaGustos extends StatefulWidget{

  @override
  ListaGustosState createState() => ListaGustosState();

}

class ListaGustosState extends State<ListaGustos> {

  // ignore: deprecated_member_use
  var listaGustos = [];
  var listaDocs = [];

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
              'Login',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: () async {

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GustosUsuario(title: '', /*uid: uid*/)));

      },
    );
  }

  void listaAwait(String uid) async {
    // final userdata = List<dynamic>

    Future<List> listGustos = DatabaseConnect(uid: uid).getData();
    List list = await listGustos;
    // setState(() {
      listaGustos = list;

    // });
     // print(listaGustos);


  }

 Widget listBuilderSwipe(String uid){
   RegExp expGusto = new RegExp(r"({gusto: )|(\,(.*)|(}))");
   RegExp expID = new RegExp(r"(\{(.*)(docID: ))|(})");

   return ListView.builder(
       physics: const ScrollPhysics(),
       itemCount: listaGustos.length,
       itemBuilder: (context, index) {
         return Dismissible(
           key: /*Key(listaGustos[index].toString())*/UniqueKey(),
           onDismissed: (direction)  {


             setState(()  {
               FirebaseFirestore.instance.collection('usuario').doc(uid).collection('gustos').doc(listaGustos[index].toString().replaceAll(expGusto, '')).delete();
               listaGustos.removeAt(index);
             });
             ScaffoldMessenger.of(context)
                 .showSnackBar(SnackBar(content: Text('Gusto Eliminado')));


           },
           background: Container(color: Colors.red),
           child: new Padding(
             padding: EdgeInsets.only(top: 8.0),
             child: Card(
               margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
               child: ListTile(
                 // leading: CircleAvatar(
                 //   radius: 25.0,
                 //   backgroundColor: Colors.grey.shade50,
                 // ),
                 title: Text(listaGustos[index].toString().replaceAll(expGusto,''), textAlign: TextAlign.center,),
                 // trailing: InkWell(
                 //     child: Icon(Icons.delete_forever_sharp, color: Colors.redAccent,),
                 //     ),


                 //
                 // onPressed: (){
                 //
                 // },
               ),

             ),
           ),
         );

       }


   );

 }

  @override
  Widget build(BuildContext context){
    final gustos = Provider.of<List<Gustos>>(context) ?? [];
    final user = Provider.of<Usuario>(context);
    listaAwait(user.uid);
    // listaDocsAwait(user.uid);
    // print("Lista: ");
    // print(user.uid);
    print(listaGustos.length);

    print(listaGustos);


    // DatabaseConnect(uid: user.uid).agregarGustos("cereal");

    // DatabaseConnect().getData(user.uid);

    // BusinessDatabaseConnect().getOfertas();
    //
    // gustos.forEach((gusto) {
    //   print(gusto.gusto);
    // });

    // ListView.builder(
    //   itemCount: gustos.length,
    //   itemBuilder: (context, index) {
    //     return GustoTile(gusto: gustos[index]);
    //   },
    //
    // );


    return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            // title: Text(
            //      "search",
            //       style: TextStyle(color: Colors.white),
            //       ),
            backgroundColor: Color(0xff108aa6),
          ),
          body: Stack(
            children: <Widget>[
              background(),
              Center(
                child: Container(

                  child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').snapshots(),
                          builder: (context, snapshot) {
                            return listBuilderSwipe(user.uid);





                      // return GustoTile(gusto: listaGustos[index].toString(), uid: user.uid);
                    },
                  ),
                ),
              ),
            SizedBox(height: 20),
              // botonAgregarGusto(),
            ],
          ),


        );




  }
}