// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/usuario.dart';
import 'package:cliente/src/main/gustos/gustos.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firestoreStart.dart';

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
      FirestoreStart().connectFS2();
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
      
      // await DatabaseConnect(uid: user.uid).agregarGustos('sin gustos');
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

    // return FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('infoUsuario').doc('username').set({
    return FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).set({
      'username': username,
      'token': "",
    });
  }

  Future agregarGustos(String gusto) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('gustos').doc(gusto);
    return ref.set({
        // 'docID': ref.id,
        'gusto': gusto,
    });
  }

  Future agregarSuscripcion(String sus, double rating, int vote, String id) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('suscripciones').doc(id);
    return ref.set({
      'id': id,
      'empresa': sus,
      'rating': rating,
      'voteCount': false,
      'notifs': true,
    });
  }
  Future quitarSuscripcion(String sus, double rating, int vote, String id) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('suscripciones').doc(sus);
    return ref.set({
      'id': id,
      'empresa': sus,
      'rating': rating,
      'voteCount': vote,
      'notifs': false,
    });
  }

  Future modificarNotificacion(String sus, bool notifs) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('suscripciones').doc(sus);
    return ref.update({
      'notifs': notifs,
    });
  }

  Future ratingSubs(String sus, double rating, bool vote) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('ratings').doc(sus);
    return ref.set({
      'rating': rating,
      'voteCount': vote,
    });
  }


  Future likeOferta(String id, bool like, bool estado, bool used, int limit) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('ofertas').doc(id);
    // var query= await FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('ofertas').doc(id).get();

    var ret;
    ref.get().then((snap) => {

      if(snap.exists){
        if(estado){
          if(used){
            if(!(snap.get('limite')==0)){
              ret = ref.update({
                'limite': snap.get('limite')-1,
              })
            }else{
              ret = ref.update({
                'estado': false,
              })
            }
          },
          if(!like){
            ret = ref.update({
              'like': like,
            }),
          }else{
            ret = ref.update({
              'like': like,
            }),
          }

        }else{
          ret = ref.update({
            'estado': false,
          })
        }
      }else{
        if(used){
          ret = ref.set({
            'like':true,
            'ofertaID': id,
            'estado': estado,
            'limite': limit-1,
          })
        }else{
          ret = ref.set({
            'like':true,
            'ofertaID': id,
            'estado': estado,
            'limite': limit,
          })
        }

      }

    });

    return ret;

  }

  Future quitarOferta(String id) async {
    final ref = FirebaseFirestore.instanceFor(app: clientApp).collection('usuario').doc(uid).collection('ofertas').doc(id);
    return ref.set({
      'ofertaID': id,
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
  
  Future<List> getAllTags(empID) async{
    print(empID);
    QuerySnapshot query = await FirebaseFirestore.instanceFor(app: businessApp).collection("empresa").doc(empID).collection("etiquetas").get();
    final allTags = query.docs.map((e) => e.get("etiquetas")).toList();
    // print(allTags);
    return allTags;
    
  }

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
    double rate = 4.0;
    final ref = FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(empresa);
    return ref.set({
      'nombre': empresa,
      'searchKey': empresa.substring(0,1).toUpperCase(),
      'rating': rate,

    });
  }

  Future voteEmpresa(String docId, bool voteVal) async{

    int vote=0;
    
    var ref = FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(docId);
    var query= await FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(docId).get();

    var data = query.data();
    print(data['voteCount']);

    if(voteVal){
      vote = data['voteCount']+1;


    }else{
      vote = data['voteCount']-1;
    }



    return ref.update({
      'voteCount': vote,

    });
  }

  Future subEmpresa(String docId, bool voteVal) async{

    int vote=0;

    var ref = FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(docId);
    var query= await FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(docId).get();

    var data = query.data();
    print(data['subCount']);

    if(voteVal){
      vote = data['subCount']+1;


    }else{
      vote = data['subCount']-1;
    }



    return ref.update({
      'subCount': vote,

    });
  }

  Future rateEmpresa(String docId, bool voteVal, double rate) async{

    double vote=0;

    var ref = FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(docId);
    var query= await FirebaseFirestore.instanceFor(app: businessApp).collection('empresa').doc(docId).get();

    var data = query.data();
    print(data['defaultRating']);

    if(voteVal){
      vote = ((data['defaultRating']*(data["voteCount"]-1))+rate)/data['voteCount'];


    }else if(!voteVal){
      if((data["voteCount"]-1)==0){
        vote = 0;
      }else{
        vote = ((data['defaultRating']*(data['voteCount']))-rate)/(data["voteCount"]-1);
      }
    }



    return ref.update({
      'defaultRating': vote,

    });
  }

  Future likeOferta(String docId, String ofId, bool voteVal) async{
    int vote=0;

    var ref = FirebaseFirestore.instanceFor(app: businessApp).collection('ofertas').doc(docId).collection("ofertas").doc(ofId);
    var query= await FirebaseFirestore.instanceFor(app: businessApp).collection('ofertas').doc(docId).collection("ofertas").doc(ofId).get();

    var data = query.data();
    print(data['votos']);

    if(voteVal){
      vote = data['votos']+1;


    }else{
      vote = data['votos']-1;
    }



    return ref.update({
      'votos': vote,

    });
  }
  Future useOferta(String docId, String ofId, bool voteVal) async{
    int vote=0;
    var value;
    double totalsold = 0.0;

    var ref = FirebaseFirestore.instanceFor(app: businessApp).collection('ofertas').doc(docId).collection("ofertas").doc(ofId);
    var query= await FirebaseFirestore.instanceFor(app: businessApp).collection('ofertas').doc(docId).collection("ofertas").doc(ofId).get();

    var data = query.data();
    print(data['totalCount']);

    if(voteVal){
      vote = data['totalCount']+1;
      value = data['valor']+0.0;
      // value = int.parse(data['valor'])+0.0;
      totalsold = vote*value;


    }else{
      vote = data['totalCount'];
    }



    return ref.update({
      'totalCount': vote,
      'totalSold': totalsold,


    });
  }

}