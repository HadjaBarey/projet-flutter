import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart'; // Assurez-vous d'importer correctement EntrepriseController
import 'package:kadoustransfert/Controller/MoovController.dart';

class TransactionMoovPage extends StatefulWidget {
  const TransactionMoovPage({Key? key}) : super(key: key);

  @override
  State<TransactionMoovPage> createState() => _TransactionMoovPageState();
}

class _TransactionMoovPageState extends State<TransactionMoovPage> {
  final MoovController controller = MoovController([]);
  final EntrepriseController entrepriseController = EntrepriseController(); // Création d'une instance de EntrepriseController
  bool isChecked = false; // Variable pour suivre l'état de la case à cocher

  @override
  void initState() {
    super.initState();
    entrepriseController.initializeBox().then((_) {
    });
   // optionSelect = controller.selectedOption;
    controller.initializeData().then((_) {
      setState(() {
        // Mettre à jour le texte du contrôleur infoClient
        controller.infoClientController.text = controller.depos.info_client;
      });
    });
  }

 Widget buildOption(String optionText) {
    return Text(optionText); // Créer un widget pour afficher l'option
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfert Moov Money',
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
                  child: Image.asset('images/FondMoov.png'),
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
                    Text('Depos'),

                    SizedBox(width: 20),

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

                    Radio<int>(
                    value: 3,
                    groupValue: controller.selectedOption,
                    onChanged: (value) {
                      setState(() {
                        controller.updateSelectedOption(value ?? 2);
                      });
                    },
                  ),
                    Text('Sans Compte'),
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
                SizedBox(height: 0),
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
                    if (value.length == 11 || value.length == 7 || value.length == 8) {
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
                  controller: controller.numeroIndependantController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro Indépendant',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    suffixIcon: Icon(Icons.contact_page),
                  ),
                  enabled: true, // Le champ est activé
                  onChanged: (value) {
                    controller.updateDepos(numeroIndependant: value);
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
                    // if (value == null || value.isEmpty) {
                    //   return 'Veuillez renseigner ce champ SVP!'; // Si le champ est vide
                    // } else if (value.length != 20 && value.length != 22) {
                    //   return 'L\'ID Transaction doit contenir 20 ou 22 caractères'; // Vérifie si la longueur est différente de 20 ou 22
                    // }
                    controller.updateDepos(idTrans: value);
                    return null; // Validation réussie
                  },
                ),


                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     // Ajout d'un SizedBox pour l'espacement
                 Text(
                      'Message:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(width: 0),

                   Expanded(
                      child: Container(
                        width: 150, // Définir la largeur souhaitée
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller.scanMessageController,
                          builder: (context, value, __) {
                            // Mettre à jour scanMessage
                          controller.updateDepos(scanMessage: value.text);

                            return TextFormField(
                                controller: controller.scanMessageController,
                                decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                fillColor: value.text.isEmpty ? Colors.red : Colors.black, // Change la couleur de fond
                                filled: true, // Active la couleur de fond
                              ),
                              style: TextStyle(
                                color: value.text.isEmpty ? Colors.red.shade100 : Colors.green.shade100, // Change la couleur du texte
                              ),
                              enabled: false, // Le champ est désactivé
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(width: 7),

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

                SizedBox(height: 10),

                LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonWidth = (constraints.maxWidth - 30) / 2;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: buttonWidth, // Largeur calculée pour le bouton
                          height: 50, // Hauteur fixe pour le bouton
                          child: ElevatedButton(
                            onPressed: ()async {
                              controller.setScan(1); // Définir la valeur de scan à 1
                              await controller.pickImageCamera(context).then((v){
                                setState(() {
                                 controller.selectedOption;
                                });
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Message',
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
                              backgroundColor: MaterialStateProperty.all(Colors.blueGrey.shade400),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: buttonWidth, // Largeur calculée pour le bouton
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
                      ],
                    );
                  },
                ),

                SizedBox(height: 10),

                ElevatedButton(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        // Vérification de l'existence de l'idTrans avant d'enregistrer les données
                        bool isUnique = await controller.VerificationIdTrans(context);
                        if (!context.mounted) return; // Assurez-vous que le contexte est encore valide après un await
                        // Si la vérification échoue, ne pas continuer
                        if (!isUnique) {
                          return; // Ajoutez ce return pour arrêter l'exécution si l'idTrans existe déjà
                        }                    
                        // Si la vérification passe, enregistrez les données
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
