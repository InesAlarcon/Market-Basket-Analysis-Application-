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
class EnterpriseForm extends StatefulWidget {
  EnterpriseFormState createState() => EnterpriseFormState();
}

class EnterpriseFormState extends State<EnterpriseForm>
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
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
                height: 50,
                width: 500,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    SizedBox( width: 200,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.home_work),
                      label: Text("Editar Información General"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Editar Información General'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Form(
                                    key: this._formKey,
                                    child: ListView(
                                      padding: EdgeInsets.all(12.0),
                                      children: [
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Nombre de la empresa",
                                            icon: Icons.person,
                                            controller: this.name,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "NIT",
                                            icon: Icons.money,
                                            controller: this.nit,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Gremio al que se dedica la empresa",
                                            icon: Icons.add_business_rounded,
                                            controller: this.businesstype,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else if (value.trim().isEmpty) {
                                                return 'Por favor, llene el campo';
                                              } else {
                                                return null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "URL Imagen Logo",
                                            icon: Icons.image,
                                            controller: this.urlImage,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.image_search),
                                          label: Text("Confirmar Imagen"),
                                          onPressed: () {
                                            if (urlImage.text.isNotEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Imagen'),
                                                      content: Image.network(urlImage.text),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                            }
                                            else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Error'),
                                                      content:
                                                      Text('Por favor llene el campo de URL Imagen'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                            };

                                          },
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.check_circle),
                                          label: Text("Registrar"),
                                          onPressed: () {
                                            if (this._formKey.currentState!.validate()) {
                                              FirebaseAuth.instance
                                                  .authStateChanges()
                                                  .listen((User? user) async {
                                                if (user == null) {
                                                  print('User is currently signed out!');
                                                } else {
//print(user.uid);
                                                  var id = user.uid;
                                                  print(id);

                                                  final snapShot = await firestoreInstance
                                                      .collection('empresa')
                                                      .doc(id)
                                                      .get();

                                                  if (snapShot.exists) {
                                                    firestoreInstance
                                                        .collection('empresa')
                                                        .doc(id)
                                                        .update({
                                                      "nombre": name.text,
                                                      "nit": nit.text,
                                                      "type": businesstype.text,
                                                      "urlImage": urlImage.text,
                                                      "searchKey":
                                                      name.text.substring(0, 1).toUpperCase(),
                                                    });
                                                  } else {
                                                    firestoreInstance.collection('empresa').doc(id).set({
                                                      "nombre": name.text,
                                                      "nit": nit.text,
                                                      "type": businesstype.text,
                                                      "searchKey":
                                                      name.text.substring(0, 1).toUpperCase(),
                                                      "urlImage": urlImage.text,
                                                      "defaultRating": 0,
                                                      "companyTitle": false,
                                                      "voteCount": 0,
                                                      "subCount": 0,
                                                    });
                                                  }
                                                }
                                              }
                                              );
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Aviso'),
                                                      content: Text('Tus datos han sido registrados'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _dismissDialog();
                                                              _formKey.currentState?.reset();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
// All inputs are correct, do something
                                            } else {
// Do something else
                                            };
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _dismissDialog();
                                        _formKey.currentState?.reset();
                                      },
                                      child: Text('Close')),
                                ],
                              );
                            });

                      },
                    ),
                    SizedBox( width: 8,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.location_pin),
                      label: Text("Agregar Sucursales"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Agregar Sucursales'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Form(
                                    key: this._abcKey,
                                    child: ListView(
                                      padding: EdgeInsets.all(12.0),
                                      children: [
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Nombre de la sucursal",
                                            icon: Icons.business,
                                            controller: this.sucursalname,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Telefono",
                                            icon: Icons.phone,
                                            controller: this.telefono,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Correo",
                                            icon: Icons.email,
                                            controller: this.correo,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Horarios",
                                            icon: Icons.schedule,
                                            controller: this.horario,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Latitud",
                                            icon: Icons.location_pin,
                                            controller: this.latitud,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Longitud",
                                            icon: Icons.my_location,
                                            controller: this.longitud,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.map),
                                          label: Text("Confirmar Ubicación"),
                                          onPressed: () {
                                            if (latitud.text.isNotEmpty & longitud.text.isNotEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Ubicación'),
                                                      content: getMap(lat: num.parse(latitud.text), lng: num.parse(longitud.text)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Ubicación'),
                                                      content: Text(
                                                          'Por favor llene los campos de latitud y longitud'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.check_circle),
                                          label: Text("Registrar"),
                                          onPressed: () {
                                            if (this._abcKey.currentState!.validate()) {
                                              FirebaseAuth.instance
                                                  .authStateChanges()
                                                  .listen((User? user) async {
                                                if (user == null) {
                                                  print('User is currently signed out!');
                                                } else {
                                                  //print(user.uid);
                                                  var id = user.uid;
                                                  print(id);

                                                  firestoreInstance
                                                      .collection('empresa')
                                                      .doc(id)
                                                      .collection('sucursales')
                                                      .doc()
                                                      .set({
                                                    "nombre": sucursalname.text,
                                                    "latitud": num.parse(latitud.text),
                                                    "longitud": num.parse(longitud.text),
                                                    "telefono": telefono.text,
                                                    "correo": correo.text,
                                                    "horario": horario.text,
                                                    "dias": dias.text,
                                                  });
                                                }
                                              });

                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Aviso'),
                                                      content: Text('Tus datos han sido actualizados'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _abcKey.currentState?.reset();
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                              // All inputs are correct, do something
                                            } else {
                                              // Do something else
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _dismissDialog();
                                        _abcKey.currentState?.reset();
                                      },
                                      child: Text('Close')),
                                ],
                              );
                            });

                      },
                    ),
                    SizedBox( width: 8,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.location_pin),
                      label: Text("Eliminar Sucursales"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Eliminar Sucursales'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Form(
                                    key: this._abcKey,
                                    child: ListView(
                                      padding: EdgeInsets.all(12.0),
                                      children: [
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Nombre de la sucursal",
                                            icon: Icons.business,
                                            controller: this.sucursalname,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.check_circle),
                                          label: Text("Eliminar"),
                                          onPressed: () {
                                            if (this._abcKey.currentState!.validate()) {
                                              FirebaseAuth.instance
                                                  .authStateChanges()
                                                  .listen((User? user) async {
                                                if (user == null) {
                                                  print('User is currently signed out!');
                                                } else {
                                                  //print(user.uid);
                                                  var id = user.uid;
                                                  print(id);

                                                  var collection = FirebaseFirestore.instance.collection('empresa')
                                                      .doc(id)
                                                      .collection('sucursales');
                                                  var snapshot = await collection.where('nombre', isEqualTo: sucursalname.text).get();
                                                  if(snapshot.docs.isNotEmpty){
                                                    for (var doc in snapshot.docs) {
                                                      if(doc.exists){
                                                        await doc.reference.delete();
                                                      }
                                                    }
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: Text('Tus datos han sido actualizados'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed: () {
                                                                    _abcKey.currentState?.reset();
                                                                    _dismissDialog();
                                                                  },
                                                                  child: Text('Close')),
                                                            ],
                                                          );
                                                        });
                                                  } else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: Text('No hemos encontrado este registro, verifica tus datos'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed: () {
                                                                    _abcKey.currentState?.reset();
                                                                    _dismissDialog();
                                                                  },
                                                                  child: Text('Close')),
                                                            ],
                                                          );
                                                        });

                                                  }
                                                }
                                              });
                                              // All inputs are correct, do something
                                            } else {
                                              // Do something else
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _dismissDialog();
                                        _abcKey.currentState?.reset();
                                      },
                                      child: Text('Close')),
                                ],
                              );
                            });

                      },
                    ),
                    SizedBox( width: 8,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.tag),
                      label: Text("Agregar Etiquetas"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Agregar Etiquetas'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Form(
                                    key: this._aaaKey,
                                    child: ListView(
                                      padding: EdgeInsets.all(12.0),
                                      children: [
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Etiquetas",
                                            icon: Icons.tag_sharp,
                                            controller: this.etiquetas,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.check_circle),
                                          label: Text("Registrar"),
                                          onPressed: () {
                                            if (this._aaaKey.currentState!.validate()) {
                                              FirebaseAuth.instance
                                                  .authStateChanges()
                                                  .listen((User? user) async {
                                                if (user == null) {
                                                  print('User is currently signed out!');
                                                } else {
                                                  //print(user.uid);
                                                  var id = user.uid;
                                                  print(id);

                                                  firestoreInstance
                                                      .collection('empresa')
                                                      .doc(id)
                                                      .collection('etiquetas')
                                                      .doc()
                                                      .set({
                                                    "etiquetas": etiquetas.text,
                                                  });
                                                }
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Aviso'),
                                                      content: Text('Tus datos han sido registrados'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _aaaKey.currentState?.reset();
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                              // All inputs are correct, do something
                                            } else {
                                              // Do something else
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _dismissDialog();
                                        _aaaKey.currentState?.reset();
                                      },
                                      child: Text('Close')),
                                ],
                              );
                            });

                      },
                    ),
                    SizedBox( width: 8,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.tag),
                      label: Text("Eliminar Etiquetas"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Eliminar Etiquetas'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Form(
                                    key: this._aaaKey,
                                    child: ListView(
                                      padding: EdgeInsets.all(12.0),
                                      children: [
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Etiquetas",
                                            icon: Icons.tag_sharp,
                                            controller: this.etiquetas,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return (value.trim().isEmpty)
                                                    ? 'Por favor, llene el campo'
                                                    : null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.check_circle),
                                          label: Text("Eliminar"),
                                          onPressed: () {
                                            if (this._aaaKey.currentState!.validate()) {
                                              FirebaseAuth.instance
                                                  .authStateChanges()
                                                  .listen((User? user) async {
                                                if (user == null) {
                                                  print('User is currently signed out!');
                                                } else {
                                                  //print(user.uid);
                                                  var id = user.uid;
                                                  print(id);

                                                  var collection = FirebaseFirestore.instance.collection('empresa')
                                                      .doc(id)
                                                      .collection('etiquetas');
                                                  var snapshot = await collection.where('etiquetas', isEqualTo: etiquetas.text).get();
                                                  if(snapshot.docs.isNotEmpty){
                                                    for (var doc in snapshot.docs) {
                                                      if(doc.exists){
                                                        await doc.reference.delete();
                                                      }
                                                    }
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: Text('Tus datos han sido actualizados'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed: () {
                                                                    _aaaKey.currentState?.reset();
                                                                    _dismissDialog();
                                                                  },
                                                                  child: Text('Close')),
                                                            ],
                                                          );
                                                        });
                                                  } else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: Text('No hemos encontrado este registro, verifica tus datos'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed: () {
                                                                    _aaaKey.currentState?.reset();
                                                                    _dismissDialog();
                                                                  },
                                                                  child: Text('Close')),
                                                            ],
                                                          );
                                                        });

                                                  }

                                                }
                                              });

                                              // All inputs are correct, do something
                                            } else {
                                              // Do something else
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _dismissDialog();
                                        _aaaKey.currentState?.reset();
                                      },
                                      child: Text('Close')),
                                ],
                              );
                            });

                      },
                    ),
                    SizedBox( width: 8,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.facebook),
                      label: Text("Editar Redes Sociales"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Editar Redes Sociales'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Form(
                                    key: this._bbbKey,
                                    child: ListView(
                                      padding: EdgeInsets.all(12.0),
                                      children: [
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Facebook",
                                            icon: Icons.facebook,
                                            controller: this.facebook,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Instagram",
                                            icon: Icons.camera_alt,
                                            controller: this.instagram,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Twitter",
                                            icon: Icons.speaker_notes,
                                            controller: this.twitter,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Google My Business",
                                            icon: Icons.location_on,
                                            controller: this.googlemb,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Card(
                                          child: InputFormatWidget(
                                            hintText: "Pagina Web",
                                            icon: Icons.web,
                                            controller: this.webpage,
                                            validator: (String? value) {
                                              if (value == null) {
                                                return null;
                                              } else {
                                                return null;
                                              }
                                            },
                                            mustHaveCaps: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.check_circle),
                                          label: Text("Registrar"),
                                          onPressed: () {
                                            if (this._bbbKey.currentState!.validate()) {
                                              FirebaseAuth.instance
                                                  .authStateChanges()
                                                  .listen((User? user) async {
                                                if (user == null) {
                                                  print('User is currently signed out!');
                                                } else {
                                                  //print(user.uid);
                                                  var id = user.uid;
                                                  print(id);

                                                  final snapShot = await firestoreInstance
                                                      .collection('empresa')
                                                      .doc(id)
                                                      .get();

                                                  if (snapShot.exists) {
                                                    if (facebook.text.isNotEmpty) {
                                                      firestoreInstance
                                                          .collection('empresa')
                                                          .doc(id)
                                                          .update({
                                                        "facebook": facebook.text,
                                                      });
                                                    }
                                                    if (instagram.text.isNotEmpty) {
                                                      firestoreInstance
                                                          .collection('empresa')
                                                          .doc(id)
                                                          .update({
                                                        "instagram": instagram.text,
                                                      });
                                                    }
                                                    if (twitter.text.isNotEmpty) {
                                                      firestoreInstance
                                                          .collection('empresa')
                                                          .doc(id)
                                                          .update({
                                                        "twitter": twitter.text,
                                                      });
                                                    }
                                                    if (googlemb.text.isNotEmpty) {
                                                      firestoreInstance
                                                          .collection('empresa')
                                                          .doc(id)
                                                          .update({
                                                        "googlemb": googlemb.text,
                                                      });
                                                    }
                                                    if (webpage.text.isNotEmpty) {
                                                      firestoreInstance
                                                          .collection('empresa')
                                                          .doc(id)
                                                          .update({
                                                        "web_page": webpage.text,
                                                      });
                                                    }
                                                  } else {
                                                    firestoreInstance
                                                        .collection('empresa')
                                                        .doc(id)
                                                        .update({
                                                      "facebook": facebook.text,
                                                      "instagram": instagram.text,
                                                      "twitter": twitter.text,
                                                      "googlemb": googlemb.text,
                                                      "web_page": webpage.text,
                                                    });
                                                  }
                                                }
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Aviso'),
                                                      content: Text('Tus datos han sido registrados'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _bbbKey.currentState?.reset();
                                                              _dismissDialog();
                                                            },
                                                            child: Text('Close')),
                                                      ],
                                                    );
                                                  });
                                              // All inputs are correct, do something
                                            } else {
                                              // Do something else
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _dismissDialog();
                                        _bbbKey.currentState?.reset();
                                      },
                                      child: Text('Close')),
                                ],
                              );
                            });

                      },
                    ),
                    SizedBox( width: 8,),


                  ],
                )
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
                height: 700,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestoreInstance.collection('empresa').doc(id).snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Aún no existen datos registrados");
                    }

                    if (snapshot.connectionState == ConnectionState.active) {
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return Container(
                        width: double.maxFinite,
                        child: ListView(
                          padding: const EdgeInsets.all(8),
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.blue[300],
                              child: Center(
                                  child: Text("Datos Generales",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                      ))),
                            ),
                            Container(
                              height: 100,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Logo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Image.network("${data['urlImage']}"),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Nombre",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${data['nombre']}", textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("NIT",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${data['nit']}", textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Gremio",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${data['type']}", textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.blue[300],
                              child: Center(
                                  child: Text("Redes Sociales",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                      ))),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Página Web Oficial",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  ElevatedButton(
                                    onPressed: () => setState(() {
                                      _launched = _launchInWebViewOrVC(
                                          "${data['web_page']}", context);
                                    }),
                                    child: const Text('Abrir'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Facebook",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),

                                  ElevatedButton(
                                    onPressed: () => setState(() {
                                      _launched = _launchInWebViewOrVC(
                                          "${data['facebook']}", context);
                                    }),
                                    child: const Text('Abrir'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Instagram",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),

                                  ElevatedButton(
                                    onPressed: () => setState(() {
                                      _launched = _launchInWebViewOrVC(
                                          "${data['instagram']}", context);
                                    }),
                                    child: const Text('Abrir'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Twitter",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),

                                  ElevatedButton(
                                    onPressed: () => setState(() {
                                      _launched = _launchInWebViewOrVC(
                                          "${data['twitter']}", context);
                                    }),
                                    child: const Text('Abrir'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Google My Business",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold)),

                                  ElevatedButton(
                                    onPressed: () => setState(() {
                                      _launched = _launchInWebViewOrVC(
                                          "${data['googlemb']}", context);
                                    }),
                                    child: const Text('Abrir'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              color: Colors.blue[300],
                              child: Center(
                                  child: Text("Sucursales",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                      ))),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('empresa')
                                  .doc(id)
                                  .collection('sucursales')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot doc = snapshot.data!.docs[index];
                                        return ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Container(
                                              height: 50,
                                              color: Colors.lightBlueAccent,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Nombre",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, color: Colors.white)),
                                                  Text(doc['nombre']),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: Colors.white60,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Telefono",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold)),
                                                  Text(doc['telefono']),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: Colors.white60,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Correo",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold)),
                                                  Text(doc['correo']),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: Colors.white60,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Horarios",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold)),
                                                  Text(doc['horario']),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                              icon: Icon(Icons.map),
                                              label: Text("Confirmar Ubicación"),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Ubicación'),
                                                        content: getMap(lat: doc['latitud'],lng: doc['longitud']),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () {
                                                                _dismissDialog();
                                                              },
                                                              child: Text('Close')),
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  return Text("No data");
                                }
                              },
                            ),
                            Container(
                              height: 50,
                              color: Colors.blue[300],
                              child: Center(
                                  child: Text("Etiquetas",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                      ))),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('empresa')
                                  .doc(id)
                                  .collection('etiquetas')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot doc = snapshot.data!.docs[index];
                                        return ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Container(
                                              height: 50,
                                              color: Colors.white60,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Etiqueta",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold)),
                                                  Text(doc['etiquetas']),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  return Text("No data");
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Text("loading");
                  },
                )
            ),

          ],
        ),
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


