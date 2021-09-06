// @dart=2.9

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Empresa {
  String name;

  Empresa(
      this.name,
      );

  Empresa.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot['gusto'];
}

Widget SearchResult(DocumentSnapshot snapshot){
  final empresa = Empresa.fromSnapshot(snapshot);
  print(empresa.name);

  return new Container(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(
              empresa.name,
              textAlign: TextAlign.center,
            ),

          ),
        ),
      ),
  );


}