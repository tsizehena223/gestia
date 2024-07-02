import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: const SingleChildScrollView(
          child: Center(
            child: Text(
              "Report",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
    );
  }
}