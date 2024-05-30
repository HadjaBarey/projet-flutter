import 'package:flutter/material.dart';

class Operation extends StatefulWidget {
  const Operation({Key? key}) : super(key: key);

  @override
  State<Operation> createState() => _OperationState();
}

class _OperationState extends State<Operation> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opération'),
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
