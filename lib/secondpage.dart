import 'package:flutter/material.dart';

import 'treepage.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? _selectedDetectionPeriod;
  String? _selectedHealthProfessionalAffected;
  String? _selectedIncidentType;
  String? _selectedGender;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animateElements();
  }

  void _animateElements() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isVisible = true;
    });
  }

  Widget _buildAnimatedElement(Widget child, int index, Alignment alignment) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(alignment.x * (1 - value) * MediaQuery.of(context).size.width, 0),
          child: child,
        );
      },
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: child,
      ),
    );
  }

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
            // Campo "Servicio o lugar donde ocurre el incidente"
            _buildAnimatedElement(
              Text(
                'Servicio o lugar donde ocurre el incidente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              0,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
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
              1,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            // Campo "Detección del accidente (Seleccionar)" con icono
            _buildAnimatedElement(
              Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(width: 16.0),
                  Text(
                    'DETECCIÓN DEL INCIDENTE (SELECCIONAR)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              2,
              Alignment.centerLeft,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
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
              3,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            // Campo "¿Profesional de la salud se ve afectado?"
            _buildAnimatedElement(
              Text(
                '¿Profesional de la salud se ve afectado?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              4,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              Row(
                children: [
                  Radio<String>(
                    value: 'Sí',
                    groupValue: _selectedHealthProfessionalAffected,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedHealthProfessionalAffected = value;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  Text('Sí'),
                  Radio<String>(
                    value: 'No',
                    groupValue: _selectedHealthProfessionalAffected,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedHealthProfessionalAffected = value;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  Text('No'),
                ],
              ),
              5,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            // Campo "Nombre del profesional de la salud"
            _buildAnimatedElement(
              Text(
                'Nombre del Profesional de la Salud',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              6,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              7,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            // Campo "IDENTIFICACION DEL PACIENTE"
            _buildAnimatedElement(
              Container(
                color: Colors.blue,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'IDENTIFICACION DEL PACIENTE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              8,
              Alignment.centerLeft,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre completo',
                ),
              ),
              9,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edad',
                ),
              ),
              10,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Género',
                ),
                items: <String>['Hombre', 'Mujer', 'Prefiero no decir'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              11,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            // Campo "Descripción de Incidente / Incidente Adverso" solo título
            _buildAnimatedElement(
              Text(
                'Descripción de Incidente / Incidente Adverso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              12,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              Column(
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Incidente',
                        groupValue: _selectedIncidentType,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedIncidentType = value;
                          });
                        },
                        activeColor: Colors.red,
                      ),
                      Text('Incidente'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Incidente Adverso',
                        groupValue: _selectedIncidentType,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedIncidentType = value;
                          });
                        },
                        activeColor: Colors.red,
                      ),
                      Text('Incidente Adverso'),
                    ],
                  ),
                ],
              ),
              13,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Describir Incidente',
                ),
              ),
              14,
              Alignment.centerRight,
            ),
            SizedBox(height: 24.0),
            Center(
              child: _buildAnimatedElement(
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TreePage()),
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
                15,
                Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
