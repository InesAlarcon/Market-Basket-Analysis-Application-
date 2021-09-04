// @dart=2.9


import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget{
  @override
  UserSettingsState createState() => UserSettingsState();

}

class UserSettingsState extends State<UserSettings>{


  final formKey = GlobalKey<FormState>();

  Widget background(){
    return Container(
      // height: MediaQuery.of(context).size.height,
      // height: ,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff464646), Color(0xff7c7c7c)]),
        image: DecorationImage(
          image: AssetImage("assets/images/background2.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {



  }

}