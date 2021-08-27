// @dart=2.9


import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/verGustos.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cliente/src/main/gustos/gustos.dart';

class GustoTile extends StatefulWidget {
  GustoTile({this.gusto, this.uid});

  final String gusto;
  final String uid;



  @override
  GustoTileState createState() => GustoTileState();

}

class GustoTileState extends State<GustoTile>{

  String uid;
  String gusto;

  @override
  void initState(){
    uid = widget.uid;
    gusto = widget.gusto;
    super.initState();
  }



  @override
  Widget build(BuildContext context){


    RegExp expGusto = new RegExp(r"({gusto: )|(\,(.*))");
    RegExp expID = new RegExp(r"(\{(.*)(docID: ))|(})");
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('usuario').doc(uid).collection('gustos').snapshots(),
        builder: (context, snapshot){

          return new Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                // leading: CircleAvatar(
                //   radius: 25.0,
                //   backgroundColor: Colors.grey.shade50,
                // ),
                title: Text(gusto.replaceAll(expGusto,''), textAlign: TextAlign.center,),
                trailing: InkWell(
                  child: Icon(Icons.delete_forever_sharp, color: Colors.redAccent,),
                  onTap: () async {
                      // FirebaseFirestore.instance.collection('usuario').doc(uid).collection('gustos').doc(gusto.replaceAll(expID, '')).delete();
                   FirebaseFirestore.instance.collection('usuario').doc(uid).collection('gustos').doc(gusto.replaceAll(expID, '')).delete().then((value){
                    print(gusto.replaceAll(expID, ''));
                    print("Success!");
                  });
                   setState(() {
                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerGustos()));
                   });

              }),


                  //
                  // onPressed: (){
                  //
                  // },
                ),

              ),
            );

        }

    );


  }
}