import 'package:flutter/material.dart';

class EstadisticaPage extends StatefulWidget {
  @override
  _EstadisticaPageState createState() => _EstadisticaPageState();
}

class _EstadisticaPageState extends State<EstadisticaPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios, // Flecha de iOS
          color: Colors.blue, // Color azul
        ),
        // Puedes agregar más propiedades al AppBar según sea necesario
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/grap.gif',
              width: 350,
              height: 350,
            ),
            SizedBox(height: 20.0),
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Esta área está en desarrollo.\n¡Pronto tendrás acceso a este apartado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
