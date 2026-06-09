import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/screen1.dart';
import 'screens/screen2.dart';

/// Aplicación principal para el examen.
/// - Ruta `/` muestra la `Screen1` (JSON remoto)
/// - Ruta `/screen2` muestra la `Screen2` (Firestore colección `libro`)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialización opcional de Firebase: si falta configuración, la app
  // seguirá funcionando para la pantalla que usa HTTP.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // No hacer nada: el alumno puede no tener configurado Firebase.
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MateApp - Repaso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const Screen1(),
        '/screen2': (context) => const Screen2(),
      },
    );
  }
}
