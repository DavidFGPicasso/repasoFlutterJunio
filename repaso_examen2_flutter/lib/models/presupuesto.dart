class Presupuesto {
  final int estimado;
  final int gastado;
  final String moneda;

  Presupuesto({required this.estimado, required this.gastado, required this.moneda});

  factory Presupuesto.fromJson(Map<String, dynamic> json){
    return Presupuesto(
      estimado: json["estimado"],
      gastado: json["gastado"],
      moneda: json["moneda"]
    );
  }
}