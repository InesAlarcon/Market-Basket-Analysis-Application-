import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

// Form User - Client App
class UserForm extends StatefulWidget {
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {

  _dismissDialog() {
    Navigator.pop(context);
  }

  late TextEditingController name, email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserFormState() {
    this.name = new TextEditingController();
    this.email = new TextEditingController();
    this.password = new TextEditingController();
  }

  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


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
      body: Form(
        key: this._formKey,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            Card(
              child: InputFormatWidget(
                hintText: "Nombre",
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
                hintText: "Correo",
                icon: Icons.email,
                controller: this.email,
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
                hintText: "Contraseña",
                icon: Icons.password,
                controller: this.password,
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
              label: Text("Actualizar"),
              onPressed: () async {
              if (this._formKey.currentState!.validate()) {

                FirebaseAuth.instance
                    .authStateChanges()
                    .listen((User? user) {
                  if (user == null) {
                    print('User is currently signed out!');
                  } else {
                    print('User is signed in!');
                  }
                });

                FirebaseAuth.instance
                    .idTokenChanges()
                    .listen((User? user) {
                  if (user == null) {
                    print('User is currently signed out!');
                  } else {
                    print('User is signed in!');
                  }
                });

                FirebaseAuth.instance
                    .userChanges()
                    .listen((User? user) {
                  if (user == null) {
                    print('User is currently signed out!');
                  } else {
                    print('User is signed in!');
                  }
                });

                await FirebaseAuth.instance.setPersistence(Persistence.NONE);

                FirebaseAuth.instance.currentUser!.updateDisplayName(name.text);
                FirebaseAuth.instance.currentUser!.updateEmail(email.text);
                FirebaseAuth.instance.currentUser!.updatePassword(password.text);

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Aviso'),
                        content: Text('Tus datos han sido actualizados'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                _formKey.currentState?.reset();
                                _dismissDialog();
                              },
                              child: Text('Close')),
                        ],
                      );
                    });

              } else {
              // Do something else
              }
              },
            ),
          ],
        ),
      ),
    );
  }
}




