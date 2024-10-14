import 'dart:convert';

import 'package:atividadebancaria/models/transacao_model.dart';
import 'package:http/http.dart' as http;

abstract class AbstractService {
  final String url = "http://localhost:3000";

  Future<List<Transacao>> getAll() async {
    var response = await http.get(Uri.parse("$url/${recurso()}"));
    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      return jsonList.map((json) => Transacao.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao carregar a transação");
    }
  }

  Future<Transacao> getById(String id) async {
    var response = await http.get(Uri.parse("$url/${recurso()}/$id"));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return Transacao.fromJson(jsonResponse);
    } else {
      throw Exception("Falha ao carregar a transação");
    }
  }

  Future<Map<String, dynamic>> postTransacoes(Object body) async {
    var response = await http.post(
      Uri.parse("$url/${recurso()}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return {"status": 201, "message": "Criação feita!"};
    } else {
      return {
        "status": response.statusCode,
        "message": "Erro: ${response.body}"
      };
    }
  }

  Future<Map<String, dynamic>> deleteTransacoes(String id) async {
    var response = await http.delete(Uri.parse("$url/${recurso()}/$id"));
    if (response.statusCode == 200) {
      return {"status": 204, "message": "Exclusão feita com sucesso!"};
    } else {
      return {
        "status": response.statusCode,
        "message": "Erro: ${response.body}"
      };
    }
  }

  Future<Map<String, dynamic>> updateTransacoes(
      String id, Map<String, dynamic> body) async {
    var response = await http.put(
      Uri.parse("$url/${recurso()}/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return {"status": 202, "message": "Atualização feita!"};
    } else {
      return {
        "status": response.statusCode,
        "message": "Erro: ${response.body}"
      };
    }
  }

  String recurso();
}
