import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/UtilisateurController.dart';

class PageUtilisateur extends StatefulWidget {
  final UtilisateurController utilisateurController;

  const PageUtilisateur({required this.utilisateurController, Key? key}) : super(key: key);

  @override
  State<PageUtilisateur> createState() => _PageUtilisateurState();
}

class _PageUtilisateurState extends State<PageUtilisateur> {
  @override
  void initState() {
    super.initState();
    widget.utilisateurController.resetFormFields(); // Reset des champs du formulaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter utilisateur',
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
          key: widget.utilisateurController.formKey,
          child: Column(
            children: [
              Offstage(
                offstage: false,
                child: TextFormField(
                  controller: widget.utilisateurController.idUtilisateurController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Utilisateur',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  enabled: false,
                ),
              ),

              const SizedBox(height: 15),
              
              TextFormField(
                controller: widget.utilisateurController.IdentiteUtilisateurController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Identité',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  widget.utilisateurController.updateUtilisateur(IdentiteUtilisateur: value);
                  return null;
                },
              ),

              const SizedBox(height: 15),
              
              TextFormField(
                controller: widget.utilisateurController.RefCNIBUtilisateurController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Réf CNIB',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  widget.utilisateurController.updateUtilisateur(RefCNIBUtilisateur: value);
                  return null;
                },
              ),
              
              const SizedBox(height: 15),

              TextFormField(
                controller: widget.utilisateurController.NumPhoneUtilisateurController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numéro Téléphone',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.contact_page),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  widget.utilisateurController.updateUtilisateur(NumPhoneUtilisateur: value);
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.utilisateurController.formKey.currentState!.validate()) {
                    widget.utilisateurController.formKey.currentState!.save();
                    widget.utilisateurController.saveUtilisateurData().then((_) {
                      setState(() {
                        widget.utilisateurController.resetFormFields();
                      });
                      Navigator.pop(context, true); // Fermer la page avec un résultat vrai
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
