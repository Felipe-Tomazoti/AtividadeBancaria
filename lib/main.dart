import 'package:atividadebancaria/models/transacao_model.dart';
import 'package:atividadebancaria/service/transacao_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade Bancária',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Página com CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final api = TransacaoService();
  String message = "";
  List<Transacao> transacoes = [];
  Transacao? transacaoBuscada;

  void _createTransacao() async {
    try {
      String id = _idController.text.toString();
      double valor = double.parse(_valorController.text);
      String tipo = _tipoController.text;

      var body = {
        "id": id,
        "valor": valor,
        "tipo": tipo,
      };

      final result = await api.postTransacoes(body);
      setState(() {
        message = result['message'];
      });
    } catch (e) {
      setState(() {
        message = "Erro ao criar transação: $e";
      });
    }
  }

  void _updateTransacao() async {
    try {
      String id = _idController.text.toString();
      double valor = double.parse(_valorController.text);
      String tipo = _tipoController.text;

      var body = {
        "id": id,
        "valor": valor,
        "tipo": tipo,
      };

      final result = await api.updateTransacoes(id, body);
      setState(() {
        message = result['message'];
      });
    } catch (e) {
      setState(() {
        message = "Erro ao atualizar a transação: $e";
      });
    }
  }

  void _deleteTransacao() async {
    try {
      String id = _idController.text.toString();
      final result = await api.deleteTransacoes(id);
      setState(() {
        message = result['message'];
      });
    } catch (e) {
      setState(() {
        message = "Erro ao deletar a transação: $e";
      });
    }
  }

  void _getById() async {
    try {
      String id = _idController.text.toString();
      var result = await api.getById(id);
      setState(() {
        transacaoBuscada = result;
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
      });
    } catch (e) {
      setState(() {
        message = "Erro ao buscar as transações: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tipoController,
              decoration: InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createTransacao,
              child: const Text('Criar Transação'),
            ),
            ElevatedButton(
              onPressed: _updateTransacao,
              child: const Text('Atualizar a transação de acordo com o ID'),
            ),
            ElevatedButton(
              onPressed: _getAll,
              child: const Text('Buscar todas as Transações'),
            ),
            ElevatedButton(
              onPressed: _getById,
              child: const Text('Buscar a transação de acordo com o ID'),
            ),
            ElevatedButton(
              onPressed: _deleteTransacao,
              child: const Text('Deletar a transação de acordo com o ID'),
            ),
            SizedBox(height: 20),
            transacaoBuscada != null
                ? Column(
                    children: [
                      Text('Transação Encontrada: '),
                      Text('ID: ${transacaoBuscada!.id}'),
                      Text('Valor: ${transacaoBuscada!.valor}'),
                      Text('Tipo: ${transacaoBuscada!.tipo}'),
                      const SizedBox(height: 20),
                    ],
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: transacoes.isNotEmpty
                  ? ListView.builder(
                      itemCount: transacoes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('ID: ${transacoes[index].id}'),
                          subtitle: Text(
                            'Valor: ${transacoes[index].valor}\nTipo: ${transacoes[index].tipo}',
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
