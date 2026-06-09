import 'dart:convert';
import 'package:flutter/material.dart';
// importar el http para poder interactuar con los json.
import 'package:http/http.dart' as http;
// Importamos los modelos y screen2 para la navegación.
import 'package:repaso_examen2_flutter/models/viajes.dart';
import 'package:repaso_examen2_flutter/screens/screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}


// Pantalla 1: obtiene el JSON remoto y muestra los viajes de forma ordenada.
// Muestra una lista con ExpansionTiles; cada viaje muestra campos básicos.
class _Screen1State extends State<Screen1> {
 
  // lista con future para guardar los viajes del json.
  late Future<List<Viajes>> _futureViajes;
  // método asíncrono para obtener los viajes.
  Future<List<Viajes>> cargarViajes() async {
    // obtenemos los viajes.
    final response = await http.get(
      Uri.parse('https://raw.githubusercontent.com/FranMFB/DesarrolloWeb/refs/heads/main/db.json'),
    );
    // Si la solicitud es válida (código 200), obtenemos los datos del json.
    if (response.statusCode == 200) {
      // datos del json.
      final data = jsonDecode(response.body);
      // extraemos las claves de viajes (cambiar nombre según el objeto).
      final rawViajes = data['viajes'];

      if (data is! Map<String, dynamic>) {
        throw Exception('El JSON raíz no es un objeto');
      }

      if (rawViajes is! List) {
        throw Exception('La clave "ciudades" no es una lista');
      }
      // Pasamos los datos del json a una lista.
      return rawViajes.whereType<Map<String, dynamic>>().map((e) => Viajes.fromJson(e)).toList();
    }
     else {
      throw Exception('Error al cargar datos: ${response.statusCode}');
    }

  }

    @override
  void initState() {
    super.initState();
    _futureViajes = cargarViajes();
  }


  @override
  Widget build(BuildContext context) {
    // parte visual (scaffold).
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Text('David Flores Gutiérrez'),
            // SizedBox para separar elementos del appbar.
            SizedBox(
              width: 50,
            ),
            // botón para la navegación.
            ElevatedButton(
              child: Text("Siguiente"),
              onPressed: (){
                // redireccionamos a la pantalla 2.
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen2()));
              } 
            ),
          ],
        ),
      ),
      // Lista con los viajes.
      body: FutureBuilder<List<Viajes>>(
        future: _futureViajes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final viajes = snapshot.data ?? const <Viajes>[];

          if (viajes.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          }


          return ListView.builder(
            itemCount: viajes.length,
            itemBuilder: (context, index) {
              final v = viajes[index];
              final pres = v.presupuesto;

              final presTxt = 'Presupuesto estimado: ${pres.estimado}, Gastado: ${pres.gastado}, Moneda: (${pres.moneda})';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                borderOnForeground: true,
                elevation: 20,
                child: ListTile(
                  title: Text(
                    v.destino,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(presTxt),
                  style: null,
                ),
              );
            }
          );
        }
        ),
      );
  }
}