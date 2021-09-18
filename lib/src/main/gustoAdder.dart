// // @dart=2.9
//
//
// import 'package:cliente/src/main/gustos/agregarGusto.dart';
// import 'package:cliente/src/main/gustos/gustosMenu.dart';
// import 'package:cliente/src/main/search/searchMenuTest.dart';
// import 'package:cliente/src/main/suscripciones/suscripcionMenu.dart';
// import 'package:cliente/src/services/databaseFirebase.dart';
// import 'package:cliente/src/main/gustos/gustosUsuario.dart';
// import 'package:cliente/src/services/firestoreStart.dart';
// import 'package:cliente/src/services/searchService.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// class RatingSub extends StatefulWidget{
//
//
//   @override
//   RatingSubState createState() => RatingSubState();
// }
//
// class RatingSubState extends State<RatingSub>{
//
//   Widget background(){
//     return Container(
//       // height: MediaQuery.of(context).size.height,
//       // height: ,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xff464646), Color(0xff7c7c7c)]),
//         image: DecorationImage(
//           image: AssetImage("assets/images/background2.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context){
//
//
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         // title: Text(
//         //      "search",
//         //       style: TextStyle(color: Colors.white),
//         //       ),
//         backgroundColor: Color(0xff108aa6),
//       ),
//       body: Stack(
//         children: <Widget>[
//           background(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               RatingBar.builder(
//                 itemSize: 10,
//                 initialRating: empresaRate,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 itemBuilder: (context, _) => Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 onRatingUpdate: (rating) {
//                   print(rating);
//                 },
//               ),
//               Container(
//                   color: Colors.white,
//                   height: 40,
//                   width: 200,
//                   child: RatingBarIndicator(
//                     rating: 3,
//                     itemBuilder: (context, index) => Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     itemCount: 5,
//                     itemSize: 10,
//                     itemPadding: EdgeInsets.all(4),
//                   )
//               ),
//             ],
//           ),
//         ],
//
//       ),
//     );
//
//   }
//
//
//
// }