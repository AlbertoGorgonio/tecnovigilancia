import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'estadistica.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  _startLoading() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToEstadisticaPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EstadisticaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
            body: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.blue,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToEstadisticaPage,
                          child: Icon(
                            Icons.show_chart,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espacio para separar el título de los reportes
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'REPORTES TECNOVIGILANCIA',
                        style: TextStyle(
                          fontSize: 21, // Texto más pequeño
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Texto en rojo negritas
                        ),
                      ),
                      SizedBox(width: 10), // Espacio entre el texto y el icono
                      Icon(Icons.report, color: Colors.red), // Icono de reporte en rojo
                    ],
                  ),
                ),
                SizedBox(height: 20), // Espacio para separar el título de los reportes
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Formulario').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return ErrorScreen();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingScreen();
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No hay reportes registrados',
                            style: TextStyle(
                              color: Colors.blue, // Texto en azul
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot document = snapshot.data!.docs[index];
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          int numeroReporte = index + 1; // Obtener el número de reporte automáticamente
                          String reporteTitle = 'Reporte $numeroReporte';
                          String fechaNotificacion = data['fecha_notificacion'] ?? 'Fecha no disponible'; // Obtener la fecha de notificación del documento

                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade900, Colors.blue.shade300],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  reporteTitle,
                                  style: TextStyle(
                                    color: Colors.white, // Texto blanco
                                    fontWeight: FontWeight.bold, // Texto en negritas
                                  ),
                                ),
                                subtitle: Text(
                                  fechaNotificacion,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        title: Text(
                                          'Detalles del Reporte',
                                          style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: data.entries.map((e) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(
                                                  '${e.key}: ${e.value}',
                                                  style: TextStyle(
                                                    color: Colors.black, // Texto en negro para facilitar la lectura
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'Generar PDF',
                                              style: TextStyle(color: Colors.blue.shade900),
                                            ),
                                            onPressed: () async {
                                              final pdf = pw.Document();
                                              pdf.addPage(
                                                pw.Page(
                                                  pageFormat: PdfPageFormat.a4,
                                                  build: (pw.Context context) {
                                                    return pw.Center(
                                                      child: pw.Column(
                                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                        children: data.entries.map((e) {
                                                          return pw.Text('${e.key}: ${e.value}');
                                                        }).toList(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                              await Printing.layoutPdf(
                                                onLayout: (PdfPageFormat format) async => pdf.save(),
                                              );
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Cerrar',
                                              style: TextStyle(color: Colors.blue.shade900),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

// Pantalla de carga personalizada con efecto de foco azul deslumbrante
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 200,
          height: 10,
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 1),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.blue.withOpacity(0.3),
              );
            },
            onEnd: () {
              // Repetir la animación
              (context as Element).markNeedsBuild();
            },
          ),
        ),
      ),
    );
  }
}

// Pantalla de error personalizada
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Error al inicializar Firebase',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
