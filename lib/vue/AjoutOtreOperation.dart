import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart'; // Assurez-vous d'importer correctement EntrepriseController
import 'package:kadoustransfert/Controller/OrangeController.dart';

class AjoutOtreOperationPage extends StatefulWidget {
  const AjoutOtreOperationPage({Key? key}) : super(key: key);

  @override
  State<AjoutOtreOperationPage> createState() => _AjoutOtreOperationPageState();
}

class _AjoutOtreOperationPageState extends State<AjoutOtreOperationPage> {
  final OrangeController controller = OrangeController([]);
  final EntrepriseController entrepriseController = EntrepriseController(); // Création d'une instance de EntrepriseController
  bool isChecked = false; // Variable pour suivre l'état de la case à cocher

  @override
  void initState() {
    super.initState();
    entrepriseController.initializeBox().then((_) {});
    controller.initializeData().then((_) {
      controller.AutresOperationsController();
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Autres Opérations',
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
                  child: Image.asset('images/AO.png'),
                ),
                SizedBox(height: 5),

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
                    Text('Depos'),
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
                    Text('Retrait'),
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

                SizedBox(height: 0),

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

                SizedBox(height: 5),

            DropdownButtonFormField<String>(
                value: controller.operateurController.text.isNotEmpty ? controller.operateurController.text : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Opérateur',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                 // suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                onChanged: (newValue) {
                  setState(() {
                    // Mettre à jour le contrôleur avec la nouvelle valeur sélectionnée
                    controller.operateurController.text = newValue!;
                    controller.updateDepos(); // Assurez-vous que updateDepos gère bien la nouvelle valeur
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une option';
                  }
                  return null;
                },
                items: controller.operateurOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
              ),


              SizedBox(height: 10),

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

                SizedBox(height: 10),

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

                SizedBox(height: 10),

              
                TextFormField(
                  controller: controller.infoClientController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Informations Client',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur';
                    }
                    controller.updateDepos(infoClient: value);
                    return null;
                  },
                ),
                SizedBox(height: 10),

                  TextFormField(
                  controller: controller.idTransController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Transaction',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    controller.updateDepos(idTrans: value);
                    return null;
                  },
                ),   

                 SizedBox(height: 10),


                Offstage(
                    offstage: true, // Rendre le champ invisible
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

               
                SizedBox(height: 10),

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bouton avec le texte CNIB et l'icône
                      SizedBox(
                        width: 200, // Largeur calculée pour le bouton
                        height: 50, // Hauteur fixe pour le bouton
                        child: ElevatedButton(
                          onPressed: () {
                            controller.setScan(2);
                            controller.pickImageCamera(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CNIB',
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
                      ),

                      SizedBox(width: 16), // Espacement entre le bouton et le texte Crédit?

                      // Texte Crédit? et Checkbox
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Text(
                      //       'Crédit?',
                      //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      //     ),
                      //     SizedBox(width: 8),
                      //     Checkbox(
                      //       value: isChecked,
                      //       onChanged: (bool? value) {
                      //         setState(() {
                      //           isChecked = value ?? false;
                      //           controller.updateOptionCreance(isChecked);
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
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

                SizedBox(height: 10),

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
                    // Date de référence au format français
                    // String dateReference = "23/09/2024";
                    
                    // // Récupération de la date saisie dans dateOperationController.text
                    // String dateOperation = controller.dateOperationController.text;
                    
                    // // Comparaison directe des chaînes de caractères (jj/MM/yyyy)
                    // if (dateOperation.compareTo(dateReference) > 0) {
                    //   // Affichez un message d'erreur ou prenez une autre action si la date est invalide
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('Veuillez contacter votre fournisseur SVP!'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    //   return; // Arrêtez l'exécution du code ici si la condition n'est pas respectée
                    // }
                    
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
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
