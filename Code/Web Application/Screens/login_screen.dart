import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mbaa/widgets/curve_clipper.dart';
import 'home_screen.dart';
import 'package:flutter/src/widgets/form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isCreateAccountClicked = false;
  bool isForgotPasswordClicked = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;


  _dismissDialog() {
    Navigator.pop(context);
  }

  var id;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget> [
              ClipPath(
                clipper: CurveClipper(),
                child: Image(
                  height: MediaQuery.of(context).size.height / 2.5 ,
                  width: double.infinity,
                  image: AssetImage('assets/images/blue.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                'MARKET BASKET ANALYSIS',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),

              SizedBox(height: 10.0),
              Column(
                children: [
                  SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: isCreateAccountClicked != true ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Ingresa un correo electrónico";
                                }
                                return null;
                              },

                              controller: _email,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Correo Electrónico',
                                prefixIcon: Icon(
                                  Icons.account_box,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Ingresa una contraseña";
                                }
                                return null;
                              },
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Contraseña',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          GestureDetector(
                            onTap: () {
                              if(_formKey.currentState!.validate()){
                                FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: _email.text,
                                    password: _password.text
                                ).then(
                                      (value) {
                                        return Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => HomeScreen(),
                                            ),
                                        );
                                      },
                                  ).catchError( 
                                        (error) {
                                          print(error);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text('Correo y/o contraseña inválidas, intenta de nuevo'),
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
                                    );
                                FirebaseAuth.instance
                                    .authStateChanges()
                                    .listen((User? user) {
                                  if (user == null) {
                                    print('User is currently signed out!');
                                  } else {
                                    //print(user.uid);
                                    id = user.uid;
                                    print(id);
                                    firestoreInstance.collection('usuarios').doc(id).set(
                                        {
                                          "email" : _email.text,
                                          "uid" : id,
                                        });
                                  }
                                });



                                
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 60.0),
                              alignment: Alignment.center,
                              height: 45.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Ingresar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    )
                        : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //Text('Por favor ingresa una correo electónico válido y una contraseña con mínimo 8 caracteres'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Ingresa un correo electrónico";
                                }
                                return null;
                              },

                              controller: _email,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Correo Electrónico',
                                prefixIcon: Icon(
                                  Icons.account_box,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Ingresa una contraseña";
                                }
                                return null;
                              },
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Contraseña',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          GestureDetector(
                            onTap: () {
                              if(_formKey.currentState!.validate()){
                                FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: _email.text,
                                    password: _password.text
                                ).then(
                                      (value) {
                                    return Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                    );
                                  },
                                ).catchError(
                                        (error) {
                                          print(error);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Error'),
                                              content: Text('Correo y/o contraseña inválidas, intenta de nuevo'),
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
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 60.0),
                              alignment: Alignment.center,
                              height: 45.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Crear Cuenta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(!isCreateAccountClicked){
                          isCreateAccountClicked = true;
                        }
                        else
                          isCreateAccountClicked = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Theme.of(context).primaryColor,
                      height: 80.0,
                      child: Text(
                        isCreateAccountClicked ? 'Ya Tengo una Cuenta' : 'No Tengo una Cuenta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ), //notengo cuenta
            ],
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
