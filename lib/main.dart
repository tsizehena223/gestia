import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_adapter.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/pages/accueil.dart';
import 'package:gestia/view/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>(TransactionService.boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'GestIA App',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorLight: const Color(0xFFC6FE1E),
        primaryColorDark: const Color(0xFF1364FF),
        disabledColor: const Color(0xFF242425),
        primaryColor: const Color(0xFF0D0D0D),
        focusColor: const Color(0xFF868686),
        fontFamily: "Roboto",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _userName;
  int? _userBalance;

  static final List<Widget> _pages = <Widget>[
    const Accueil(),
    const Home(),
  ];

  Future<void> _retrieveUser() async {
    String? userName = await SharedPreferencesUtil.retrieveUserName();
    int? userBalance = await SharedPreferencesUtil.retrieveBalance();

    setState(() {
      _userName = userName;
      _userBalance = userBalance;
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: (_userName == null || _userBalance == null) ? 0 : 1,
        children: _pages,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}