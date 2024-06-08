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
  int _currentIndex = 0;

  // Añadimos un PageController
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _animateElements();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _hraeiKeyController.dispose();
    _sanitaryRegistrationNumberController.dispose();
    _deviceClassificationController.dispose();
    _brandController.dispose();
    _lotOrSeriesController.dispose();
    _pageController.dispose(); // Asegúrate de disponer del PageController
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

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = [
      'assets/images/1.png',
      'assets/images/2.png',
      'assets/images/3.png',
      'assets/images/4.png',
      'assets/images/5.png',
      'assets/images/6.png',
    ];

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
                  width: 250,
                  height: 250,
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

            // Menú carrusel de imágenes
            _buildAnimatedElement(
              Container(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagePaths.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        return Center(
                          child: SizedBox(
                            height: Curves.easeOut.transform(value) * 200,
                            width: Curves.easeOut.transform(value) * 200,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              14,
              Alignment.center,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Datos del Dispositivo Médico',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              5,
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
              6,
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
              7,
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
              8,
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
              9,
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
              10,
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
              11,
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
              12,
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
                13,
                Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
