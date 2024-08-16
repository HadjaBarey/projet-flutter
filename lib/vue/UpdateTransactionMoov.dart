import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kadoustransfert/Controller/MoovController.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';

class UpdateMoov extends StatefulWidget {
  final OrangeModel depos;
  final Function(OrangeModel) onRowClicked;
  final List<OrangeModel> deposList;
  final Function() refreshData;

  const UpdateMoov({
    Key? key,
    required this.depos,
    required this.onRowClicked,
    required this.deposList,
    required this.refreshData,
  }) : super(key: key);

  @override
  State<UpdateMoov> createState() => _UpdateMoovState();
}

class _UpdateMoovState extends State<UpdateMoov> {
  late MoovController controller;

  @override
  void initState() {
    super.initState();
    controller = MoovController(widget.deposList);

    // Initialisez les contrôleurs avec les valeurs de depos
    controller.montantController.text = widget.depos.montant;
    controller.numeroTelephoneController.text = widget.depos.numeroTelephone;
    controller.infoClientController.text = widget.depos.infoClient;
    controller.numeroIndependantController.text = widget.depos.numeroIndependant;
    controller.scanMessageController.text = widget.depos.scanMessage;
    controller.optionCreanceController.value = widget.depos.optionCreance;

    // Imprimez les valeurs pour le débogage
    print("Initial idoperation: ${widget.depos.idoperation}");
  }



Future<void> _updateDepos() async {
  var box = await Hive.openBox<OrangeModel>('todobos');
 // print("Box opened: ${box.isOpen}");
  
  OrangeModel updatedDepos = OrangeModel(
    idoperation: widget.depos.idoperation,
    montant: controller.montantController.text,
    numeroTelephone: controller.numeroTelephoneController.text,
    infoClient: controller.infoClientController.text,
    optionCreance: controller.optionCreanceController.value,
    scanMessage: controller.scanMessageController.text,
    numeroIndependant: controller.numeroIndependantController.text,
    operateur: widget.depos.operateur,
    dateoperation: widget.depos.dateoperation,
    typeOperation: widget.depos.typeOperation,
    iddette: widget.depos.iddette,
    supprimer: widget.depos.supprimer,
    idTrans: widget.depos.idTrans,
  );

  var existingDeposKey = updatedDepos.idoperation;
  var existingDepos = box.get(existingDeposKey);
//  print("Existing deposit: ${existingDepos?.toJson()}");

  if (existingDepos != null) {
    await box.delete(existingDeposKey);
 //   print("Deleted deposit with id: ${existingDeposKey}");
  } else {
  //  print("Deposit with id: ${existingDeposKey} not found for deletion");
  }

  await box.put(existingDeposKey, updatedDepos);
 // print("Added/Updated deposit with id: ${existingDeposKey}");

  // Vérifiez les données mises à jour
  var updatedDeposFromHive = box.get(existingDeposKey);
 // print("Updated deposit from Hive: ${updatedDeposFromHive?.toJson()}");

  await box.close();
//  print("Box closed");
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
                    const Text(
                      'Message:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 0),
                    Expanded(
                      child: TextFormField(
                        controller: controller.scanMessageController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: controller.scanMessageController.text.isEmpty ? Colors.red : Colors.black,
                        ),
                        style: TextStyle(
                          color: controller.scanMessageController.text.isEmpty ? Colors.black : Colors.white,
                        ),
                        enabled: false,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Crédit?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 0),
                    Checkbox(
                      value: controller.optionCreanceController.value,
                      onChanged: (value) {
                        setState(() {
                          controller.updateOptionCreance(value ?? false);
                        });
                      },
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
                    children: const [
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                  ),
                ),
                const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (controller.formKey.currentState!.validate()) {
                      await _updateDepos();
                      widget.refreshData();
                      Navigator.pop(context);
                    } else {
                      print("Form validation failed.");
                    }
                  },
                  child: const Text(
                    'Modifier',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
