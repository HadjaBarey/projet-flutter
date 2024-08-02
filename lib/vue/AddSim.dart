import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/AddSimController.dart';


class PageAddSim extends StatefulWidget {
  final AddSimController SimController;

  const PageAddSim({required this.SimController, Key? key}) : super(key: key);

  @override
  State<PageAddSim> createState() => _PageAddSimState();
}

class _PageAddSimState extends State<PageAddSim> {

  @override
  void initState() {
    super.initState();
    widget.SimController.initializeBox().then((_) {
    widget.SimController.resetFormFields(); // Reset des champs du formulaire après l'initialisation
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter une Sim',
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
          key: widget.SimController.formKey,
          child: Column(
            children: [
              Offstage(
                offstage: false,
                child: TextFormField(
                  controller: widget.SimController.idOperateurController,
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
                controller: widget.SimController.CodeAgentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code Agent',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  widget.SimController.updateAddSim(CodeAgent: value);
                },
              ),


              SizedBox(height: 15),
              
              TextFormField(
                controller: widget.SimController.LibOperateurController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Operateur',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                  onChanged: (value) {
                  widget.SimController.updateAddSim(LibOperateur: value);
                }
              
              ),
              SizedBox(height: 15),

             TextFormField(
              controller: widget.SimController.NumPhoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Numéro Téléphone',
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                suffixIcon: Icon(Icons.contact_page),
              ),
              onChanged: (value) {
                widget.SimController.updateAddSim(NumPhone: value);
              },
              keyboardType: TextInputType.phone,
            ),


              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.SimController.formKey.currentState!.validate()) {
                    widget.SimController.formKey.currentState!.save();
                    widget.SimController.saveAddSimData().then((_) {
                      setState(() {
                        widget.SimController.resetFormFields();
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
