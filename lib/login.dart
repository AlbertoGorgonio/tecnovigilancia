import 'package:flutter/material.dart';
import 'package:tecnovigilancia/onepage.dart'; // Asegúrate de importar correctamente onepage.dart

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto "Sign In" a la izquierda
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center, // Centra la imagen
                child: SizedBox(
                  width: 200, // Ancho deseado de la imagen
                  height: 200, // Altura deseada de la imagen
                  child: Image.asset('assets/images/sign.gif'), // Corregir la ruta del archivo GIF
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y los campos de texto
              Padding(
                padding: const EdgeInsets.only(left: 20), // Añade padding para alinear el texto "Sign In"
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacio entre el texto "Sign In" y los campos de texto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildTextFieldWithIcon(
                      hintText: 'Email',
                      icon: Icons.email, // Añade un icono de email al campo de texto
                    ),
                    const SizedBox(height: 10), // Espacio entre el campo de texto de Email y el de contraseña
                    _buildTextFieldWithIcon(
                      hintText: 'Password',
                      icon: Icons.lock, // Añade un icono de candado al campo de texto de la contraseña
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Espacio entre los campos de texto y el botón de Login
              Container(
                alignment: Alignment.center, // Centra el botón
                child: ElevatedButton(
                  onPressed: () {
                    // Acción cuando se presiona el botón de Login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OnePage()), // Redirige a onepage.dart
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Texto blanco
                  ),
                  child: Text('Login'),
                ),
              ),
              const SizedBox(height: 10), // Espacio entre el botón de Login y el texto de "Forgot Password? y Privacy"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Acción cuando se presiona el texto "Forgot Password?"
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    ' | ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Acción cuando se presiona el texto "Privacy"
                    },
                    child: Text(
                      'Privacy',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
