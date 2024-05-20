import 'dart:async';

import 'package:flutter/material.dart';

import 'main.dart'; // Importa el archivo main.dart

class FivePage extends StatefulWidget {
  @override
  _FivePageState createState() => _FivePageState();
}

class _FivePageState extends State<FivePage> {
  bool _isAligned = false;

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue.withOpacity(0.8), // Color de fondo con opacidad
        elevation: 6, // Añade sombra al SnackBar
        content: Text(
          'Reporte enviado con éxito',
          style: TextStyle(color: Colors.white), // Color del texto
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _startAnimation() {
    setState(() {
      _isAligned = !_isAligned;
    });
    _showSnackBar(context);
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp())); // Redirige a main.dart
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Identificación del Reportante',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Profesión/Cargo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              items: ['Médico', 'Enfermero', 'Camillero', 'Otro'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
            SizedBox(height: 16.0),
            Text(
              'Teléfono o Extensión',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Correo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _startAnimation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Enviar Reporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Stack(
              children: [
                AnimatedAlign(
                  alignment: _isAligned ? Alignment.center : Alignment.bottomLeft,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: AnimatedOpacity(
                      opacity: _isAligned ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: AnimatedScale(
                        scale: _isAligned ? 1.0 : 0.0,
                        duration: Duration(seconds: 1),
                        child: Image.asset(
                          'assets/images/send.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
