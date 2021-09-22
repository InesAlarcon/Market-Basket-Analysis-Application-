// @dart=2.9


import 'package:cliente/src/main/gustos/agregarGusto.dart';
import 'package:cliente/src/main/gustos/gustosMenu.dart';
import 'package:cliente/src/main/negocio/negocioPage.dart';
import 'package:cliente/src/main/search/searchMenuTest.dart';
import 'package:cliente/src/main/search/searchResult.dart';
import 'package:cliente/src/main/suscripciones/ratingSub.dart';
import 'package:cliente/src/main/suscripciones/suscripcionMenu.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/main/gustos/gustosUsuario.dart';
import 'package:cliente/src/services/firestoreStart.dart';
import 'package:cliente/src/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cliente/src/usuario.dart';


class MainMenu extends StatefulWidget {
MainMenu({Key key, this.title, /*required this.uid*/}) : super(key: key);


  final String title;

@override
MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>{

  String docuid='';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();


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

          Container(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Color(0xa000528E),
              child: ListTile(
                title: Text('Suscripciones', style: TextStyle(color: Colors.white, fontSize: 20),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SuscripcionMenu()));
                },
              ),
            ),
          ),
          Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              color: Color(0xa000528E),
              child: ListTile(
                title: Text('Gustos', style: TextStyle(color: Colors.white, fontSize: 20),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GustosUsuario(title: '',uid: docuid,)));
                },
              ),
            ),
          ),

          Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              color: Color(0xa000528E),
              child: ListTile(
                 title: Text('Calificar Compras', style: TextStyle(color: Colors.white, fontSize: 20),),

                  ),
            ),
          ),
          Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              color: Color(0xa000528E),
              child: ListTile(
                    title: Text('Puntos', style: TextStyle(color: Colors.white, fontSize: 20),),

                ),
              ),
            ),
          ],
        )
      ),
    );
  }


  var listaRecRating = [];
  var finalList = [];

  void gustosVerify(context) async {
    RegExp expGusto = new RegExp(r"({gusto: )|(})");

    final user = Provider.of<Usuario>(context);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').get();

    listaRecRating = snapshot.docs.map((doc) {
      String gustos = doc.data().toString().replaceAll(expGusto, '');
      return gustos;
    }).toList();
    // print(listaRecRating);
  }



  Widget buildListRec(QuerySnapshot snapshot1, QuerySnapshot snapshot2, String uid){
    final user = Provider.of<Usuario>(context);
    var listaFiltro = [];
    // print(snapshot2.size);
    for(int i = 0; i < snapshot1.size; i++){
      // print(snapshot1.docs[i].id);
      for(int j = 0; j < snapshot2.size; j++){
        // print(snapshot2.docs[j]["gusto"]);
        if(snapshot2.docs[j]["gusto"]==snapshot1.docs[i]["type"]){
          // print(snapshot1.docs[i]["type"]);
          listaFiltro.add(snapshot1.docs[i]["type"]);
        }
      }

    }


    return ListView.builder(
        itemCount: snapshot1.docs.length,
        // ignore: missing_return
        itemBuilder: (context, index){
          final doc = snapshot1.docs[index];
          final double num = doc["defaultRating"]+0.0;
          if(listaFiltro.isNotEmpty){
            if(listaFiltro.contains(doc["type"])){
              return new InkWell(
                onTap: ()  {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id,)));
                },

                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(10))

                  ),

                  margin: EdgeInsets.all(10),

                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 170,
                        // color: Colors.amber,
                        alignment: Alignment.topLeft,
                        child: Text(
                          doc["nombre"],
                          // textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          RatingBarIndicator(
                            rating: num,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.all(1),
                          ),


                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        // color: Colors.red,
                          child: Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Color(0xff108aa6),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(10),

                                  ),
                                ),
                                child: IconButton(

                                  onPressed: (){
                                    print(doc.id);
                                    final int voteC = doc["voteCount"]+1;
                                    final bool vote = true;
                                    DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                                    BusinessDatabaseConnect().voteEmpresa(doc.id, vote);
                                    setState(() {
                                      // changeIcon();

                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                                  },
                                  icon: Icon(Icons.add, color: Colors.white,),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              );
            }
          }
          else{
            return new InkWell(
                onTap: ()  {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => NegocioPage(pageid: doc.id,)));
                      // context, MaterialPageRoute(builder: (context) => RatingSub()));
                },

                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(10))

                  ),

                  margin: EdgeInsets.all(10),

                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 170,
                        // color: Colors.amber,
                        alignment: Alignment.topLeft,
                        child: Text(
                          doc["nombre"],
                          // textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          RatingBarIndicator(
                            rating: num,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.all(1),
                          ),


                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          // color: Colors.red,
                          child: Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Color(0xff108aa6),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(10),

                                  ),
                                ),
                                child: IconButton(

                                  onPressed: (){
                                    print(doc.id);
                                    final int voteC = doc["voteCount"]+1;
                                    // ignore: missing_return
                                    final bool vote = true;
                                    DatabaseConnect(uid: user.uid).agregarSuscripcion(doc['nombre'], num, voteC, doc.id);
                                    BusinessDatabaseConnect().voteEmpresa(doc.id, vote);
                                    setState(() {
                                      // changeIcon();

                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('Suscrito a ${doc['nombre']}')));
                                  },
                                  icon: Icon(Icons.add, color: Colors.white,),
                                ),
                              ),
                            ),
                          )),


                    ],
                  ),
                )
            );
          }

        }

    );


  }


  void showAlert(BuildContext context){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context)
      {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white
                        ),
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                        child: Text("Seleccionar gustos iniciales",
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center
                        ),
                      ),
                    ],
                  ),




              ],
            )
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context);
    int idx = 0;

    FirestoreStart().connectFS2();
    // gustosVerify(context);
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuario').doc(user.uid).collection('gustos').snapshots(),
        builder: (context, snapshot2){
          var dataGustos = snapshot2.data;


          if(dataGustos.size<3){
            Future.delayed(Duration.zero, ()=> showAlert(context));
          }




          return Stack(

          children: <Widget> [
            background(),

            Column(

              // shrinkWrap: true,
              children: [


                  // SizedBox(
                  //   height: 250,
                  // ),
                SizedBox(
                  height: 170,
                  child: PageView.builder(
                      itemCount: 5,
                      controller: PageController(/*viewportFraction: 0.9*/),
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
                                  image: AssetImage("assets/images/darkblue.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Text(
                                "OFERTA ${i+1}",
                                style: TextStyle(fontSize: 20, color: Colors.white),




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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instanceFor(app: Firebase.app('businessApp')).collection('empresa').snapshots(),
                    builder: (context, snapshot1){



                            if(!snapshot1.hasData) return LinearProgressIndicator();
                            return Expanded(child: buildListRec(snapshot1.data, snapshot2.data, user.uid));
                          }
                      ),
                      // gustosVerify(context);
                      // if(!snapshot.hasData) return LinearProgressIndicator();
                      // return Expanded(child: buildListRec(snapshot.data));


                  // new Expanded(
                  //   child:
                  //   ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: empresas.length,
                  //     physics: ScrollPhysics(),
                  //     itemBuilder: (BuildContext context, int index){
                  //
                  //       return recommendEmpresa(empresas[index], context);
                  //     },
                  //     // crossAxisAlignment: CrossAxisAlignment.center,
                  //     // mainAxisAlignment: MainAxisAlignment.center,
                  //
                  //
                  //   ),
                  // ),
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

          );}
        ),

      );




  }


}