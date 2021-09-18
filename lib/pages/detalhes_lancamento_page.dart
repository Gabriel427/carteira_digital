import 'dart:io';

import 'package:carteira_digital/models/Constants.dart';
import 'package:carteira_digital/models/lancamento.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';

class DetalhesLancamentoPage extends StatefulWidget {
  final Lancamento lancamento;

  DetalhesLancamentoPage({Key? key, required this.lancamento})
      : super(key: key);

  @override
  _DetalhesLancamentoPageState createState() => _DetalhesLancamentoPageState();
}

class _DetalhesLancamentoPageState extends State<DetalhesLancamentoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lancamento.titulo),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: compartilharPreco,
          ),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Descrição: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Text(
                  widget.lancamento.descricao,
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Categoria: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  widget.lancamento.categoria,
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Valor: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  widget.lancamento.valor.toString(),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Image.file(File(widget.lancamento.imagem)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
        tooltip: 'Editar',
        backgroundColor: Colors.lightGreen,
      ),
    );
  }

  compartilharPreco() {
    SocialShare.shareOptions(
      "O lançamento ${widget.lancamento.titulo} no valor de ${widget.lancamento.valor} vencerá no dia ${widget.lancamento.data}",
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Editar) {
      print('Editar');
    } else if (choice == Constants.Excluir) {
      print('Excluir');
    }
  }
}
