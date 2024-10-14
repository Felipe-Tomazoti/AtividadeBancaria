import 'dart:convert';

class Transacao {
  final String id;
  final double valor;
  final String tipo;

  Transacao({
    required this.id,
    required this.valor,
    required this.tipo,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(id: json['id'], valor: json['valor'], tipo: json['tipo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valor': valor,
      'tipo': tipo,
    };
  }

  @override
  String toString() {
    return 'Transacao{id: $id, valor: $valor, tipo: $tipo}';
  }
}
