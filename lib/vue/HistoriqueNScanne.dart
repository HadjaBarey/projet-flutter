import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/vue/UpdateDepos.dart';

class HistoriqueNScannePage extends StatefulWidget {
  const HistoriqueNScannePage({Key? key}) : super(key: key);

  @override
  State<HistoriqueNScannePage> createState() => _HistoriqueNScannePageState();
}

class _HistoriqueNScannePageState extends State<HistoriqueNScannePage> {
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

  Future<void> _initialize() async {
    try {
      await _controller.initializeData();

      // Récupération de la date de contrôle
      await _controller.DateControleRecupere();
      String dateControle = _controller.dateOperationController.text;

      // Formatage de la date
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      DateTime? parsedDate = formatter.parse(dateControle, true);

      if (parsedDate != null) {
        setState(() {
          _startDateController.text = formatter.format(parsedDate);
          _endDateController.text = formatter.format(parsedDate);
        });
      }

      await loadData();
    } catch (e) {
     // print('Erreur pendant l\'initialisation : $e');
    }
  }

  Future<void> loadData() async {
    try {
      List<OrangeModel> deposits = await _controller.loadData();

      DateTime? startDate = _startDateController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(_startDateController.text)
        : null;
    DateTime? endDate = _endDateController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(_endDateController.text)
        : null;

          setState(() {
    _deposList = deposits.where((depos) {
      try {
        DateTime dateOperation = DateFormat('dd/MM/yyyy').parse(depos.dateoperation);
        if (startDate != null && dateOperation.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && dateOperation.isAfter(endDate)) {
          return false;
        }
        return true;
      } catch (e) {
     //  print('Error parsing dateoperation: ${depos.dateoperation}, Error: $e');
        return false;
      }
    }).toList();
  });
    } catch (e) {
     // print('Erreur lors du chargement des données : $e');
     }
  }


  void deleteItem(int index) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cet élément ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Assurez-vous que l'idoperation est bien défini
                final idoperation = _deposList[index].idoperation;
               // print('Suppression de l\'élément avec idoperation: $idoperation');

                // Supprime l'élément de Hive en utilisant idoperation
                await _controller.deleteDeposInHive(idoperation);

                // Supprime l'élément de la liste
                setState(() {
                  _deposList.removeAt(index);
                });

                Navigator.of(context).pop(); // Ferme la boîte de dialogue après la suppression
              } catch (e) {
                //print('Erreur lors de la suppression de l\'élément : $e');
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      );
    },
  );
}


  Future<void> refreshData() async {
    try {
      await loadData();
    } catch (e) {
      print('Erreur lors du rafraîchissement des données : $e');
    }
  }

 // Dans votre méthode _handleRowClicked dans HistoriqueNScannePage

void _handleRowClicked(OrangeModel clickedDepos) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateDeposOrange(
        depos: clickedDepos,
        onRowClicked: (updatedDepos) async {
          await refreshData();
        },
        deposList: _deposList,
        refreshData: refreshData,
      ),
    ),
  );
}


  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale("fr", "FR"),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      await loadData();
    }
  }

  String _getOperationDescription(OrangeModel depos) {
    if (depos.typeOperation == 1 && depos.operateur == '1') {
      return 'Opération: Dépôt Orange';
    } else if (depos.typeOperation == 2 && depos.operateur == '1') {
      return 'Opération: Retrait Orange';
    } else if (depos.typeOperation == 4 && depos.operateur == '2') {
      return 'Opération: Dépôt Moov';
    } else if (depos.typeOperation == 3 && depos.operateur == '2') {
      return 'Opération: Retrait Moov';
    }  
    return '';
  }

  @override
  Widget build(BuildContext context) {
    List<OrangeModel> filteredList = _deposList
      .where((depos) => depos.operateur == '1' && depos.scanMessage == '')
      .toList();

    // Trier la liste filtrée par ordre décroissant sur le champ idoperation
    filteredList.sort((a, b) => b.idoperation.compareTo(a.idoperation));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique Non Scanné'),
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
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
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
                                onTap: () => deleteItem(index),
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
                                'Date Operation: ${depos.dateoperation}',
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
}
