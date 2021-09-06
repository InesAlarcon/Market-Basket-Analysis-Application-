// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/usuario.dart';
import 'package:cliente/src/main/gustos/gustos.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices{




  final FirebaseAuth auth = FirebaseAuth.instance;

  // Future<Firestore> connectFS1() async {
  //
  //   final FirebaseApp shared = await FirebaseApp.configure(name: 'shared-project',
  //     options: FirebaseOptions(
  //       apiKey: "AIzaSyBBWORx3QijzF9mOHcf6pHqBNT4mMW9hIM",
  //       projectID: "com.mbasuscriber.clientapp",
  //       googleAppID: "1:389302464783:android:b5fb812aff204c3d614e7a",
  //     ),
  //   );
  //   print("Connection Completed");
  //   return Firestore(app: shared);
  // }


  Usuario firebaseUser(User user){
    return user != null ? Usuario(uid: user.uid) : null;

  }

  Stream<Usuario> get user{
    // return auth.onAuthStateChanged.map((FirebaseUser user) => firebaseUser(user));

    return auth.userChanges().map((firebaseUser));
    // return auth.authStateChanges.map((firebaseUser));

  }

  //verificar si el usuario se puede login
  Future loginUsuario(String usuario, String email, String pass) async {
    // Firebase.initializeApp(
    //       name: 'clientApp',
    //       options: const FirebaseOptions(
    //           apiKey: 'AIzaSyBBWORx3QijzF9mOHcf6pHqBNT4mMW9hIM',
    //           appId: '1:389302464783:android:b5fb812aff204c3d614e7a',
    //           messagingSenderId: '389302464783',
    //           projectId: 'clientloginauth'
    //       )
    //   );
    try{
      UserCredential authUser = await auth.signInWithEmailAndPassword( email: email, password: pass);
      User user = authUser.user;
      return firebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }

  }



  //registro de usuarios
  Future registrarUsuario(String usuario, String email, String pass) async {
    // Firebase.initializeApp(
    //     name: 'clientApp',
    //     options: const FirebaseOptions(
    //         apiKey: 'AIzaSyBBWORx3QijzF9mOHcf6pHqBNT4mMW9hIM',
    //         appId: '1:389302464783:android:b5fb812aff204c3d614e7a',
    //         messagingSenderId: '389302464783',
    //         projectId: 'clientloginauth'
    //     )
    // );
    try{
      UserCredential authUser = await auth.createUserWithEmailAndPassword( email: email, password: pass);
      User user = authUser.user;
      
      await DatabaseConnect(uid: user.uid).agregarGustos('sin gustos');
      await DatabaseConnect(uid: user.uid).agregarUserInfo(usuario);

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


  DatabaseConnect({this.uid});
  final String uid;




  final FirebaseApp clientApp = Firebase.app('clientApp');
  //
  //final CollectionReference userCol = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario');
  //



  Future agregarUserInfo(String username) async{

    return FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('infoUsuario').doc('username').set({
      'username': username,
    });
  }

  Future agregarGustos(String gusto) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('gustos').doc(gusto);
    return ref.set({
        // 'docID': ref.id,
        'gusto': gusto,
    });
  }

  Future agregarSuscripcion(String sus) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('suscripciones').doc(sus);
    return ref.set({
      // 'docID': ref.id,
      'empresa': sus,
    });
  }

  Future<List> getData() async{
    QuerySnapshot query =  await FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('gustos').get();
    final allData = query.docs.map((doc) => doc.data()).toList();

    // return query.documents.map((docs) {
    //   return Gustos(
    //     gusto: docs.data['gusto'] ?? '',
    //   );
    // }).toList();

    // print(allData);
    return allData;

  }


  Future<String> getUser(String usr) async{
    var query =  await FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('infoUsuario').doc('username').get();
    final usrName = query.toString();

    print(usrName);
    return usrName;

  }

  void deleteDocID(String docID) async{
      var snapshot = await FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('gustos').doc(docID).delete().then((value){
      print(docID);
      print("Success!");
    }
    );
  }

  // List<>
//
  List<Gustos> listaGustosSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((docs){
      return Gustos(
        gusto: docs.data(),
      );
    }).toList();
  }
//
//
//   UserData gustoUsuarioSnapshot(DocumentSnapshot snapshot){
//     return UserData(
//       user: uid,
//       gustos: snapshot.data['gusto'],
//     );
//   }
//
  Stream<List<Gustos>> get gustos {
    return FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').snapshots().map(listaGustosSnapshot);

      // userCol.document(uid).collection('gustos').snapshots().map(listaGustosSnapshot);
    // return userCol.snapshots().map(listaGustosSnapshot);
  }
//
//   Stream<UserData> get userData {
//     return userCol.document(uid).snapshots().map(gustoUsuarioSnapshot);
//   }
//
}


class BusinessDatabaseConnect{

  FirebaseApp businessApp = Firebase.app('businessApp');

  Future<List> getOfertas() async{
    // FirebaseApp businessApp = Firebase.app('businessApp');

    QuerySnapshot query = await FirebaseFirestore.instanceFor(app: businessApp).collection('ofertas').get();
    final allOfertas = query.docs.map((doc) => doc.data()).toList();

    print(allOfertas);
    return allOfertas;

  }

  Future<List> getEmpresa() async{
    // FirebaseApp businessApp = Firebase.app('businessApp');

    QuerySnapshot query = await FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').get();
    final allOfertas = query.docs.map((doc) => doc.data()).toList();

    print(allOfertas);
    return allOfertas;

  }

  Future agregarEmpresa(String empresa) async{
    // FirebaseApp businessApp = Firebase.app('businessApp');

    final ref = FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(empresa);
    return ref.set({
      'name': empresa,
      'searchKey': empresa.substring(0,1).toUpperCase(),
    });
  }
}