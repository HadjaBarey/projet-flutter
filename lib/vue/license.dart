import 'package:flutter/material.dart';


class LicenseExpiredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licence Expirée'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Votre licence a expiré.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Espacement entre le texte et le bouton
              ElevatedButton(
                onPressed: () {
                  // Revenir à la page précédente
                  Navigator.pop(context);
                },
                child: Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
