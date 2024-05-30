import 'package:flutter/material.dart';

class TransactionOrange extends StatefulWidget {
  const TransactionOrange({super.key});

  @override
  State<TransactionOrange> createState() => _TransactionOrangeState();
}

class _TransactionOrangeState extends State<TransactionOrange> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Orange Money'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retour en arrière
          },
        ),
      ), 
      body: SingleChildScrollView(
        child: Container(
          // Ajoutez votre contenu ici
        ),
      ),
    );
  }
}