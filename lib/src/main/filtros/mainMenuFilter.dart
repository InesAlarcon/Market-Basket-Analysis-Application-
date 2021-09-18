// @dart=2.9
import 'dart:io';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../usuario.dart';
import 'package:get/get.dart';

class EmpresaController extends GetxController {
  var _selectedEmpresa = 0.obs;
  get selectedEmpresa => this._selectedEmpresa.value;
  set selectedEmpresa(index) => this._selectedEmpresa.value = index;
  
  
}


class FirestoreController extends GetxController {
  //referance to firestore collection here laptop is collection name
  final CollectionReference empresas = FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa');

  var empresaList = <EmpresaRecommend>[].obs;

  //dependency injection with getx
  EmpresaController _EmpresaController = Get.put(EmpresaController());

  
  
  @override
  void onInit() {
    //binding to stream so that we can listen to realtime cahnges

    empresaList.bindStream(
        getEmpresas(Filtros.values[_EmpresaController.selectedEmpresa], null));
    super.onInit();
  }

  
  var listaRecRating = [];

  void gustosVerify(context) async {
    RegExp expGusto = new RegExp(r"({gusto: )|(})");

    final user = Provider.of<Usuario>(context);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').get();

    listaRecRating = snapshot.docs.map((doc) {
      String gustos = doc.data().toString().replaceAll(expGusto, '');
      return gustos;
    }).toList();
    print(listaRecRating);
  }

// this fuction retuns stream of laptop lsit from firestore

  Stream<List<EmpresaRecommend>> getEmpresas(Filtros gusto, context) {
    gustosVerify(context);
    //using enum class Filtros in switch case
    switch (gusto) {
      case Filtros.TODO:
        Stream<QuerySnapshot> stream = empresas.snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return EmpresaRecommend.fromDocumentSnapshot(snap);
        }).toList());
      case Filtros.GUSTOS:
        Stream<QuerySnapshot> stream =
        empresas.where('type', isEqualTo: listaRecRating[1]).snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return EmpresaRecommend.fromDocumentSnapshot(snap);
        }).toList());

    }
  }
}