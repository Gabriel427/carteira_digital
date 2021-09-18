import 'dart:collection';
import 'package:carteira_digital/databases/db_firestore.dart';
import 'package:carteira_digital/models/lancamento.dart';
import 'package:carteira_digital/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class LancamentoRepository extends ChangeNotifier {
  List<Lancamento> _lista = [];
  late FirebaseFirestore db;
  late AuthService auth;
  UnmodifiableListView<Lancamento> get lista => UnmodifiableListView(_lista);

  LancamentoRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await readLancamentos();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  readLancamentos() async {
    if (auth.usuario != null && _lista.isEmpty) {
      final snapshot = await db
          .collection('usuarios/${auth.usuario!.uid}/lancamentos')
          .get();

      snapshot.docs.forEach((doc) {
        Lancamento lancamento = Lancamento(
          id: doc.get('id'),
          titulo: doc.get('titulo'),
          descricao: doc.get('descricao'),
          imagem: doc.get('imagem'),
          categoria: doc.get('categoria'),
          valor: doc.get('valor'),
          data: doc.get('data'),
          uid: doc.get('uid'),
        );
        _lista.add(lancamento);
        notifyListeners();
        print('Lancamento carregados');
      });
    }
  }

  saveAll(List<Lancamento> lancamentos) {
    lancamentos.forEach((lancamento) async {
      if (!_lista.any((atual) => atual == lancamento)) {
        _lista.add(lancamento);
        await db
            .collection('usuarios/${auth.usuario!.uid}/lancamentos')
            .doc(lancamento.id.toString())
            .set({
          'id': lancamento.id,
          'titulo': lancamento.titulo,
          'descricao': lancamento.descricao,
          'imagem': lancamento.imagem,
          'categoria': lancamento.categoria,
          'valor': lancamento.valor,
          'data': lancamento.data,
          'uid': lancamento.uid,
        });
      }
    });
    notifyListeners();
  }

  saveOne(Lancamento lancamento) async {
    _lista.add(lancamento);
    await db
        .collection('usuarios/${auth.usuario!.uid}/lancamentos')
        .doc(lancamento.id.toString())
        .set({
      'id': lancamento.id,
      'titulo': lancamento.titulo,
      'descricao': lancamento.descricao,
      'imagem': lancamento.imagem,
      'categoria': lancamento.categoria,
      'valor': lancamento.valor,
      'data': lancamento.data,
      'uid': lancamento.uid,
    });
    notifyListeners();
  }

  remove(Lancamento lancamento) async {
    await db
        .collection('usuarios/${auth.usuario!.uid}/lancamentos')
        .doc(lancamento.id.toString())
        .delete();
    _lista.remove(lancamento);
    notifyListeners();
  }

  cleanList() {
    _lista.clear();
    notifyListeners();
  }
}
