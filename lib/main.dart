import 'package:carteira_digital/repositories/lancamentos_repository.dart';
import 'package:carteira_digital/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carteira_digital/my_app.dart';
import 'package:provider/provider.dart';
import 'configs/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => LancamentoRepository(
            auth: context.read<AuthService>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
