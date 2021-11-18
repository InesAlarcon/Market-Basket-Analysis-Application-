// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreStart {


void lista(){
  List<FirebaseApp> apps = Firebase.apps;

  apps.forEach((app) {
    print('App name: ${app.name}');
  });

}

  void connectFS2() async {
    FirebaseApp businessApp = await Firebase.initializeApp(
        name: 'businessApp',
        options: const FirebaseOptions(

            apiKey: 'AIzaSyDpWAq4leLiDPXbVuZKqV4W6NgzW17QxAw',
            appId: '1:389302464783:android:b5fb812aff204c3d614e7a',
            messagingSenderId: '127761987180',
            projectId: 'mbaaenterprise-eea0d'
        )
    );
  }
}