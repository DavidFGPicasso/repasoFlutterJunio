import 'presupuesto.dart';

class Viajes {
  final String destino;
  final Presupuesto presupuesto;

  Viajes({required this.destino, required this.presupuesto});

  factory Viajes.fromJson(Map<String, dynamic> json) {
    final rawPres = json['presupuesto'];

    final Presupuesto presupuesto;

    
      // por si algún día la API devuelve un objeto en vez de lista
      presupuesto = Presupuesto.fromJson(Map<String, dynamic>.from(rawPres));
  

    return Viajes(
      destino: json['destino'],
      presupuesto: presupuesto,
    );
  }
}
