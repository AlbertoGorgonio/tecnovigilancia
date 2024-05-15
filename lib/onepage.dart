import 'package:flutter/material.dart';

import 'secondpage.dart'; // Importa la segunda página

class OnePage extends StatefulWidget {
  @override
  _OnePageState createState() => _OnePageState();
}

class _OnePageState extends State<OnePage> {
  TextEditingController _fechaNotificacionController = TextEditingController();
  TextEditingController _fechaIncidenteController = TextEditingController();

  @override
  void dispose() {
    _fechaNotificacionController.dispose();
    _fechaIncidenteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Color del appbar
        title: Center( // Centro el título del appbar
          child: Text(
            'Reporte de incidencias',
            style: TextStyle(
              fontSize: 20, // Tamaño del texto del appbar
              fontWeight: FontWeight.bold,
              color: Colors.white, // Color del texto del appbar
            ),
          ),
        ),
        leading: IconButton( // Botón de flecha de retroceso
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white), // Icono de flecha y color blanco
          onPressed: () {
            Navigator.pop(context); // Acción al presionar la flecha de retroceso
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Código de reporte',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Código de reporte',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Fecha de notificación',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  // Aquí puedes abrir un selector de fechas o un calendario
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _fechaNotificacionController.text =
                            selectedDate.toString();
                      });
                    }
                  });
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _fechaNotificacionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha de notificación',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Fecha de incidente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  // Aquí puedes abrir un selector de fechas o un calendario
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _fechaIncidenteController.text =
                            selectedDate.toString();
                      });
                    }
                  });
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _fechaIncidenteController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha de incidente',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Servicio o lugar donde ocurre el incidente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Seleccionar un área',
                ),
                items: <String>['Área 1', 'Área 2', 'Área 3'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/hospi.png', // Ruta de la imagen
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Color del botón
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SecondPage()),
                        );
                      },
                      child: Text(
                        'Continuar',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del botón
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
