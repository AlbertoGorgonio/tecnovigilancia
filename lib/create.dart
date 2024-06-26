import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedRole = 'Usuario';
  final String _adminCode = '123librefuego';

  Future<void> _createAccount() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    if (_selectedRole == 'Administrador' && _adminCodeController.text.trim() != _adminCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código incorrecto. Póngase en contacto con los Devs.')),
      );
      return;
    }

    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'contraseña': _passwordController.text.trim(),
          'role': _selectedRole,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cuenta creada exitosamente.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la cuenta.')),
      );
    }
  }

  void _showAdminCodeNotification() {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Si no cuentas con el código, comunicate con los desarrolladores.',
                  style: TextStyle(color: Colors.white),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      overlayEntry.remove();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Crear Cuenta',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/man.png'),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                cursorColor: Colors.blue,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                cursorColor: Colors.blue,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                cursorColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['Administrador', 'Usuario'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Row(
                      children: [
                        Icon(role == 'Administrador' ? Icons.admin_panel_settings : Icons.person),
                        SizedBox(width: 8),
                        Text(role),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Seleccionar Rol',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              if (_selectedRole == 'Administrador') ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _adminCodeController,
                  obscureText: true,
                  onTap: _showAdminCodeNotification,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Código de Administrador',
                    prefixIcon: Icon(Icons.security),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  cursorColor: Colors.blue,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text('Crear Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
