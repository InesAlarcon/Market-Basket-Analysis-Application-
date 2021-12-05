

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mbaa/image_selection/user_image.dart';

import 'package:mbaa/widgets/custom_drawer.dart';



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

// Form Articles - Enterprise App
class ArticlesForm extends StatefulWidget {
  ArticlesFormState createState() => ArticlesFormState();
}

class ArticlesFormState extends State<ArticlesForm> {

  _dismissDialog() {
    Navigator.pop(context);
  }

  late TextEditingController name, cost, categorias, urlImage, labels, total_ofertas, oferta_usuario;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();
  ArticlesFormState() {
    this.name = new TextEditingController();
    this.categorias = new TextEditingController();
    this.cost = new TextEditingController();
    this.urlImage = new TextEditingController();
    this.labels = new TextEditingController();
    this.total_ofertas = new TextEditingController();
    this.oferta_usuario = new TextEditingController();
  }

  final firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String imageUrl = '1';
  String id = FirebaseAuth.instance.currentUser!.uid;




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
      drawer: CustomDrawer(),
      body: Container(
        height: 1000,
        width: 2100,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 25,
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete_forever_rounded),
                label: Text("Desactivar Ofertas"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Desactivar Ofertas'),
                          content: Container(
                            width: double.maxFinite,
                            child: Form(
                              key: this._abcKey,
                              child: ListView(
                                padding: EdgeInsets.all(12.0),
                                children: [
                                  Card(
                                    child: InputFormatWidget(
                                      hintText: "Nombre de la oferta",
                                      icon: Icons.business,
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
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.check_circle),
                                    label: Text("Desactivar"),
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

                                            var collection = FirebaseFirestore.instance.collection('ofertas')
                                                .doc(id)
                                                .collection('ofertas');
                                            var snapshot = await collection.where('nombre', isEqualTo: name.text).get();
                                            if(snapshot.docs.isNotEmpty){
                                              for (var doc in snapshot.docs) {
                                                if(doc.exists){
                                                  await doc.reference.update({ "estado": "inactivo" });
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
            ),
            SizedBox(
              height: 700,
              child: Form(
                key: this._formKey,
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12.0),
                  children: [
                    Card(
                      child: InputFormatWidget(
                        hintText: "Nombre",
                        icon: Icons.point_of_sale,
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
                        hintText: "Categorias",
                        icon: Icons.merge_type,
                        controller: this.categorias,
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
                        hintText: "Valor",
                        icon: Icons.money,
                        controller: this.cost,
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
                        hintText: "URL Imagen",
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
                        if(urlImage.text.isNotEmpty){
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
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Por favor llene el campo de URL Imagen'),
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


                    Card(
                      child: InputFormatWidget(
                        hintText: "Etiquetas de búsqueda",
                        icon: Icons.tag,
                        controller: this.labels,
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

                    //UserImage(
                    //  onFileChanged: (imageUrl) {
                    //   setState(() {
                    //      this.imageUrl = imageUrl;
                    //    });
                    //  },
                    //),

                    //    ElevatedButton.icon(
                    //      icon: Icon(Icons.image),
                    //      label: Text("Cargar una imagen"),
                    //      onPressed: () {

                    //        //uploadImage();
                    //      }

                    //    ),

                    SizedBox(
                      height: 12.0,
                    ),

                    Card(
                      child: InputFormatWidget(
                        hintText: "Cantidad total de ofertas a vender",
                        icon: Icons.tag,
                        controller: this.total_ofertas,
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
                        hintText: "Cantidad de ofertas que cada usuario puede comprar",
                        icon: Icons.tag,
                        controller: this.oferta_usuario,
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


                              firestoreInstance.collection('ofertas').doc(id).set(new HashMap<String, Object>());
                              firestoreInstance.collection('ofertas').doc(id).collection('ofertas').doc().set(
                                  {
                                    "nombre" : name.text,
                                    "categorias" : categorias.text,
                                    "valor" : double.parse(cost.text),
                                    "urlImage" : urlImage.text,
                                    "etiquetas" : labels.text,
                                    "defaultRating": 0,
                                    "votos": 0,
                                    "totalSold": 0,
                                    "totalCount": 0,
                                    "estado": "activo",
                                    "limiteOferta": double.parse(total_ofertas.text),
                                    "limiteUsuario": double.parse(oferta_usuario.text),
                                    "idEmpresa": id.toString(),
                                  });

                              _formKey.currentState?.reset();


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
                    SizedBox(
                      height: 75.0,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.sell),
                      label: Text("Ofertas Registradas"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Ofertas Registradas'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    decoration: BoxDecoration(
                                        color: HexColor("#DADEE9"),
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
                                        SizedBox(
                                          height: 25,
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
                                                          height: 150,
                                                          child: Image.network(doc['urlImage']),
                                                        ),
                                                        Container(
                                                          height: 25,
                                                          color: Colors.white60,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Nombre",
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
                                                              Text("Valor",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold)),
                                                              Text(doc['valor'].toString()),
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
                                                              Text("Categorias",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold)),
                                                              Text(doc['categorias'].toString()),
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
                                                              Text("Etiquetas de Búsqueda",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold)),
                                                              Text(doc['etiquetas'].toString()),
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
                                                              Text("Total Vendido Oferta",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold)),
                                                              Text(doc['totalSold'].toString()),
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
                                                              Text("Rating Oferta",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold)),
                                                              Text(doc['defaultRating'].toString()),
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
                                                              Text("Estado",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold)),
                                                              Text(doc['estado']),
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

                  ],
                ),





              ),
            ),
          ],
        ),
      )
    );
  }
}




