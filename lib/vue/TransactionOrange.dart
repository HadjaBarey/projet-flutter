import 'package:flutter/material.dart';

class TransactionOrange extends StatefulWidget {
  const TransactionOrange({Key? key}) : super(key: key);

  @override
  State<TransactionOrange> createState() => _TransactionOrangeState();
}

class _TransactionOrangeState extends State<TransactionOrange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retour en arrière
          },
        ),
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 500.0,
            height: 90.0,
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Center(
              child: Text(
                'KADOUS TRANSFERT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/orangemoney.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Contenu de la page
            SingleChildScrollView(
              child: Column(
                children: [
                  // Ajoutez votre contenu ici
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
