import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliente/src/registrarForm.dart';
import 'package:cliente/src/services/databaseFirebase.dart';
import 'package:cliente/src/main/mainMenu.dart';

// import 'package:firebase_core/firebase_core.dart';


class LoginForm extends StatefulWidget {
  LoginForm({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm>{
  final AuthServices auth = AuthServices();
  final keyForm = GlobalKey<FormState>();

  String usuario = '';
  String email = '';
  String pass = '';
  String error = '';


  //boton que regresa al menu principal
  Widget regresarBoton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Regresar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  //Segmento: titulo de la pagina
  Widget titulo() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'OFER',
          style: GoogleFonts.oswald(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Color(0xffd1d765),
          ),
          children: [
            TextSpan(
              text: 'PLUS',
              style: TextStyle(color: Color(0xff05668D), fontSize: 50),
            ),
          ]),
    );
  }

  //Segmento: text boxes y su estilo
  Widget emailPassword() {
    final height = MediaQuery.of(context).size.height;
    return Form(
    key: keyForm,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(

              validator: (val) => val!.isEmpty ? 'Poner un correo' : null,
              onChanged: (val) {
                setState(() => email = val);
              },
              obscureText: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xffd9d9d9),
                  filled: true)),
          Text(
            "Contraseña",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(

              validator: (val) => val!.length < 8 ? 'La contraseña tiene que contener 8 o más caracteres' : null,

              onChanged: (val) {
                setState(() => pass = val);
              },
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xffd9d9d9),
                  filled: true)),
        ],
      ),
    ),
    );
  }

  //Segmento: ingreso de datos al form
  // Widget emailPassword() {
  //   return Column(
  //     children: <Widget>[
  //       textBox("Email"),
  //       textBox("Contraseña", isPassword: true),
  //     ],
  //   );
  // }

  //Segmento: boton que hace el login y manda el form a verificar contra la firebase


  Widget LoginVerBoton() {
    return Column(
      children: <Widget>[
        ElevatedButton(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xff6D597A), Color(0xff355070)])),
          child: Column(
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),

       onPressed: () async {
        if(keyForm.currentState!.validate()){
          print('datos validos');

          dynamic resultado = await auth.loginUsuario(usuario, email, pass);
          // FirebaseUser uidAuth = resultado;
          // String uid = uidAuth.uid;
          if(resultado == null){
            setState(() => error = 'No se pudo hacer login con la información suministrada');
          } else{
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainMenu(title: '', /*uid: uid*/)));
          }

          print(usuario);
          print(email);
          print(pass);
          }
        },
      ),
        SizedBox(height: 12),
        Text(error, style: TextStyle(color: Colors.red, fontSize: 14)),
    ]
    );

  }

  //Segmento: division para otros metodos de login
  Widget division() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  //Segmento: boton que permite login de gmail
  // Widget gmailLoginBoton() {
  //   return Container(
  //     height: 50,
  //     margin: EdgeInsets.symmetric(vertical: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xffdfeaf0),
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(5),
  //                   topLeft: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //
  //             //porque chingados no funcionas
  //             child: Image.asset('assets/images/gmail.png'),
  //
  //           ),
  //         ),
  //         Expanded(
  //           flex: 5,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xffdfeaf0),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: Radius.circular(5),
  //                   topRight: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('Login con Gmail',
  //                 style: TextStyle(
  //                     color: Color(0xff454a4d),
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Segmento: crear cuenta
  Widget crearCuenta() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegistrarForm(title: '')));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No tienes una cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Registrar',
              style: TextStyle(
                  color: Color(0xff6D597A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  //Construccion de la clase
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          //
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(5)),
          //     boxShadow: <BoxShadow>[
          //       BoxShadow(
          //           color: Colors.grey.shade200,
          //           offset: Offset(2, 4),
          //           blurRadius: 5,
          //           spreadRadius: 2)
          //     ],
          //     gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [Color(0xff02C39A), Color(0xff05668D)])),

          child: Stack(
            children: <Widget>[
              // Positioned(
              //     top: -height * .15,
              //     right: -MediaQuery.of(context).size.width * .4,
              //     child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      titulo(),
                      SizedBox(height: 50),
                      emailPassword(),
                      SizedBox(height: 20),
                      LoginVerBoton(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Olvidaste tu contraseña ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      division(),
                      // gmailLoginBoton(),
                      SizedBox(height: height * .055),
                      crearCuenta(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: regresarBoton()),
            ],
          ),
        ),
    );
  }

}