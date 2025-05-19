import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/ClientController.dart';

class ClientPage extends StatefulWidget {
  final ClientController clientController;

  const ClientPage({required this.clientController, Key? key}) : super(key: key);

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {

  @override
  void initState() {
    super.initState();
    widget.clientController.resetFormFields(); // Reset des champs du formulaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter Client Prestige',
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
          key: widget.clientController.formKey,
          child: Column(
            children: [
              Offstage(
                offstage: false,
                child: TextFormField(
                  controller: widget.clientController.idClientController,
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
                controller: widget.clientController.identiteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Identité',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  widget.clientController.updateClient(identite: value);
                  return null;
                },
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: widget.clientController.numeroTelephoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numéro Téléphone',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.contact_page),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  widget.clientController.updateClient(numeroTelephone: value);
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                  onPressed: () {
                    widget.clientController.pickImageFromCameraOrGallery(context);
                    // clientController.pickImageFromCameraOrGallery(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scanner',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.scanner,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent),
                  ),
                ),

               SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (widget.clientController.formKey.currentState!.validate()) {
                    widget.clientController.formKey.currentState!.save();
                    widget.clientController.saveClientData().then((_) {
                      setState(() {
                        widget.clientController.resetFormFields();
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
