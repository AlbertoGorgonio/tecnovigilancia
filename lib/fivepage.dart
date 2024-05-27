import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class FivePage extends StatefulWidget {
  @override
  _FivePageState createState() => _FivePageState();
}

class _FivePageState extends State<FivePage> {
  bool _isAligned = false;
  bool _isVisible = false;
  File? _image;

  final ImagePicker _picker = ImagePicker();
  TextEditingController _reporterNameController = TextEditingController();
  TextEditingController _reporterPositionController = TextEditingController();
  TextEditingController _reporterPhoneController = TextEditingController();
  TextEditingController _reporterEmailController = TextEditingController();
  String? _selectedProfession;

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Nada seleccionado');
      }
    });
  }

Future<void> _uploadImage() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuario no autenticado');
      return;
    }

    if (_image != null) {
      String userEmail = user.email!;
      Reference ref = FirebaseStorage.instance.ref().child('images/$userEmail.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      
      uploadTask.whenComplete(() async {
        try {
          String imageURL = await ref.getDownloadURL();
          await _saveForm(imageURL);
          print('Imagen subida exitosamente.');
        } catch (e) {
          print('Error al obtener la URL de descarga: $e');
        }
      });
    } else {
      print('No se ha seleccionado ninguna imagen.');
    }
  } catch (e) {
    print('Error al cargar la imagen: $e');
  }
}

  Future<void> _saveForm(String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuario no autenticado');
      return;
    }
    String userEmail = user.email!;
      await FirebaseFirestore.instance.collection('Formulario').doc(userEmail).set({
        'nombre_reportante': _reporterNameController.text,
        'profesion_cargo': _selectedProfession,
        'telefono_ext': _reporterPhoneController.text,
        'correo1': _reporterEmailController.text,
        'imagen_url': imageUrl,
      }, SetOptions(merge: true));
      print('Datos guardados correctamente');
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue.withOpacity(0.8),
        elevation: 6,
        content: Text(
          'Reporte enviado con éxito',
          style: TextStyle(color: Colors.white),
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    });
  }

  Widget _buildAnimatedElement(Widget child, int index, Alignment alignment) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset:
              Offset(alignment.x * (1 - value) * MediaQuery.of(context).size.width, 0),
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
          'Identificación de quien toma el reporte',
          style: TextStyle(
            fontSize: 18,
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
            _buildAnimatedElement(
              Text(
                'Nombre',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              0,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterNameController,
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
                'Profesión/Cargo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              2,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              DropdownButtonFormField<String>(
                items: ['Médico', 'Enfermero', 'Camillero', 'Otro'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedProfession = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              3,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Teléfono o Extensión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              4,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterPhoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              5,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Text(
                'Correo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              6,
              Alignment.centerLeft,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                controller: _reporterEmailController,
                decoration: InputDecoration(                  border: OutlineInputBorder(),
                ),
              ),
              7,
              Alignment.centerRight,
            ),
            SizedBox(height: 16.0),
            _buildAnimatedElement(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adjuntar Foto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.blue[50],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Subir Foto',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _image != null
                      ? Image.file(_image!, height: 200)
                      : Container(),
                ],
              ),
              8,
              Alignment.centerLeft,
            ),
            SizedBox(height: 24.0),
            Center(
              child: _buildAnimatedElement(
                ElevatedButton(
                  onPressed: () {
                    _uploadImage().then((_) => _startAnimation());
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
                9,
                Alignment.center,
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
