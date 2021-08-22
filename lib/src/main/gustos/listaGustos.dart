// @dart=2.9

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/gustos.dart';

class ListaGustos extends StatefulWidget{

  @override
  ListaGustosState createState() => ListaGustosState();

}

class ListaGustosState extends State<ListaGustos> {

  @override
  Widget build(BuildContext context){
    final gustos = Provider.of<List<Gustos>>(context);
    // for (var docs in gustos.documents){
    //   print(docs.data);
    // }
    gustos.forEach((gusto) {
      print(gusto.gusto);
    });
    
    return Container(

    );

  }
}