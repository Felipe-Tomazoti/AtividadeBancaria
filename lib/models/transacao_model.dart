import 'dart:convert';

class Transacao {
  final String id;
  final double valor;

  Transacao({
    required this.id,
    required this.valor,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(id: json['id'], valor: json['valor']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'Transacao{id: $id, valor: $valor}';
  }
}
