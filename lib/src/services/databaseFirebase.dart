import 'package:firebase_auth/firebase_auth.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/user.dart';

class AuthServices{

  final FirebaseAuth auth = FirebaseAuth.instance;

  User? firebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;

  }

  Future registrarUsuario(String usuario, String email, String pass) async {
    try{
      AuthResult authUser = await auth.createUserWithEmailAndPassword( email: email, password: pass);
      FirebaseUser user = authUser.user;
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