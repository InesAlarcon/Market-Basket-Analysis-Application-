// @dart=2.9


import 'package:cliente/src/main/gustos/agregarGusto.dart';
import 'package:cliente/src/main/search/searchMenu.dart';
import 'package:cliente/src/main/search/searchMenuTest.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/main/gustos/gustosUsuario.dart';
import 'package:cliente/src/services/firestoreStart.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MainMenu extends StatefulWidget {
MainMenu({Key key, this.title, /*required this.uid*/}) : super(key: key);

// final String uid;
final String title;

@override
MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>{

  String docuid='';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchBy(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==  true) {
          if (element['name'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }

      });

    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }

  }


  void searchTest(){
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Container(
              height: 120,
              padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10
              ),
              width: MediaQuery.of(context).size.width,
              // color: Colors.white,
              decoration: BoxDecoration(

                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                color: Color(0xff00528E),),

              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      height: 50,
                      child: Card(
                        child: TextField(
                          onChanged: (val){
                            print(val);
                            initiateSearch(val);
                          },
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                  ),

                ],
              ),
            ),
            new Expanded(
                child:
                ListView(

                  // crossAxisCount: 2,
                  // crossAxisSpacing: 4,
                  // mainAxisSpacing: 4,

                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    // itemCount: queryResultSet.length,
                    // itemBuilder: (context,_){
                    //    child ListView(
                    shrinkWrap: true,
                    //      physics: ScrollPhysics(),
                    children: tempSearchStore.map((element) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            element['name'],
                            textAlign: TextAlign.center,

                          ),
                          trailing: IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.star,color: Colors.indigoAccent,),
                          ),
                        ),

                      );
                    }

                    ).toList()
                  // );
                  // },


                )
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: 15,
              //   physics: ScrollPhysics(),
              //   itemBuilder: (BuildContext context, int index){
              //
              //     return Card(
              //       color: Colors.white,
              //       child: ListTile(
              //         title: Text(
              //           "Recomendacion ${index+1}",
              //         ),
              //       ),
              //     );
              //   },
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,


            ),
            // ),
            // ),
            // ),
            // ),

            // ),

          ],

        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }


  void searchBar(){
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Container(
              height: 120,
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10
              ),
              width: MediaQuery.of(context).size.width,
              // color: Colors.white,
              decoration: BoxDecoration(

              borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(20),
              bottomRight: const Radius.circular(20),
              ),
              color: Color(0xff00528E),),

              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 50,
                    child: Card(
                      child: TextField(
                        onChanged: (val){
                          print(val);
                          initiateSearch(val);
                        },
                        style: TextStyle(fontSize: 25),
                      ),
                    )
                  ),

                ],
              ),
            ),
                new Expanded(
                  child:
                  ListView(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      // crossAxisCount: 2,
                      // crossAxisSpacing: 4.0,
                      // mainAxisSpacing: 4.0,
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            elevation: 2.0,
                            child: Container(
                                child: Center(
                                    child: Text(element['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                    )
                                )
                            )
                        );
                      }).toList())
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: 15,
                  //   physics: ScrollPhysics(),
                  //   itemBuilder: (BuildContext context, int index){
                  //
                  //     return Card(
                  //       color: Colors.white,
                  //       child: ListTile(
                  //         title: Text(
                  //           "Recomendacion ${index+1}",
                  //         ),
                  //       ),
                  //     );
                  //   },
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,


                  ),
                // ),
                // ),
                // ),
                // ),

                // ),

              ],

        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

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

  //menu de abajo
  void settings(){
    showModalBottomSheet(
        context: context,
        builder: (context){
      return Container(
        height: 200,
        margin: new EdgeInsets.only(
          top: 20,
          left: 0,
          right: 0,
            ),
        padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20
        ),
        decoration: BoxDecoration(
            // border: Border(
            //   top: BorderSide(
            //     color: Colors.white,
            //     width: 10,
            //   ),
            //   left: BorderSide(
            //       color: Colors.white,
            //       width: 10,
            //   ),
            //   right: BorderSide(
            //     color: Colors.white,
            //     width: 10,
            //   ),
            // ),
            //
            // border: Border.all(color: Colors.white),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
            color: Color(0xb000528E),

        ),
        // child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Card(
                  color: Color(0xd000528E),
                  child: ListTile(
                    leading: Icon(Icons.account_circle_outlined, color: Colors.white,),
                    title: Text('Usuario', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),

              ),
              Container(
                child: Card(
                  color: Color(0xd000528E),
                  child: ListTile(
                    leading: Icon(Icons.settings, color: Colors.white,),
                    title: Text('Ajustes', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20),),

                  ),
                ),

              ),
            ],
          ),
        // ),
      );
    });
  }

  //drawer izquierdo
  Widget drawerPrincipal(){
    return Theme(data: Theme.of(context).copyWith(
        canvasColor: Colors.blue.withOpacity(0.2),
      ),

      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff055475), Color(0xff02C39A)],
              ),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'OFER',
                  style: GoogleFonts.oswald(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffecf19e),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'PLUS',
                  style: GoogleFonts.oswald(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          ListTile(
            title: Text('Suscripciones', style: TextStyle(color: Colors.white, fontSize: 20),),

          ),
          ListTile(
            title: Text('Gustos', style: TextStyle(color: Colors.white, fontSize: 20),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GustosUsuario(title: '',uid: docuid,)));
            },
          ),
          ListTile(
            title: Text('Calificar Compras', style: TextStyle(color: Colors.white, fontSize: 20),),

          ),
          ListTile(
            title: Text('Puntos', style: TextStyle(color: Colors.white, fontSize: 20),),

            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    int idx = 0;

    FirestoreStart().connectFS2();
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState.openDrawer(),
          icon: Icon(Icons.menu),
        ),



        actions: <Widget>[
          IconButton(
              onPressed: () async {
                // setState(() {
                  // tempSearchStore = [];
                // BusinessDatabaseConnect().getEmpresa();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMenuTest()));

          // return searchBar();
                // });


              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () => settings(),
              icon: Icon(Icons.more_horiz)
          ),
        ],
        centerTitle: false,
        // title: Text(
        //      "search",
        //       style: TextStyle(color: Colors.white),
        //       ),
        backgroundColor: Color(0xff108aa6),
            ),

      drawer: drawerPrincipal(),

      body: Stack(

        children: <Widget> [
          background(),

          Column(
            // shrinkWrap: true,
            children: <Widget>[

                // SizedBox(
                //   height: 250,
                // ),
              SizedBox(
                height: 250,
                child: PageView.builder(
                    itemCount: 5,
                    controller: PageController(viewportFraction: 0.9),
                    onPageChanged: (int index) => setState(() =>  idx = index ),
                    itemBuilder: (_,i){

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),

                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              // boxShadow: <BoxShadow>[
                              //   BoxShadow(
                              //       color: Colors.black,
                              //       offset: Offset(0, 4),
                              //       blurRadius: 10,
                              //       spreadRadius: 2)
                              // ],
                              // border: Border.all(color: Colors.grey, width: 2),
                              image: DecorationImage(
                                image: AssetImage("assets/images/white.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Text(
                              "OFERTA ${i+1}",
                              style: TextStyle(fontSize: 20, color: Colors.black),




                              //AGREGAR SECCION DE RECOMENDACION GUSTOS, FILTRADO POR TAGS DE GUSTOS AGREGADOS



                            ),
                          ),
                        ),


                      );




                    }
                ),
                // child:
              ),


                SizedBox(
                  height: 40,

                ),

                // Container(
                //
                //   child: Center(
                //     SingleChildScrollView(
                //       physics: ScrollPhysics(),
                new Expanded(
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){

                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            "Recomendacion ${index+1}",
                          ),
                        ),
                      );
                    },
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,


                  ),
                ),
                // ),
                // ),
                // ),

                // ),

              ],
            ),
          // ),




          // ),

          ],
          // child: Image.asset("assets/images/background.png"),

        ),

      );




  }


}