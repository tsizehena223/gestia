import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/budget_goal_adapter.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/service/transaction_adapter.dart';
import 'package:gestia/service/transaction_history_adapter.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/pages/accueil.dart';
import 'package:gestia/view/pages/home.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(TransactionAdapter())
    ..registerAdapter(BudgetGoalAdapter())
    ..registerAdapter(ColorAdapter())
    ..registerAdapter(TransactionHistoryAdapter());

  try {
    await Hive.openBox<Transaction>(TransactionService.boxName);
    await Hive.openBox<BudgetGoal>(BudgetGoalService.boxName);
    await Hive.openBox<TransactionHistory>(TransactionHistoryService.boxName);
  } catch (e) {
    print('Error opening boxes: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestIA App',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorLight: Colors.white,
        primaryColorDark: const Color.fromARGB(255, 255, 118, 55),
        disabledColor: const Color.fromARGB(255, 27, 27, 27),
        primaryColor: const Color.fromARGB(255, 231, 231, 231),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          IndexedStack(
            index: (_userName == null || _userBalance == null) ? 0 : 1,
            children: _pages,
          ),
        ],
      ),
    );
  }
}
