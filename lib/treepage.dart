import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fourpage.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  String? _selectedOption;
  String? _selectedCause;
  DateTime? _selectedExpiryDate;
  TextEditingController _deviceNameController = TextEditingController();
  TextEditingController _hraeiKeyController = TextEditingController();
  TextEditingController _sanitaryRegistrationNumberController = TextEditingController();
  TextEditingController _deviceClassificationController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _lotOrSeriesController = TextEditingController();
  bool _isVisible = false;
  bool _showForm = false; // Controla la visibilidad del formulario

  final List<String> imagePaths = [
    'assets/images/ImagesOver/1.png',
    'assets/images/ImagesOver/2.png',
    'assets/images/ImagesOver/3.png',
    'assets/images/ImagesOver/4.png',
    'assets/images/ImagesOver/5.png',
    'assets/images/ImagesOver/6.png',
  ];

  @override
  void initState() {
    super.initState();
    _animateElements();
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _hraeiKeyController.dispose();
    _sanitaryRegistrationNumberController.dispose();
    _deviceClassificationController.dispose();
    _brandController.dispose();
    _lotOrSeriesController.dispose();
    super.dispose();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedExpiryDate) {
      setState(() {
        _selectedExpiryDate = pickedDate;
      });
    }
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
        'desenlace_aplica': _selectedOption,
        'causa_detectada': _selectedOption == 'Sí' ? _selectedCause : null,
        'nombre_dispositivo': _deviceNameController.text,
        'clave_hraei': _hraeiKeyController.text,
        'numero_registro_sanitario': _sanitaryRegistrationNumberController.text,
        'clasificacion_dispositivo': _deviceClassificationController.text,
        'marca': _brandController.text,
        'lote_o_serie': _lotOrSeriesController.text,
        'fecha_caducidad': _selectedExpiryDate?.toIso8601String(),
      }, SetOptions(merge: true));
      print('Datos guardados correctamente');
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  }

  List<Widget> _buildImageWidgets() {
    return imagePaths.map((path) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _showForm = true;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Image.asset(
              path,
              fit: BoxFit.contain, // Ajusta la imagen a su aspecto original
              width: 150,
              height: 150,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Identificación del Dispositivo Médico',
          style: TextStyle(
            fontSize: 18,
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
            Center(
              child: _buildAnimatedElement(
                Image.asset(
                  'assets/images/gloves.png',
                  width: 150,
                  height: 150,
                ),
                0,
                Alignment.center,
              ),
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Desenlace(s) que aplique(n)',
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
                  labelText: 'Seleccionar desenlace',
                ),
                items: [
                  'Muerte',
                  'Intervención médica o quirúrgica',
                  'Daño de una función o estructura corporal',
                  'Hospitalización inicial o prolongada',
                  'Enfermedad o daño que amenace la vida',
                  'No hubo daño o lesión',
                  'Otro, ¿cuál?'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
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
                  Text(
                    '¿Se detectó la causa?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Sí',
                        groupValue: _selectedOption,
                        activeColor: Colors.red,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                      Text('Sí'),
                      Radio<String>(
                        value: 'No',
                        groupValue: _selectedOption,
                        activeColor: Colors.red,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                ],
              ),
              3,
              Alignment.centerLeft,
            ),
            SizedBox(height: 16.0),
            if (_selectedOption == 'Sí')
              _buildAnimatedElement(
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Seleccionar causa',
                  ),
                  items: [
                    'Calidad',
                    'Diseño',
                    'Condiciones de almacenamiento',
                    'Error de uso',
                    'Instrucciones para uso y etiquetado',
                    'Mantenimiento y/o calibración',
                    'Otro, ¿cuál?'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCause = value;
                    });
                  },
                ),
                4,
                Alignment.centerRight,
              ),
            SizedBox(height: 16.0),

            // Texto centrado con fuente estética y icono de touch
            Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                children: [
                Text(
                'Seleccione Dispositivo',
                style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                ),
                ),
                  SizedBox(width: 8),
                  Icon(Icons.touch_app, size: 45, color: Colors.blue),
                    ],
                    ),
                      ),

            // CarouselSlider ajustado
            _buildAnimatedElement(
              CarouselSlider(
                options: CarouselOptions(
                  height: min(screenWidth / 2.9 * (17 / 9), screenHeight * .9),
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.4, // Ajusta esta fracción para mostrar parcialmente las imágenes adyacentes
                ),
                items: _buildImageWidgets(),
              ),
              5,
              Alignment.center,
            ),
            SizedBox(height: 16.0),
            if (_showForm) ...[
              _buildAnimatedElement(
                Text(
                  'Datos del Dispositivo Médico',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                6,
                Alignment.centerLeft,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  controller: _deviceNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del dispositivo médico',
                    border: OutlineInputBorder(),
                  ),
                ),
                7,
                Alignment.centerRight,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  controller: _hraeiKeyController,
                  decoration: InputDecoration(
                    labelText: 'Clave de HRAEI',
                    border: OutlineInputBorder(),
                  ),
                ),
                8,
                Alignment.centerRight,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  controller: _sanitaryRegistrationNumberController,
                  decoration: InputDecoration(
                    labelText: 'Número de registro sanitario',
                    border: OutlineInputBorder(),
                  ),
                ),
                9,
                Alignment.centerRight,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  controller: _deviceClassificationController,
                  decoration: InputDecoration(
                    labelText: 'Clasificación del dispositivo médico de acuerdo a su categoría de uso',
                    border: OutlineInputBorder(),
                  ),
                ),
                10,
                Alignment.centerRight,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder(),
                  ),
                ),
                11,
                Alignment.centerRight,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  controller: _lotOrSeriesController,
                  decoration: InputDecoration(
                    labelText: 'Lote o Serie',
                    border: OutlineInputBorder(),
                  ),
                ),
                12,
                Alignment.centerRight,
              ),
              SizedBox(height: 8.0),
              _buildAnimatedElement(
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Fecha de caducidad',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectDate(context),
                  controller: TextEditingController(
                    text: _selectedExpiryDate == null
                        ? ''
                        : "${_selectedExpiryDate!.day}/${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year}",
                  ),
                ),
                13,
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
                        MaterialPageRoute(builder: (context) => FourPage()),
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
                  14,
                  Alignment.center,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TreePage(),
  ));
}
