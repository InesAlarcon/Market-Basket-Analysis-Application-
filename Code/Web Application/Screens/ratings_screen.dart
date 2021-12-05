import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mbaa/widgets/custom_drawer.dart';
import 'package:mbaa/widgets/maps.dart';
import 'package:url_launcher/url_launcher.dart';

class InputFormatWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isLastInput, mustHaveCaps;
  final Function(String? value)? validator;

  InputFormatWidget(
      {required this.hintText,
        required this.icon,
        required this.controller,
        this.isLastInput = false,
        this.mustHaveCaps = false,
        @required this.validator});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(this.icon),
      title: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: this.hintText,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFdb3232), width: 1.0),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8a0f0f), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (this.validator == null)
            ? (String? value) => null
            : (String? value) => this.validator!(value),
        controller: this.controller,
        textCapitalization:
        (mustHaveCaps) ? TextCapitalization.words : TextCapitalization.none,
        textInputAction:
        (this.isLastInput) ? TextInputAction.done : TextInputAction.next,
      ),
    );
  }
}

// Form Enterprise - Enterprise App
class RatingForm extends StatefulWidget {
  RatingFormState createState() => RatingFormState();
}

class RatingFormState extends State<RatingForm>
    with SingleTickerProviderStateMixin {
  _dismissDialog() {
    Navigator.pop(context);
  }

  Future<void>? _launched;

  late TextEditingController name,
      businesstype,
      nit,
      sucursalname,
      address1,
      address2,
      zone,
      municipio,
      departamento,
      telefono,
      correo,
      horario,
      etiquetas,
      facebook,
      twitter,
      instagram,
      googlemb,
      webpage,
      latitud,
      longitud,
      urlImage,
      dias;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();
  GlobalKey<FormState> _aaaKey = GlobalKey<FormState>();
  GlobalKey<FormState> _bbbKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  EnterpriseFormState() {
    this.name = new TextEditingController();
    this.nit = new TextEditingController();
    this.businesstype = new TextEditingController();
    this.sucursalname = new TextEditingController();
    this.address1 = new TextEditingController();
    this.address2 = new TextEditingController();
    this.zone = new TextEditingController();
    this.municipio = new TextEditingController();
    this.departamento = new TextEditingController();
    this.telefono = new TextEditingController();
    this.correo = new TextEditingController();
    this.horario = new TextEditingController();
    this.dias = new TextEditingController();
    this.etiquetas = new TextEditingController();
    this.facebook = new TextEditingController();
    this.twitter = new TextEditingController();
    this.instagram = new TextEditingController();
    this.googlemb = new TextEditingController();
    this.webpage = new TextEditingController();
    this.latitud = new TextEditingController();
    this.longitud = new TextEditingController();
    this.urlImage = new TextEditingController();
  }

  final firestoreInstance = FirebaseFirestore.instance;
  String doc_id = '0';
  String id = FirebaseAuth.instance.currentUser!.uid;

  String logo = '1';
  String departamentos = '1';
  List<String> listOfValue = ['1', '2', '3', '4', '5'];
  num lati = 0;
  num longi = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
            height: 1000,
            width: 2100,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
                color: HexColor("#DADEE9"),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                    height: 700,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('empresa')
                          .doc(id)
                          .collection('historial')
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
                                      child: Text(doc['fecha'],
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
                                          Text("Word Cloud",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          ElevatedButton(
                                            onPressed: () => setState(() {
                                              _launched = _launchInWebViewOrVC(
                                                  doc['wordcloud'], context);
                                            }),
                                            child: const Icon(Icons.cloud_download),
                                          ),
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
                                          Text("Frequency of Sold Items",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          ElevatedButton(
                                            onPressed: () => setState(() {
                                              _launched = _launchInWebViewOrVC(
                                                  doc['frequency'], context);
                                            }),
                                            child: const Icon(Icons.cloud_download),
                                          ),
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
                                          Text("Tree Map of Popular Items",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          ElevatedButton(
                                            onPressed: () => setState(() {
                                              _launched = _launchInWebViewOrVC(
                                                  doc['map tree'], context);
                                            }),
                                            child: const Icon(Icons.cloud_download),
                                          ),
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
                                          Text("Frequent Itemsets",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          ElevatedButton(
                                            onPressed: () => setState(() {
                                              _launched = _launchInWebViewOrVC(
                                                  doc['frequent itemsets'], context);
                                            }),
                                            child: const Icon(Icons.cloud_download),
                                          ),
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
                                          Text("Time Analysis Table",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          ElevatedButton(
                                            onPressed: () => setState(() {
                                              _launched = _launchInWebViewOrVC(
                                                  doc['time table analysis'], context);
                                            }),
                                            child: const Icon(Icons.cloud_download),
                                          ),
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
                    )
                )
              ],
            )
        ),
      drawer: CustomDrawer(),
    );
  }
}

Future<void> _launchInWebViewOrVC(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    _showDialog1(context);
  }
}

Future<void> _showDialog1(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Ha ocurrido un error con tu URL, por favor revisa que sea el correcto'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  _dismissDialog(context);
                },
                child: Text('Close')),
          ],
        );
      });
}

Future<void> _dismissDialog(BuildContext context) async {
  Navigator.pop(context);
}


