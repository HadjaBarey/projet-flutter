import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/CaisseController.dart';

class AddCaisssePage extends StatefulWidget {
  final CaisseController caisseController;

  const AddCaisssePage({required this.caisseController, Key? key}) : super(key: key);

  @override
  State<AddCaisssePage> createState() => _AddCaisssePageState();
}

class _AddCaisssePageState extends State<AddCaisssePage> {
  @override
  void initState() {
    super.initState();
    widget.caisseController.DateControleRecupere();
    print(widget.caisseController.dateJournalController.text); // Reset des champs du formulaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Caisse',
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
          key: widget.caisseController.formKey, // Assurez-vous que le formulaire a une clé
          child: Column(
            children: [
              Offstage(
                offstage: true,
                child: TextFormField(
                  controller: widget.caisseController.idjournalController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Opération',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Date Jour:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey,
                      ),
                      child: Offstage(
                        offstage: false,
                        child: TextFormField(
                          controller: widget.caisseController.dateJournalController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          enabled: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                children: [
                  Text(
                    'Solde Initial:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.redAccent,
                      ),
                      child: Offstage(
                        offstage: false,
                        child: TextFormField(
                          controller: widget.caisseController.montantJController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Erreur';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 379,
                        child: DropdownButtonFormField<String>(
                          value: widget.caisseController.selectedTypeCpt,
                          onChanged: (value) {
                            setState(() {
                              widget.caisseController.selectedTypeCpt = value!;
                            });
                          },
                          items: widget.caisseController.TypeComptes
                              .map<DropdownMenuItem<String>>(
                                (item) => DropdownMenuItem<String>(
                                  value: item['value'],
                                  child: Text(item['label']!),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Type Compte',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 379,
                        child: DropdownButtonFormField<String>(
                          value: widget.caisseController.selectedOperateur,
                          onChanged: (value) {
                            setState(() {
                              widget.caisseController.selectedOperateur = value!;
                            });
                          },
                          items: widget.caisseController.operateurOptions
                              .map<DropdownMenuItem<String>>(
                                (item) => DropdownMenuItem<String>(
                                  value: item['value'],
                                  child: Text(item['label']!),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Opérateur',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  if (widget.caisseController.formKey.currentState!.validate()) {
                    widget.caisseController.formKey.currentState!.save();
                    widget.caisseController.saveAddCaisseData().then((_) {
                      setState(() {
                        widget.caisseController.resetFormFields();
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
