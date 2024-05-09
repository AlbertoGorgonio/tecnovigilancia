import 'package:flutter/material.dart';

import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tecnovigilancia',
      theme: ThemeData(
        primaryColor: Colors.blue,
        // Otros ajustes de tema aquí si los necesitas
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false, // Oculta la barra de debug
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TECNOVIGILANCIA',
              style: TextStyle(
                color: Colors.black, // Color negro
                fontWeight: FontWeight.bold, // Negritas
                fontFamily: 'Roboto', // Fuente Roboto
                fontSize: 24, // Ajusta el tamaño del texto
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/inicio.gif',
              width: 250, // Ajusta el ancho de la imagen
              height: 250, // Ajusta la altura de la imagen
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Ajuste de padding
              ),
              child: Text(
                'Comenzar',
                style: TextStyle(
                  color: Colors.white, // Color del texto blanco
                  fontWeight: FontWeight.bold, // Negritas
                  fontSize: 16, // Tamaño de fuente ligeramente más grande
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
