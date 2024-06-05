import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? _selectedArea;
  TextEditingController _healthProfessionalNameController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _patientAgeController = TextEditingController();
  TextEditingController _incidentDescriptionController = TextEditingController();
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

  Future<void> _saveForm() async {
    try {
      // Obtén el correo electrónico del usuario autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Usuario no autenticado');
        return;
      }
      String userEmail = user.email!;

      // Actualiza o crea el documento con los datos del formulario
      await FirebaseFirestore.instance.collection('Formulario').doc(userEmail).set({
        'servicio_lugar_incidente': _selectedArea,
        'deteccion_accidente': _selectedDetectionPeriod,
        'profesional_salud_afectado': _selectedHealthProfessionalAffected,
        'nombre_profesional_salud': _healthProfessionalNameController.text,
        'nombre_paciente': _patientNameController.text,
        'edad_paciente': _patientAgeController.text,
        'genero_paciente': _selectedGender,
        'tipo_incidente': _selectedIncidentType,
        'descripcion_incidente': _incidentDescriptionController.text,
      }, SetOptions(merge: true));
      print('Datos guardados correctamente');
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
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
  void dispose() {
    _healthProfessionalNameController.dispose();
    _patientNameController.dispose();
    _patientAgeController.dispose();
    _incidentDescriptionController.dispose();
    super.dispose();
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
    mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos en la columna
    crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los elementos horizontalmente
    children: [
      Container(
        alignment: Alignment.center, // Centra la imagen dentro del contenedor
        child: _buildAnimatedElement(
          Image.asset(
            'assets/images/medical.gif',
            height: 200.0,
          ),
          0,
          Alignment.center,
        ),
      ),
      SizedBox(height: 16.0),
      _buildAnimatedElement(
        Text('Servicio o lugar donde ocurre el incidente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              1,
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
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedArea = newValue;
                  });
                },
              ),
              2,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
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
              3,
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
              4,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                '¿Profesional de la salud se ve afectado?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              5,
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
              6,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Nombre del Profesional de la Salud',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              7,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _healthProfessionalNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              8,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Identificación del paciente',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              9,
              Alignment.centerLeft,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              TextField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre completo',
                ),
              ),
              10,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              TextField(
                controller: _patientAgeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edad',
                ),
              ),
              11,
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
              12,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Descripción de Incidente / Incidente Adverso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              13,
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
              14,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              TextField(
                controller: _incidentDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Describir Incidente',
                ),
              ),
              15,
              Alignment.centerRight,
            ),
            SizedBox(height: 24.0),
            Center(
              child: _buildAnimatedElement(
                ElevatedButton(
                  onPressed: () async {
                    await _saveForm();
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
                16,
                Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
