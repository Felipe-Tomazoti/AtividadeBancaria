import 'dart:convert';
import 'package:atividadebancaria/models/transacao_model.dart';
import 'package:atividadebancaria/service/abstract_service.dart';

class TransacaoService extends AbstractService<Transacao> {
  @override
  String recurso() {
    return "transacoes";
  }

  @override
  Transacao fromJson(Map<String, dynamic> json) {
    return Transacao.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Transacao object) {
    return object.toJson();
  }
}
