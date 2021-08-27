// @dart=2.9

import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/gustos/listaGustos.dart';
import 'package:cliente/src/main/gustos/gustos.dart';

class VerGustos extends StatefulWidget{
  VerGustos({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;



  @override
  VerGustosState createState() => VerGustosState();
}

class VerGustosState extends State<VerGustos>{




  @override
  Widget build(BuildContext context){
    return StreamProvider<List<Gustos>>.value(
      initialData: null,
      value: DatabaseConnect().gustos,
      child: Scaffold(
        body: ListaGustos(),
      ),
    );

  }
}