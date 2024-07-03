import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';

class DeposOrangePage extends StatefulWidget {
  const DeposOrangePage({Key? key}) : super(key: key);

  @override
  State<DeposOrangePage> createState() => _DeposOrangePageState();
}

class _DeposOrangePageState extends State<DeposOrangePage> {
  final OrangeController controller = OrangeController([]);
  bool isChecked = false; // Variable pour suivre l'état de la case à cocher

  @override
  void initState() {
    super.initState();
    controller.initializeData().then((_) {
      setState(() {
        // Mettre à jour le texte du contrôleur infoClient
        controller.infoClientController.text = controller.depos.infoClient;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Depos Orange Monney',
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
                SizedBox(height: 25),
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
                  offstage: false, // Mettre à false si nécessaire
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
                SizedBox(height: 15),

              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Crédit?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            isChecked = value;
                            controller.updateOptionCreance(value);
                          });
                        }
                      },
                    ),
                  ],
                ),




                SizedBox(height: 15),

                Offstage(
                  offstage: true, // Mettre à false si nécessaire
                  child: TextFormField(
                    controller: controller.typeOperationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type Opération',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Erreur';
                      }
                      controller.updateDepos(typeOperation: int.tryParse(value));
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 15),
                Offstage(
                  offstage: true, // Mettre à false si nécessaire
                  child: TextFormField(
                    controller: controller.operateurController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Opérateur',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Erreur';
                      }
                      controller.updateDepos(operateur: value);
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                Offstage(
                  offstage: true, // Mettre à false si nécessaire
                  child: TextFormField(
                    controller: controller.supprimerController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supprimer',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Erreur';
                      }
                      controller.updateDepos(supprimer: int.tryParse(value));
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 15),
                Offstage(
                  offstage: true, // Mettre à false si nécessaire
                  child: TextFormField(
                    controller: controller.iddetteController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID Dette',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Erreur';
                      }
                      controller.updateDepos(iddette: int.tryParse(value));
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
             

                
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    controller.pickImageCamera();
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
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.requestCallPermission();
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
                    backgroundColor: MaterialStateProperty.all(Colors.black12),
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
