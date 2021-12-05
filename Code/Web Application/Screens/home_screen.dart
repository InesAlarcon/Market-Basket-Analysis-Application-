import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:mbaa/widgets/custom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin{

  late TabController _tabController;

  final firestoreInstance = FirebaseFirestore.instance;
  String doc_id = '0';
  String id = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'MARKET BASKET ANALYSIS',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 35,
            ),
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  //rating general
                  Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: HexColor("#FF9671"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: Icon(
                              Icons.star_rate,
                              color: Colors.white70,
                              size: 50,
                              semanticLabel: 'Total Vendido Ofertas',
                            )
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: firestoreInstance.collection('empresa').doc(id).snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return Text("Aún no existen datos registrados", style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                ));
                              }

                              if (snapshot.connectionState == ConnectionState.active) {
                                var userDocument = snapshot.data;
                                return Text(
                                  userDocument!["defaultRating"].toString(),
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 40
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator(),);
                            },
                          )
                        )
                      ],
                    ),
                  ),
                  // cantidad votos
                  Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: HexColor("#FFD687"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: Icon(
                              Icons.how_to_vote,
                              color: Colors.white70,
                              size: 50,
                              semanticLabel: 'Votos',
                            )
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: firestoreInstance.collection('empresa').doc(id).snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return Text("Aún no existen datos registrados",style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                ));
                              }

                              if (snapshot.connectionState == ConnectionState.active) {
                                var userDocument = snapshot.data;
                                return Text(
                                  userDocument!["voteCount"].toString(),
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 40
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator(),);
                            },
                          )
                        )
                      ],
                    ),
                  ),
                  // clientes suscritos
                  Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: HexColor("#66C7D3"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: Icon(
                              Icons.subscriptions,
                              color: Colors.white70,
                              size: 50,
                              semanticLabel: 'Total Vendido Ofertas',
                            )
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: firestoreInstance.collection('empresa').doc(id).snapshots(),
                              builder:
                                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData && !snapshot.data!.exists) {
                                  return Text("Aún no existen datos registrados", style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300,
                                  ));
                                }

                                if (snapshot.connectionState == ConnectionState.active) {
                                  var userDocument = snapshot.data;
                                  return Text(
                                    userDocument!["subCount"].toString(),
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Open Sans',
                                        fontSize: 40
                                    ),
                                  );
                                }
                                return Center(child: CircularProgressIndicator(),);
                              },
                            )
                        )
                      ],
                    ),
                  ),
                  // ofertas vendidas
                  Container(
                    height: 250,
                    width: 700,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: HexColor("#7C8AB7"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: Icon(
                              Icons.point_of_sale_sharp,
                              color: Colors.white70,
                              size: 50,
                              semanticLabel: 'Total Vendido Ofertas',
                            )
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('ofertas')
                              .doc(id)
                              .collection('ofertas')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot doc = snapshot.data!.docs[index];
                                    return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          height: 25,
                                          child: Text("Detalle Ofertas",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          height: 25,
                                          color: Colors.white60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Oferta",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(doc['nombre']),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                          color: Colors.white60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Ofertas Vendidas",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(doc['totalCount'].toString()),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                          color: Colors.white60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total Vendido",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(doc['totalSold'].toString()),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              return Center(child: CircularProgressIndicator(),);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // dinero ganado
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  //rating general
                  Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: HexColor("#617999"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: Icon(
                              Icons.analytics_sharp,
                              color: Colors.white70,
                              size: 50,
                              semanticLabel: 'Total Vendido Ofertas',
                            )
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: StreamBuilder(
                              stream: firestoreInstance.collection('empresa').doc(id).collection('reportes').snapshots(),
                              builder: (context, AsyncSnapshot  snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator(),);
                                }
                                var reports = snapshot.data.size.toString();
                                return Text(
                                  reports,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 40
                                  ),
                                );
                              }
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    height: 250,
                    width: 1250,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: HexColor("#FFD687"),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: Icon(
                              Icons.history,
                              color: Colors.white70,
                              size: 50,
                              semanticLabel: 'Total Vendido Ofertas',
                            )
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('empresa')
                              .doc(id)
                              .collection('reportes')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot doc = snapshot.data!.docs[index];
                                    return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          height: 25,
                                          child: Text("Detalle Reporte",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          height: 25,
                                          color: Colors.white60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Fecha",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(doc['date']),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                          color: Colors.white60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Hora",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(doc['time']),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                          color: Colors.white60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Transacciones Analizadas",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(doc['transactions'].toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              return Center(child: CircularProgressIndicator(),);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // clientes suscritos
                ],
              ),
            ),
          ],
        ),
      ),

      drawer: CustomDrawer(),
    );
  }
}

