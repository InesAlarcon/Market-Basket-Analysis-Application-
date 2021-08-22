// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/user.dart';
import 'package:cliente/src/main/gustos/gustos.dart';

class AuthServices{

  final FirebaseAuth auth = FirebaseAuth.instance;

  User firebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;

  }

  Stream<User> get user{
    // return auth.onAuthStateChanged.map((FirebaseUser user) => firebaseUser(user));
    return auth.onAuthStateChanged.map((firebaseUser));

  }

  //verificar si el usuario se puede login
  Future loginUsuario(String usuario, String email, String pass) async {
    try{
      AuthResult authUser = await auth.signInWithEmailAndPassword( email: email, password: pass);
      FirebaseUser user = authUser.user;
      return firebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }

  }



  //registro de usuarios
  Future registrarUsuario(String usuario, String email, String pass) async {
    try{
      AuthResult authUser = await auth.createUserWithEmailAndPassword( email: email, password: pass);
      FirebaseUser user = authUser.user;
      
      await DatabaseConnect(uid: user.uid).agregarGustos('sin gustos');
      return firebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }

  }

}
//
// class DatabaseServices {
//
// //Referencia a la coleccion
// final CollectionReference usuarios = Firestore.instance.collection('users');
//
// Future updateUsuario(DateTime birth, String gustos, String)
//
//
// }

class DatabaseConnect {

  final String uid;
  DatabaseConnect({this.uid});

  final CollectionReference gustosCol = Firestore.instance.collection('gustos');

  Future agregarGustos(String gusto) async {
    return await gustosCol.document(uid).setData({
      'gusto': gusto,
    });
  }

  List<Gustos> listaGustosSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((docs){
      return Gustos(
        gusto: docs.data['gusto'] ?? '',
      );
    }).toList();
  }


  Stream<List<Gustos>> get gustos {
    return gustosCol.snapshots().map(listaGustosSnapshot);
  }

}