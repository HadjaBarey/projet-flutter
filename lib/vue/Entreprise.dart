import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart';

class EntreprisePage extends StatefulWidget {
  final EntrepriseController entrepriseController;

  const EntreprisePage({required this.entrepriseController, Key? key}) : super(key: key);

  @override
  State<EntreprisePage> createState() => _EntreprisePageState();
}

class _EntreprisePageState extends State<EntreprisePage> {
  late EntrepriseController entrepriseController;

  @override
  void initState() {
    super.initState();
    entrepriseController = widget.entrepriseController;
    entrepriseController.resetFormFields();
  }

  // Méthode pour incrémenter la date
  void incrementDate() {
    if (entrepriseController.DateControleController.text.isEmpty) {
      entrepriseController.DateControleController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    } else {
      DateTime currentDate = DateFormat('dd/MM/yyyy').parse(entrepriseController.DateControleController.text);
      DateTime nextDate = currentDate.add(Duration(days: 1));
      entrepriseController.DateControleController.text = DateFormat('dd/MM/yyyy').format(nextDate);
    }
    entrepriseController.updateEntreprise(DateControle: entrepriseController.DateControleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Information de la boutique',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: entrepriseController.formKey,
          child: Column(
            children: [
              Offstage(
                offstage: false,
                child: TextFormField(
                  controller: entrepriseController.idEntrepriseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Entreprise',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 15),
              
              TextFormField(
                controller: entrepriseController.NomEntrepriseController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom de l\'entreprise',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  entrepriseController.updateEntreprise(NomEntreprise: value);
                  return null;
                },
              ),
              SizedBox(height: 15),
              
              TextFormField(
                controller: entrepriseController.DirecteurEntrepriseController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom du directeur',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  entrepriseController.updateEntreprise(DirecteurEntreprise: value);
                  return null;
                },
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: entrepriseController.DateControleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date du jour',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  return null;
                },
                readOnly: true, // Empêche la modification directe du champ de texte
              ),

              SizedBox(height: 20),
              
              // Ajout du bouton pour incrémenter la date
              ElevatedButton(
                onPressed: incrementDate,
                child: const Text('Incrémenter la date'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (entrepriseController.formKey.currentState!.validate()) {
                    entrepriseController.formKey.currentState!.save();
                    entrepriseController.saveEntrepriseData().then((_) {
                      setState(() {
                        entrepriseController.resetFormFields();
                      });
                      // Navigator.pop(context, true); // Ferme la page avec un résultat vrai
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erreur lors de l\'enregistrement')),
                      );
                    });
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
