import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart'; // Assurez-vous d'importer correctement EntrepriseController
import 'package:kadoustransfert/Controller/OrangeController.dart';

class UnitePage extends StatefulWidget {
  const UnitePage({Key? key}) : super(key: key);

  @override
  State<UnitePage> createState() => _UnitePageState();
}

class _UnitePageState extends State<UnitePage> {
  final OrangeController controller = OrangeController([]);
  final EntrepriseController entrepriseController = EntrepriseController(); // Création d'une instance de EntrepriseController
  bool isChecked = false; // Variable pour suivre l'état de la case à cocher

  @override
  void initState() {
    super.initState();
    entrepriseController.initializeBox().then((_) {});
    controller.initializeData().then((_) {
      controller.initializeOperateurController('Unité Orange');
      setState(() {});
    });

    // Initialize the operateurController with the ID of "Unité Orange"
    controller.initializeOperateurController("Unité Orange");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unité Orange',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 150,
                  child: Image.asset('images/Depos.jpg'),
                ),
                SizedBox(height: 15),

                // Section pour choisir l'option
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: controller.selectedOption,
                      onChanged: (value) {
                        setState(() {
                          controller.updateSelectedOption(value ?? 1);
                        });
                      },
                    ),
                    Text('Vente'),
                    SizedBox(width: 30),
                    Radio<int>(
                      value: 2,
                      groupValue: controller.selectedOption,
                      onChanged: (value) {
                        setState(() {
                          controller.updateSelectedOption(value ?? 2);
                        });
                      },
                    ),
                    Text('Achat'),
                  ],
                ),

                Offstage(
                  offstage: true, // Mettre à false si nécessaire
                  child: TextFormField(
                    controller: controller.idOperationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID Opération',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    enabled: false,
                  ),
                ),

                SizedBox(height: 15),

                Offstage(
                  offstage: true, // Mettre à false si nécessaire
                  child: TextFormField(
                    controller: controller.dateOperationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date Opération',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Erreur';
                      }
                      controller.updateDepos(dateoperation: value);
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 15),

                TextFormField(
                  controller: controller.montantController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Montant',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur';
                    }
                    controller.updateDepos(montant: value);
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 15),

                TextFormField(
                  controller: controller.numeroTelephoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro Téléphone',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    suffixIcon: Icon(Icons.contact_page),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur';
                    }
                    controller.updateDepos(numeroTelephone: value);
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    // Ajouter un listener onChanged pour vérifier la longueur du numéro de téléphone
                    if (value.length == 8) {
                      controller.updateInfoClientController();
                    }
                  },
                ),

                SizedBox(height: 15),

                Offstage(
                    offstage: false, // Rendre le champ invisible
                    child: TextFormField(
                      controller: controller.scanMessageController
                        ..text = 'Message Scanné', // Définir la valeur par défaut 
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Erreur';
                          }
                          controller.updateDepos(scanMessage: value);
                          return null;
                        },                     
                      enabled: false, // Champ désactivé
                    ),
                  ),

               
                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [               
                    Text(
                      'Crédit?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 0),
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          controller.updateOptionCreance(isChecked);
                        });
                      },
                    ),
                  ],
                ),

                Offstage(
                  offstage: true, // Mettez à true ou false selon votre logique pour afficher ou cacher le widget
                  child: TextFormField(
                    controller: controller.typeOperationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type Operation',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Erreur';
                      }
                      // Convertir la valeur en entier
                      int? intValue = int.tryParse(value);
                      if (intValue == null) {
                        return 'Veuillez entrer un entier valide';
                      }
                      controller.updateDepos(typeOperation: intValue); // Utiliser un cast explicite avec ! pour indiquer que intValue ne peut pas être nul
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 15),

                Offstage(
                  offstage: true, // Mettez à true ou false selon votre logique pour afficher ou cacher le widget
                  child:TextFormField(
                  controller: controller.operateurController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Opérateur',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur';
                    }
                    controller.updateDepos(operateur: value);
                    return null;
                  },
                  enabled: false,
                ),
                ),

                SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.saveData(context);
                      Navigator.pop(context, true); // Indiquer que l'opération a réussi
                    }
                  },
                  child: Text(
                    'Valider',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      ),
    );
  }
}
