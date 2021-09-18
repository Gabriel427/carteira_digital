import 'package:carteira_digital/pages/login_page.dart';
import 'package:carteira_digital/widgets/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Lançamentos',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green, backgroundColor: Colors.indigoAccent),
      home: AuthCheck(),
    );
  }
}
