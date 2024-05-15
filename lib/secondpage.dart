import 'package:flutter/material.dart';

import 'treepage.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? _selectedDetectionPeriod;
  String? _selectedGender;

  List<String> _ages = List.generate(56, (index) => (15 + index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Reporte de Incidente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Edad',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: _ages.first,
              items: _ages.map((String age) {
                return DropdownMenuItem<String>(
                  value: age,
                  child: Text(age),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  // Handle age selection
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Género',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ['Hombre', 'Mujer', 'Prefiero no decirlo'].map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 40), // Cambio de icono a uno relacionado con la detección de accidentes
                SizedBox(width: 16.0),
                Text(
                  'Detección del Accidente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDetectionPeriod = 'Antes';
                    });
                  },
                  child: Text(
                    'Antes',
                    style: TextStyle(
                      fontWeight: _selectedDetectionPeriod == 'Antes' ? FontWeight.bold : FontWeight.normal,
                      color: _selectedDetectionPeriod == 'Antes' ? Colors.red : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDetectionPeriod = 'Durante';
                    });
                  },
                  child: Text(
                    'Durante',
                    style: TextStyle(
                      fontWeight: _selectedDetectionPeriod == 'Durante' ? FontWeight.bold : FontWeight.normal,
                      color: _selectedDetectionPeriod == 'Durante' ? Colors.red : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDetectionPeriod = 'Después';
                    });
                  },
                  child: Text(
                    'Después',
                    style: TextStyle(
                      fontWeight: _selectedDetectionPeriod == 'Después' ? FontWeight.bold : FontWeight.normal,
                      color: _selectedDetectionPeriod == 'Después' ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              '¿Profesional de la salud se ve afectado?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              items: ['Sí', 'No'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
            SizedBox(height: 16.0),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Descripción del Incidente',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nombre del Profesional de la Salud',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                  ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Descripción de Incidente / Incidente Adverso',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TreePage()), // Navega a TreePage
            );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}