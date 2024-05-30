import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300.0, // Ajustez la largeur du cadre selon vos besoins
          height: 100.0, // Ajustez la hauteur du cadre selon vos besoins
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AppBar(
              title: Text('KADOUS TRANSFERT'),
              centerTitle: true,
            ),
          ),
        ),
      ),
    );
  }
}