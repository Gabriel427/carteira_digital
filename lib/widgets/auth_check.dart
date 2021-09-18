import 'package:carteira_digital/pages/lancamentos_page.dart';
import 'package:carteira_digital/pages/login_page.dart';
import 'package:carteira_digital/repositories/lancamentos_repository.dart';
import 'package:carteira_digital/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late LancamentoRepository lancamentos;
  @override
  Widget build(BuildContext context) {
    lancamentos = Provider.of<LancamentoRepository>(context);
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading)
      return loading();
    else if (auth.usuario == null)
      return LoginPage();
    else {
      lancamentos.readLancamentos();
      return LancamentosPage();
    }
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
