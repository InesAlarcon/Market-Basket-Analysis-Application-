import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbaa/screens/home_screen.dart';
import 'package:mbaa/screens/login_screen.dart';
import 'package:mbaa/screens/enterprise_screen.dart';
import 'package:mbaa/screens/profile_screen.dart';
import 'package:mbaa/screens/artandcat_screen.dart';
import 'package:mbaa/screens/ratings_screen.dart';
import 'package:mbaa/screens/reporting_screen.dart';


class CustomDrawer extends StatelessWidget {

  _buildDrawerOption(Icon icon, String title, Function onTap){
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      onTap: (){
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image(
                height: 200.0,
                width: double.infinity,
                image: AssetImage(
                    'assets/images/login_background1.jpg'
                ),
                fit: BoxFit.contain,
              )
            ],
          ),
          _buildDrawerOption(
            Icon(Icons.dashboard),
            'Inicio',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            ),
          ),
          _buildDrawerOption(
            Icon(Icons.business),
            'Empresa',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => EnterpriseForm(),
              ),
            ),
          ),
          _buildDrawerOption(
            Icon(Icons.shopping_cart),
            'Ofertas',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ArticlesForm(),
              ),
            ),
          ),

          _buildDrawerOption(
            Icon(Icons.analytics_sharp),
            'Reporteria',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ReportingScreen(),
              ),
            ),
          ),
          _buildDrawerOption(
            Icon(Icons.analytics_sharp),
            'Historial Reportes',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RatingForm(),
              ),
            ),
          ),
          _buildDrawerOption(
            Icon(Icons.verified_user),
            'Perfil',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => UserForm(),
              ),
            ),
          ),
          _buildDrawerOption(
            Icon(Icons.account_box),
            'Cerrar Sesión',
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
