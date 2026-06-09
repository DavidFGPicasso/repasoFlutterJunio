import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Pantalla 2: lee los documentos de la colección `libro` de Firestore.
// Muestra los libros y deja el botón de volver fijo en la parte inferior.
class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    // Comprobamos si Firebase se ha inicializado correctamente.
    final firebaseConfigured = Firebase.apps.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        // Título principal de la pantalla 2.
        title: const Text('Libros (Firestore)'),
      ),
      // El botón de volver queda abajo fijo usando bottomNavigationBar.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Volver a la primera pantalla y limpiar la pila de navegación.
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              child: const Text('Volver a la primera pantalla'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: firebaseConfigured
            ? StreamBuilder<QuerySnapshot>(
                // Stream en tiempo real de la colección libro.
                stream: FirebaseFirestore.instance.collection('libro').snapshots(),
                builder: (context, snapshot) {
                  // Errores de lectura.
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  // Carga inicial.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text('No hay libros en la colección'));
                  }

                  // Lista visual de libros.
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final d = docs[index].data() as Map<String, dynamic>;
                      final titulo = d['titulo'] ?? '';
                      final autor = d['autor'] ?? '';
                      final anho = d['anho'] ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Autor: $autor — Año: $anho'),
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                // Si Firebase no está inicializado, mostramos un mensaje claro.
                child: Text(
                  'Firebase no está configurado.\nAñade la configuración de Firebase para Android/iOS/Web.',
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
