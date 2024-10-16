import 'package:atividadebancaria/models/transacao_model.dart';
import 'package:atividadebancaria/service/transacao_service.dart';
import 'package:flutter/material.dart';

class TransacaoScreen extends StatefulWidget {
  const TransacaoScreen({super.key, required this.title});

  final String title;

  @override
  State<TransacaoScreen> createState() => _TransacaoScreenState();
}

class _TransacaoScreenState extends State<TransacaoScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TransacaoService api = TransacaoService();
  String message = "";
  List<Transacao> transacoes = [];
  Transacao? transacaoBuscada;

  void _createTransacao() async {
    try {
      String id = _idController.text.trim();
      if (id.isEmpty) {
        setState(() {
          message = "ID não pode estar vazio.";
        });
        return;
      }

      double? valor = double.tryParse(_valorController.text.trim());
      if (valor == null) {
        setState(() {
          message = "Valor inválido.";
        });
        return;
      }

      Transacao transacao = Transacao(id: id, valor: valor);

      final result = await api.post(transacao);
      setState(() {
        message = result['message'];
        _clearFields();
        _getAll();
      });
    } catch (e) {
      setState(() {
        message = "Erro ao criar transação: $e";
      });
    }
  }

  void _updateTransacao() async {
    try {
      String id = _idController.text.trim();
      if (id.isEmpty) {
        setState(() {
          message = "ID não pode estar vazio.";
        });
        return;
      }

      double? valor = double.tryParse(_valorController.text.trim());
      if (valor == null) {
        setState(() {
          message = "Valor inválido.";
        });
        return;
      }

      Transacao transacao = Transacao(id: id, valor: valor);

      final result = await api.update(id, transacao);
      setState(() {
        message = result['message'];
        _clearFields();
        _getAll();
      });
    } catch (e) {
      setState(() {
        message = "Erro ao atualizar a transação: $e";
      });
    }
  }

  void _deleteTransacao() async {
    try {
      String id = _idController.text.trim();
      if (id.isEmpty) {
        setState(() {
          message = "ID não pode estar vazio.";
        });
        return;
      }

      final result = await api.delete(id);
      setState(() {
        message = result['message'];
        _clearFields();
        _getAll();
      });
    } catch (e) {
      setState(() {
        message = "Erro ao deletar a transação: $e";
      });
    }
  }

  void _getById() async {
    try {
      String id = _idController.text.trim();
      if (id.isEmpty) {
        setState(() {
          message = "ID não pode estar vazio.";
        });
        return;
      }

      var result = await api.getById(id);
      setState(() {
        transacaoBuscada = result;
        message = "Transação encontrada.";
      });
    } catch (e) {
      setState(() {
        message = "Erro ao buscar a transação: $e";
      });
    }
  }

  void _getAll() async {
    try {
      var result = await api.getAll();
      setState(() {
        transacoes = result;
        message = "Transações carregadas.";
      });
    } catch (e) {
      setState(() {
        message = "Erro ao buscar as transações: $e";
      });
    }
  }

  void _clearFields() {
    _idController.clear();
    _valorController.clear();
    transacaoBuscada = null;
  }

  @override
  void dispose() {
    _idController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _createTransacao,
                  child: const Text('Criar Transação'),
                ),
                ElevatedButton(
                  onPressed: _updateTransacao,
                  child: const Text('Atualizar Transação'),
                ),
                ElevatedButton(
                  onPressed: _deleteTransacao,
                  child: const Text('Deletar Transação'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getById,
              child: const Text('Buscar Transação por ID'),
            ),
            ElevatedButton(
              onPressed: _getAll,
              child: const Text('Buscar Todas as Transações'),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            if (transacaoBuscada != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transação Encontrada:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('ID: ${transacaoBuscada!.id}'),
                  Text('Valor: ${transacaoBuscada!.valor}'),
                  const SizedBox(height: 20),
                ],
              ),
            if (transacoes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lista de Transações:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transacoes.length,
                    itemBuilder: (context, index) {
                      final transacao = transacoes[index];
                      return Card(
                        child: ListTile(
                          title: Text('ID: ${transacao.id}'),
                          subtitle: Text(
                            'Valor: ${transacao.valor}\n',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
