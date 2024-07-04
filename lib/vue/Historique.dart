import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour le formatage des dates
import 'package:kadoustransfert/Controller/OrangeController.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/vue/UpdateDepos.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({Key? key}) : super(key: key);

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  final OrangeController _controller = OrangeController([]);
  List<OrangeModel> _deposList = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> refreshData() async {
    await _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initializeData();
    await _controller.DateControleRecupere(); // Appel de votre méthode pour récupérer les informations de contrôle de date
    String dateControle = _controller.dateOperationController.text; // Supposons que dateControle soit une propriété de votre OrangeController

    // Assurez-vous que dateControle est au format attendu 'dd/MM/yyyy'
    DateTime? parsedDate = DateFormat('dd/MM/yyyy').parse(dateControle, true); // Utilisation du paramètre strict pour valider strictement le format

    if (parsedDate != null) {
      _startDateController.text = DateFormat('dd/MM/yyyy').format(parsedDate); // Mise à jour de startDateController
      _endDateController.text = DateFormat('dd/MM/yyyy').format(parsedDate); // Mise à jour de endDateController
    }

    // Charger les données initiales avec les dates par défaut
    await loadData();
  }

  Future<void> loadData() async {
    List<OrangeModel> deposits = await _controller.loadData();

    // Convertir les dates de début et de fin au format attendu (par exemple 'dd/MM/yyyy')
    DateTime? startDate = _startDateController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(_startDateController.text)
        : null;
    DateTime? endDate = _endDateController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(_endDateController.text)
        : null;

    setState(() {
    _deposList = deposits.where((depos) {
      try {
        DateTime dateOperation = DateTime.parse(depos.dateoperation);
        if (startDate != null && dateOperation.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && dateOperation.isAfter(endDate)) {
          return false;
        }
        return true;
      } catch (e) {
       // print('Error parsing dateoperation: ${depos.dateoperation}, Error: $e');
        return false;
      }
    }).toList();
  });
}

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Voulez-vous vraiment marquer cet élément comme supprimé ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Marquer l'élément comme supprimé
                setState(() {
                  _deposList[index].supprimer = 1;
                });

                // Mettre à jour dans la base de données
                await _controller.markAsDeleted(_deposList[index]);

                // Fermer la boîte de dialogue
                Navigator.of(context).pop();

                // Rafraîchir les données
                await refreshData();
              },
              child: const Text('Supprimé'),
            ),
          ],
        );
      },
    );
  }

  void _handleRowClicked(OrangeModel clickedDepos) {
    print(
        'Ligne cliquée : ${clickedDepos.montant}, ${clickedDepos.numeroTelephone}, ${clickedDepos.infoClient}, ${clickedDepos.typeOperation}, ${clickedDepos.operateur}');
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      await loadData(); // Recharger les données après la sélection de la date
    }
  }

  @override
  Widget build(BuildContext context) {
    List<OrangeModel> filteredList = _deposList.where((depos) => depos.supprimer == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0, // Épaisseur de la bordure
                          ),
                        ),
                        labelText: 'Date de début',
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _startDateController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner une date de début';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0, // Épaisseur de la bordure
                          ),
                        ),
                        labelText: 'Date de fin',
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _endDateController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner une date de fin';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    OrangeModel depos = filteredList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  int actualIndex = _deposList.indexWhere((item) => item.idoperation == depos.idoperation);
                                  deleteItem(actualIndex);
                                },
                                child: const Icon(Icons.delete),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateDeposOrange(
                                        depos: depos,
                                        onRowClicked: _handleRowClicked,
                                        deposList: _deposList,
                                        refreshData: refreshData,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    await refreshData();
                                  }
                                },
                                child: const Icon(Icons.update),
                              ),
                            ],
                          ),
                          title: Text(
                            'Montant: ${depos.montant}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Numéro de téléphone: ${depos.numeroTelephone}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Information client: ${depos.infoClient}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                _getOperationDescription(depos),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getOperationDescription(OrangeModel depos) {
    if (depos.typeOperation == 1 && depos.operateur == '1') {
      return 'Opération: Dépôt Orange';
    } else if (depos.typeOperation == 2 && depos.operateur == '1') {
      return 'Opération: Retrait Orange';
    } else if (depos.typeOperation == 3 && depos.operateur == '1') {
      return 'Opération: Retrait sans compte Orange';
    } else if (depos.typeOperation == 4 && depos.operateur == '2') {
      return 'Opération: Dépôt Moov';
    } else if (depos.typeOperation == 5 && depos.operateur == '2') {
      return 'Opération: Retrait Moov';
    } else if (depos.typeOperation == 6 && depos.operateur == '2') {
      return 'Opération: Retrait sans compte Moov';
    }
    return '';
  }
}
