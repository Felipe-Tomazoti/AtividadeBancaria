import 'dart:convert';

import 'package:atividadebancaria/service/abstract_service.dart';
import 'package:http/http.dart' as http;

class TransacaoService extends AbstractService {
  @override
  String recurso() {
    return "transacoes";
  }
}
