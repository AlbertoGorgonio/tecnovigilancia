import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fivepage.dart';

class FourPage extends StatefulWidget {
  @override
  _FourPageState createState() => _FourPageState();
}

class _FourPageState extends State<FourPage> {
  bool _isVisible = false;
  TextEditingController _managementController = TextEditingController();
  TextEditingController _actionsController = TextEditingController();
  TextEditingController _reporterNameController = TextEditingController();
  TextEditingController _reporterPositionController = TextEditingController();
  TextEditingController _reporterPhoneController = TextEditingController();
  TextEditingController _reporterEmailController = TextEditingController();

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

  Future<void> _saveForm() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Usuario no autenticado');
        return;
      }
      String userEmail = user.email!;

      await FirebaseFirestore.instance.collection('Formulario').doc(userEmail).set({
        'gestion_realizada': _managementController.text,
        'acciones_correctivas_preventivas': _actionsController.text,
        'nombre_reportante': _reporterNameController.text,
        'profesion_cargo': _reporterPositionController.text,
        'telefono_ext': _reporterPhoneController.text,
        'correo': _reporterEmailController.text,
      }, SetOptions(merge: true));
      print('Datos guardados correctamente');
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  }

  @override
  void dispose() {
    _managementController.dispose();
    _actionsController.dispose();
    _reporterNameController.dispose();
    _reporterPositionController.dispose();
    _reporterPhoneController.dispose();
    _reporterEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Información Adicional',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
            _buildAnimatedElement(
              Text(
                'Gestión Realizada',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              0,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _managementController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              1,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Acciones Correctivas y/o Preventivas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              2,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _actionsController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              3,
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
                    'Identificación del Reportante',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              4,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              Center(
                child: Image.asset(
                  'assets/images/ident.png',
                  width: 300,
                  height: 300,
                ),
              ),
              5,
              Alignment.center,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              6,
              Alignment.centerRight,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterPositionController,
                decoration: InputDecoration(
                  labelText: 'Profesión/Cargo',
                  border: OutlineInputBorder(),
                ),
              ),
              7,
              Alignment.centerRight,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterPhoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono o Ext.',
                  border: OutlineInputBorder(),
                ),
              ),
              8,
              Alignment.centerRight,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterEmailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              9,
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
                      MaterialPageRoute(builder: (context) => FivePage()),
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
                10,
                Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
