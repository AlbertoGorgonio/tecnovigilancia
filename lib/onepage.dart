import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'secondpage.dart';

class OnePage extends StatefulWidget {
  @override
  _OnePageState createState() => _OnePageState();
}

class _OnePageState extends State<OnePage> {
  TextEditingController _fechaNotificacionController = TextEditingController();
  TextEditingController _fechaIncidenteController = TextEditingController();
  bool _isVisible = false;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _setFechaNotificacion();
    _generateCodigoReporte();
    _animateElements();
    _getUserEmail();
  }

  void _setFechaNotificacion() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";
    _fechaNotificacionController.text = formattedDate;
  }

  String _codigoReporte = '';

  void _generateCodigoReporte() {
    setState(() {
      _codigoReporte = 'HRAEI/UTV/01/2024';
    });
  }

  void _animateElements() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isVisible = true;
    });
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  Future<void> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';
      });
    }
  }

  @override
  void dispose() {
    _fechaNotificacionController.dispose();
    _fechaIncidenteController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    try {
      await FirebaseFirestore.instance.collection('Formulario').doc(_userEmail).set({
        'codigo_reporte': _codigoReporte,
        'fecha_notificacion': _fechaNotificacionController.text,
        'fecha_incidente': _fechaIncidenteController.text,
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            'Reporte de incidencias',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildAnimatedElement(
                Text(
                  'Código de reporte',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                0,
                Alignment.centerLeft,
              ),
              SizedBox(height: 8),
              _buildAnimatedElement(
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Código de reporte',
                    hintText: _codigoReporte,
                  ),
                ),
                1,
                Alignment.centerRight,
              ),
              SizedBox(height: 16),
              _buildAnimatedElement(
                Text(
                  'Fecha de notificación',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                2,
                Alignment.centerLeft,
              ),
              SizedBox(height: 8),
              _buildAnimatedElement(
                AbsorbPointer(
                  child: TextField(
                    controller: _fechaNotificacionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha de notificación',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                3,
                Alignment.centerRight,
              ),
              SizedBox(height: 16),
              _buildAnimatedElement(
                Text(
                  'Fecha de incidente',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                4,
                Alignment.centerLeft,
              ),
              SizedBox(height: 8),
              _buildAnimatedElement(
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _fechaIncidenteController.text = "${selectedDate.year}-${_twoDigits(selectedDate.month)}-${_twoDigits(selectedDate.day)}";
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
                5,
                Alignment.centerRight,
              ),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    _buildAnimatedElement(
                      Image.asset(
                        'assets/images/ad.png',
                        width: 200,
                        height: 200,
                      ),
                      6,
                      Alignment.center,
                    ),
                    SizedBox(height: 16),
                    _buildAnimatedElement(
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          await _saveForm();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondPage()),
                          );
                        },
                        child: Text(
                          'Continuar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      7,
                      Alignment.center,
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
