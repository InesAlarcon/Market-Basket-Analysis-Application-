// @dart=2.9


import 'package:cliente/src/main/calificar/calificarCompra.dart';
import 'package:cliente/src/main/gustos/gustosMenu.dart';
import 'package:cliente/src/main/search/searchMenuTest.dart';
import 'package:cliente/src/main/suscripciones/suscripcionMenu.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/main/gustos/gustosUsuario.dart';
import 'package:cliente/src/services/firestoreStart.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class GustosSelect extends StatefulWidget{


  @override
  GustosSelectState createState() => GustosSelectState();
}


class GustosSelectState extends State<GustosSelect>{
  
  static List<String> finalTagList = [];

  
  
  fetch() async {
    List listaEmpresas = await FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').get().then((value) => value.docs);
    for(int i=0;i<listaEmpresas.length;i++){
      FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection("empresa").doc(
        listaEmpresas[i].id.toString()
      ).collection("etiquetas").snapshots().listen((CreateListTags));
    }
  }

  CreateListTags(QuerySnapshot snapshot) async{
    var docs = snapshot.docs;
    for(var doc in docs){
      finalTagList.add(doc.get("etiquetas"));
    }

    print("tags ${finalTagList}");
  }
  
  
  


  @override
  Widget build(BuildContext context) {
    fetch();

    var gridList = finalTagList.toSet().toList();
    return Scaffold(
      body: DragSelectGridView(
              itemCount: gridList.length,
              padding: EdgeInsets.all(10),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context,index,isSelected) {




                // print(allTags);
                return GustoAdder(item: gridList[index],
                  isSelected: isSelected,);
              },
            ),

      );



  }
}










class GustoAdder extends StatefulWidget{
final String item;
final bool isSelected;

const GustoAdder({this.item, this.isSelected});

  @override
  GustoAdderState createState() => GustoAdderState();
}


class GustoAdderState extends State<GustoAdder> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      value: widget.isSelected ? 1 : 0,
      duration: kThemeChangeDuration,
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
  }

  @override
  void didUpdateWidget(GustoAdder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child){
        return Transform.scale(
          scale: scaleAnimation.value,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.isSelected ? 80 : 20),
            child: child
            ),
          );
      },
      child: Container(
      color: Colors.grey.shade200,
        child: Text(widget.item),)
    );


  }
}