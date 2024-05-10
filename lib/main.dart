import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyB1b7liEFFVlmM7i5AbhnslRQBbMl6vJQ8',
      authDomain: 'appbiomedica.web.app',
      projectId: 'appbiomedica-811aa',
      appId: '1:144810312542:android:b39f7e411cea83ec8805cf',
      messagingSenderId: '144810312542',
  ),
  );
  runApp(MyApp());
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'TECNOVIGILANCIA',
                style: TextStyle(
                  color: Colors.black, // Color negro
                  fontWeight: FontWeight.bold, // Negritas
                  fontFamily: 'Roboto', // Fuente Roboto
                  fontSize: 24, // Ajusta el tamaño del texto
                ),
              ),
            ),
            Image.asset(
              'assets/images/inicio.gif',
              width: 250, // Ajusta el ancho de la imagen
              height: 250, // Ajusta la altura de la imagen
            ),
            const SizedBox(height: 60), // Aumenta el espacio entre la imagen y el botón
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15), // Ajuste de padding
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
