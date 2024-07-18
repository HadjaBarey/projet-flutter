import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';

class UpdateDeposOrange extends StatefulWidget {
  final OrangeModel depos;
  final Function(OrangeModel) onRowClicked;
  final List<OrangeModel> deposList;
  final Function() refreshData;

  const UpdateDeposOrange({
    Key? key,
    required this.depos,
    required this.onRowClicked,
    required this.deposList,
    required this.refreshData,
  }) : super(key: key);

  @override
  State<UpdateDeposOrange> createState() => _UpdateDeposOrangeState();
}

class _UpdateDeposOrangeState extends State<UpdateDeposOrange> {
  late OrangeController controller;
  

  @override
  void initState() {
    super.initState();
    controller = OrangeController(widget.deposList);

    // Initialisez les contrôleurs avec les valeurs de depos
    controller.montantController.text = widget.depos.montant;
    controller.numeroTelephoneController.text = widget.depos.numeroTelephone;
    controller.infoClientController.text = widget.depos.infoClient;
    controller.numeroIndependantController.text = widget.depos.numeroIndependant;
    // controller.scanMessageController.text = widget.depos.scanMessage;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modifier transfert Orange',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 150,
                  child: Image.asset('images/Depos.jpg'),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: controller.montantController,
                  decoration: const InputDecoration(
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
                  enabled: false,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.numeroTelephoneController,
                  decoration: const InputDecoration(
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
                  enabled: false,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.infoClientController,
                  decoration: const InputDecoration(
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
                  enabled: false,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.numeroIndependantController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro Independant',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    suffixIcon: Icon(Icons.contact_page),
                  ),
                  keyboardType: TextInputType.phone,
                  enabled: false,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Message:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 0),

                    Expanded(
                        child: TextFormField(
                          controller: controller.scanMessageController, // Utilisez directement le TextEditingController
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),                            
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: controller.scanMessageController.text.isEmpty ? Colors.red : Colors.black, // Utilisez le texte actuel du TextEditingController
                          ),
                          style: TextStyle(
                            color: controller.scanMessageController.text.isEmpty ? Colors.black : Colors.white, // Utilisez le texte actuel du TextEditingController
                          ),
                          enabled: false,
                        ),
                      ),
                      
                    SizedBox(width: 7),
                    Text(
                      'Crédit?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 0),
                    Checkbox(
                        value: controller.depos.optionCreance,
                        onChanged: (value) {
                          setState(() {
                            controller.updateOptionCreance(value ?? false);
                          });
                        },
                       // enabled: true, // Rend la case à cocher activable
                      ),                    
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    controller.setScan(1);
                    await controller.pickImageCamera(context);
                    setState(() {
                      controller.scanMessageController.text = controller.recognizedText2;
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
                      BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey.shade400),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      setState(() {
                        widget.depos.montant = controller.montantController.text;
                        widget.depos.numeroTelephone = controller.numeroTelephoneController.text;
                        widget.depos.infoClient = controller.infoClientController.text;
                        widget.depos.optionCreance = controller.depos.optionCreance;
                        widget.depos.scanMessage = controller.scanMessageController.text;
                        widget.depos.numeroIndependant = controller.numeroIndependantController.text;
                      });
                      controller.updateDeposData(
                        depos: widget.depos,
                        montant: controller.montantController.text,
                        numeroTelephone: controller.numeroTelephoneController.text,
                        infoClient: controller.infoClientController.text,
                        scanMessage: controller.scanMessageController.text,
                        numeroIndependant: controller.numeroIndependantController.text,
                        optionCreance: controller.depos.optionCreance,
                      );
                      widget.refreshData();
                      Navigator.of(context).pop();
                      widget.onRowClicked(widget.depos);
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
                  child: const Text(
                    'Valider',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
