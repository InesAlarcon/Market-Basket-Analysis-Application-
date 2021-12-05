import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SearchService {

  searchBy(String searchField){
    return FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').where(
        'searchKey',isEqualTo: searchField.substring(0,1).toUpperCase()
    ).get();
  }

  searchByID(String searchField){
    return FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').where(
        'id',isEqualTo: searchField
    ).get();
  }

  getByID(String searchField){
    return FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').doc(searchField).get();
  }




 


}