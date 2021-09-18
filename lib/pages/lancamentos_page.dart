import 'package:carteira_digital/pages/adicionar_lancamento_page.dart';
import 'package:carteira_digital/pages/detalhes_lancamento_page.dart';
import 'package:carteira_digital/repositories/lancamentos_repository.dart';
import 'package:carteira_digital/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carteira_digital/models/lancamento.dart';
import 'package:provider/provider.dart';

class LancamentosPage extends StatefulWidget {
  LancamentosPage({Key? key}) : super(key: key);

  @override
  _LancamentosPageState createState() => _LancamentosPageState();
}

class _LancamentosPageState extends State<LancamentosPage> {
  late LancamentoRepository lancamentos;

  void _adicionarLancamento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdicionarLancamentoPage(),
      ),
    );
    print('adiciona');
  }

  mostrarDetalhes(Lancamento lancamento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesLancamentoPage(lancamento: lancamento),
      ),
    );
  }

  filtradata() {
    //lancamentos.lista[].data;
  }

/*title: Text(obj!.titulo),
                  subtitle: Text(obj.data),*/
  @override
  Widget build(BuildContext context) {
    //var tabela = LancamentoRepository.tabela;
    lancamentos = Provider.of<LancamentoRepository>(context);
    //lancamentos = context.watch<LancamentoRepository>();
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.filter_list),
              title: Text('Filtar por:'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Data'),
              //onTap: () => filtradata,
            ),
            OutlinedButton(
              onPressed: () => {
                context.read<AuthService>().logout(),
                lancamentos.cleanList(),
              },
              child: Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Lançamentos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            tooltip: 'Adicionar Lançamento',
            onPressed: () {
              _adicionarLancamento();
            },
          ),
        ],
      ),
      body: Consumer<LancamentoRepository>(
        builder: (context, lancamentos, child) {
          return ListView.builder(
            itemCount: lancamentos.lista.length,
            itemBuilder: (context, index) {
              //final Lancamento? obj = lancamentos.lista[index];
              return Card(
                child: InkWell(
                  onTap: () => mostrarDetalhes(lancamentos.lista[index]),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("images/icone.png")),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(lancamentos.lista[index].titulo,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20)),
                                Text(lancamentos.lista[index].data,
                                    style: TextStyle(fontSize: 15)),
                              ],
                            )),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 0.0), //80
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      real.format(
                                          lancamentos.lista[index].valor),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.lightGreen,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                      title: Text('Excluir Item'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Provider.of<LancamentoRepository>(
                                                context,
                                                listen: false)
                                            .remove(lancamentos.lista[index]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
