import 'package:flutter/material.dart';

class MoovPage extends StatefulWidget {
  const MoovPage({super.key});

  @override
  State<MoovPage> createState() => _MoovPageState();
}

class _MoovPageState extends State<MoovPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Moov'),
      ),
    );
  }
}