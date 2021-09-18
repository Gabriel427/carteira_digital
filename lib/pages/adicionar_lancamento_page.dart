import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:carteira_digital/models/lancamento.dart';
import 'package:carteira_digital/repositories/lancamentos_repository.dart';
import 'package:carteira_digital/services/auth_service.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'documentos_page.dart';

class AdicionarLancamentoPage extends StatefulWidget {
  const AdicionarLancamentoPage({Key? key}) : super(key: key);

  @override
  _AdicionarLancamentoPageState createState() =>
      _AdicionarLancamentoPageState();
}

class _AdicionarLancamentoPageState extends State<AdicionarLancamentoPage> {
  final _form = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descricao = TextEditingController();
  final _valor = TextEditingController();
  final _dateCtl = TextEditingController();
  XFile? notaFiscal;

  late LancamentoRepository lancamentos;

  _adicionarRegistro() {
    if (_form.currentState!.validate()) {
      lancamentos.saveOne(Lancamento(
          id: Random().nextInt(100000000),
          titulo: _titulo.text,
          descricao: _descricao.text,
          imagem:
              notaFiscal != null ? notaFiscal!.path : '/images/img_padrao.png',
          categoria: dropdownValue,
          valor: double.parse(_valor.text),
          data: _dateCtl.text,
          uid: context.read<AuthService>().getUsuario()));
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lançamento adicionado!')));
    }
  }

  DateFormat dataFormato = new DateFormat('dd/MM/yyyy');
  String dropdownValue = 'Alimentação';
  @override
  Widget build(BuildContext context) {
    lancamentos = Provider.of<LancamentoRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Lançamento'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Card(
                  elevation: 8.0,
                  child: Form(
                    key: _form,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titulo,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Tí­tulo',
                              prefixIcon: Icon(Icons.my_library_add),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o titulo';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Alimentação',
                                'Compras',
                                'Carro',
                                'Farmácia',
                                'Viagem',
                                'Outro'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _descricao,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Descricao',
                              prefixIcon: Icon(Icons.my_library_add),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _valor,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Valor',
                              prefixIcon: Icon(Icons.monetization_on_outlined),
                              suffix: Text(
                                'reais',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              TextInputMask(
                                mask: '\$ !9+.99',
                                placeholder: '0',
                                maxPlaceHolders: 3,
                                reverse: true,
                              )
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o valor';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: _dateCtl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Data",
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                DateTime date = DateTime(1900);
                                date = (await showDatePicker(
                                        context: context,
                                        locale: Locale('pt'),
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2021),
                                        lastDate: DateTime(2030)) ??
                                    DateTime.now());
                                _dateCtl.text = dataFormato.format(date);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Informe uma data';
                                } else {
                                  return null;
                                }
                              }),
                          SizedBox(height: 10),
                          Material(
                            elevation: 5.0,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _tirarFoto(context);
                              },
                              label: Text(
                                'Tirar foto',
                                style: TextStyle(color: Colors.grey),
                              ),
                              icon: Icon(
                                Icons.photo_camera,
                                color: Colors.grey,
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                side: BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.attach_file),
                            title: Text('Adicionar foto da Galeria'),
                            onTap: selecionarNotaFical,
                            trailing: notaFiscal != null
                                ? Image.file(File(notaFiscal!.path))
                                : null,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.all(15.0),
                onPressed: _adicionarRegistro,
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      32.0,
                    ),
                    side: BorderSide(color: Colors.lightGreen)),
                child: Text(
                  "Adicionar",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  selecionarNotaFical() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => notaFiscal = file);
      if (file != null) {
        print(file.path);
      }
    } catch (e) {
      print(e);
    }
  }

  _tirarFoto(BuildContext context) async {
    XFile? file = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentosPage(),
        fullscreenDialog: true,
      ),
    );
    setState(() => notaFiscal = file);
  }
}
