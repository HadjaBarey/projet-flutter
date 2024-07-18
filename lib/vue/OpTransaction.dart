import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/OpTransactionController.dart';

class OpeTransactionPage extends StatefulWidget {
  final OpTransactionController OpeTransactionController;

  const OpeTransactionPage({required this.OpeTransactionController, Key? key}) : super(key: key);

  @override
  State<OpeTransactionPage> createState() => _OpeTransactionPageState();
}

class _OpeTransactionPageState extends State<OpeTransactionPage> {
  @override
  void initState() {
    super.initState();
    widget.OpeTransactionController.resetFormFields(); // Reset des champs du formulaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter une transaction',
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
          key: widget.OpeTransactionController.formKey,
          child: Column(
            children: [
              Offstage(
                offstage: true,
                child: TextFormField(
                  controller: widget.OpeTransactionController.idOpTransactionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Opération',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 15),
              
              TextFormField(
                controller: widget.OpeTransactionController.CodeTransactionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Transaction',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  widget.OpeTransactionController.updateOpTransaction(CodeTransaction: value);
                  return null;
                },
              ),

              SizedBox(height: 15),

              // DropdownButtonFormField pour l'opérateur
              DropdownButtonFormField<String>(
                value: widget.OpeTransactionController.selectedOperateur,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Opérateur',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                onChanged: (newValue) {
                  setState(() {
                    widget.OpeTransactionController.updateSelectedOperateur(newValue!);
                   
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une option';
                  }
                  return null;
                },
                items: widget.OpeTransactionController.operateurOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
              ),

              SizedBox(height: 15),

              // DropdownButtonFormField pour le type d'opération
              DropdownButtonFormField<String>(
                value: widget.OpeTransactionController.selectedTypeOpe,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type Opération',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                onChanged: (newValue) {
                  setState(() {
                    widget.OpeTransactionController.updateSelectedTypeOpe(newValue!);
           
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une option';
                  }
                  return null;
                },
                items: widget.OpeTransactionController.TypeOperationOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.OpeTransactionController.formKey.currentState!.validate()) {
                    widget.OpeTransactionController.formKey.currentState!.save();
                    widget.OpeTransactionController.saveOpTransactionData().then((_) {
                      setState(() {
                        widget.OpeTransactionController.resetFormFields();
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
                 style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.grey,
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
