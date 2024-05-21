import 'package:flutter/material.dart';

import 'fivepage.dart';

class FourPage extends StatefulWidget {
  @override
  _FourPageState createState() => _FourPageState();
}

class _FourPageState extends State<FourPage> {
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              5,
              Alignment.centerRight,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                decoration: InputDecoration(
                  labelText: 'Profesión/Cargo',
                  border: OutlineInputBorder(),
                ),
              ),
              6,
              Alignment.centerRight,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                decoration: InputDecoration(
                  labelText: 'Teléfono o Ext.',
                  border: OutlineInputBorder(),
                ),
              ),
              7,
              Alignment.centerRight,
            ),
            SizedBox(height: 8.0),
            _buildAnimatedElement(
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              8,
              Alignment.centerRight,
            ),
            SizedBox(height: 24.0),
            Center(
              child: _buildAnimatedElement(
                ElevatedButton(
                  onPressed: () {
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
                9,
                Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
