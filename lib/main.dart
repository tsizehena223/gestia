import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gestia/view/pages/accueil.dart';
import 'package:gestia/view/pages/home.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
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
  final int _pageIndex = 1;

  static final List<Widget> _pages = <Widget>[
    const Accueil(),
    const Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'Roboto'),
        child: IndexedStack(
          index: _pageIndex,
          children: _pages,
        ),
      ),
    );
  }
}