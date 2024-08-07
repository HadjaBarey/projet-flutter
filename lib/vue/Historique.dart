import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';

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
  final TextEditingController _searchController = TextEditingController(); // Déclaration manquante
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialize();
    _searchController.addListener(() {
      loadData(); // Recharger les données lorsque la recherche change
    });
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
      print('Erreur pendant l\'initialisation : $e');
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

      String searchQuery = _searchController.text.toLowerCase(); // Convertir en minuscule pour la recherche insensible à la casse

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
            // Filtrage par numéro de téléphone
            if (searchQuery.isNotEmpty && !depos.numeroTelephone.toLowerCase().contains(searchQuery)) {
              return false;
            }

            return true;
          } catch (e) {
            print('Error parsing dateoperation: ${depos.dateoperation}, Error: $e');
            return false;
          }
        }).toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
    }
  }

  void deleteItem(OrangeModel depos) async {
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
                  final idoperation = depos.idoperation;
                  print('Suppression de l\'élément avec idoperation: $idoperation');

                  // Supprime l'élément de Hive en utilisant idoperation
                  await _controller.deleteDeposInHive(idoperation);

                 // Supprime l'élément de la liste
                  setState(() {
                    _deposList.removeWhere((item) => item.idoperation == idoperation);
                  });

                  Navigator.of(context).pop(); // Ferme la boîte de dialogue après la suppression
                } catch (e) {
                  print('Erreur lors de la suppression de l\'élément : $e');
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
    await _initialize();
  }

  void _handleRowClicked(OrangeModel clickedDepos) {
    print('Ligne cliquée : ${clickedDepos.montant}, ${clickedDepos.numeroTelephone}, ${clickedDepos.infoClient}, ${clickedDepos.typeOperation}, ${clickedDepos.operateur}');
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
    // } else if (depos.typeOperation == 1 && depos.operateur == '2') {
    //   return 'Opération: Dépôt Moov';
    // } else if (depos.typeOperation == 2 && depos.operateur == '2') {
    //   return 'Opération: Retrait Moov';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    List<OrangeModel> filteredList = _deposList
      .where((depos) => depos.supprimer == 0 && depos.operateur == '1' && depos.scanMessage == 'Message Scanné' && depos.optionCreance==false)
      .toList();

    // Trier la liste filtrée par ordre décroissant sur le champ idoperation
    filteredList.sort((a, b) => b.idoperation.compareTo(a.idoperation));

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
              const SizedBox(height: 10),

              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recherche',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.search), // Correction de l'icône
                ),
                keyboardType: TextInputType.text, // Correction du type de clavier
                enabled: true,
                onChanged: (value) {
                  setState(() {
                    // Recharger les données en filtrant selon le numéro de téléphone
                    loadData();
                  });
                },
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
                          key: ValueKey(depos.idoperation), // Utilisez une clé unique pour chaque élément
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => deleteItem(depos),
                                child: const Icon(Icons.delete),
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
