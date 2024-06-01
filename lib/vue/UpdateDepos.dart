import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';

class UpdateDeposOrange extends StatefulWidget {
  final OrangeModel depos;
  final Function(OrangeModel) onRowClicked;
  final List<OrangeModel> deposList;
   final Function() refreshData; // Ajout de la méthode refreshData
  

   UpdateDeposOrange({
    Key? key,
    required this.depos,
    required this.onRowClicked,
    required this.deposList,
    required this.refreshData, // Ajout de la méthode refreshData
  }) : super(key: key);

   // Constructeur par défaut optionnel
  UpdateDeposOrange.empty({Key? key})
      : depos = OrangeModel.empty(),
        onRowClicked = _emptyFunction,
        deposList = const [],
        refreshData = _emptyRefreshFunction, // Ajout de la méthode refreshData
        super(key: key);

  static void _emptyFunction(OrangeModel _) {} // Ajustement pour correspondre à la signature
  static void _emptyRefreshFunction() {} // Fonction vide sans arguments


  @override
  State<UpdateDeposOrange> createState() => _UpdateDeposOrangeState();
}

class _UpdateDeposOrangeState extends State<UpdateDeposOrange> {
  late OrangeController controller;
  late TextEditingController montantController;
  late TextEditingController numeroTelephoneController;
  late TextEditingController infoClientController;

  @override
  void initState() {
    super.initState();
    controller = OrangeController(widget.deposList);

    montantController = TextEditingController(text: widget.depos.montant);
    numeroTelephoneController = TextEditingController(text: widget.depos.numeroTelephone);
    infoClientController = TextEditingController(text: widget.depos.infoClient);
  }

  @override
  void dispose() {
    montantController.dispose();
    numeroTelephoneController.dispose();
    infoClientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier Dépôt Orange',
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
                TextFormField(
                  controller: montantController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Montant',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: numeroTelephoneController,
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
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: infoClientController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Informations Client',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    controller.pickImageCamera().then((_) {
                      setState(() {
                        infoClientController.text = controller.recognizedText;
                      });
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scanner',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
                        controller.updateDeposData(
                          depos: widget.depos,
                          montant: montantController.text,
                          numeroTelephone: numeroTelephoneController.text,
                          infoClient: infoClientController.text,
                        );
                        Navigator.of(context).pop(); // Fermer la page de mise à jour
                        widget.onRowClicked(widget.depos); // Actualiser la page d'historique
                      }
                    },
                  child: Text(
                    'Valider',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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