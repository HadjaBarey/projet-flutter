import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/vue/AjoutOtreOperation.dart';


class AutreOperationPage extends StatefulWidget {
  const AutreOperationPage({Key? key}) : super(key: key);

  @override
  State<AutreOperationPage> createState() => _AutreOperationPageState();
}

class _AutreOperationPageState extends State<AutreOperationPage> {
  final OrangeController _controller = OrangeController([]);
  List<OrangeModel> _deposList = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialize();
    _searchController.addListener(() {
      loadData();
    });
  }


  Future<String> getLibOperateur(String operateur) async {
  // Ouvrir la boîte Hive
  var addSimBox = await Hive.openBox<AddSimModel>('todobos5');

  // Déboguer le contenu de la boîte pour s'assurer qu'elle contient des données
  //print('Contenu de addSimBox: ${addSimBox.values.toList()}');

  // Rechercher le modèle correspondant
  AddSimModel? correspondingAddSimModel = addSimBox.values.firstWhere(
    (addSim) => addSim.idOperateur.toString() == operateur,
    orElse:  () => AddSimModel(
          idOperateur: 0,
          LibOperateur: '',
          NumPhone: '',
          CodeAgent: '',
          supprimer: 0,
        ), // Retourner null si aucune correspondance n'est trouvée
  );

  // Déboguer le résultat de la recherche
  if (correspondingAddSimModel != null) {
    //print('Modèle trouvé: ${correspondingAddSimModel.LibOperateur}');
  } else {
   // print('Aucun modèle trouvé pour l\'opérateur $operateur');
  }

  // Retourner le libellé ou 'Caisse' si aucune correspondance n'est trouvée
  return correspondingAddSimModel?.LibOperateur.isNotEmpty == true
      ? correspondingAddSimModel.LibOperateur
      : '0';
}



  Future<void> _initialize() async {
    try {
      await _controller.initializeData();

      await _controller.DateControleRecupere();
      String dateControle = _controller.dateOperationController.text;

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

      String searchQuery = _searchController.text.toLowerCase();

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
                 final idoperation = depos.idoperation;
                  print('Suppression de l\'élément avec idoperation: $idoperation');

                  await _controller.deleteDeposInHive(idoperation);

                    setState(() {
                    _deposList.removeWhere((item) => item.idoperation == idoperation);
                  });


                  Navigator.of(context).pop();
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
    if (depos.typeOperation == 1 && depos.operateur != '1' && depos.operateur != '2') {
      return 'Transaction: Dépôt';
    } else if (depos.typeOperation == 2 && depos.operateur != '1' && depos.operateur != '2') {
      return 'Transaction: Retrait';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<OrangeModel> filteredList = _deposList
        .where((depos) => depos.supprimer == 0 &&
                          depos.operateur != '1' &&
                          depos.operateur != '2' && 
                          depos.scanMessage == 'Message Scanné' && 
                          depos.optionCreance==false)
        .toList();

    filteredList.sort((a, b) => b.idoperation.compareTo(a.idoperation));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique autres opérations'),
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
                  suffixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.text,
                enabled: true,
                onChanged: (value) {
                  setState(() {
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
                          key: ValueKey(depos.idoperation),
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
                            style: const TextStyle(fontSize: 16),
                          ),
                          
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                'Info Client: ${depos.infoClient}',
                                style: const TextStyle(fontSize: 14),
                              ), 
                              Text(
                                'Numéro de téléphone: ${depos.numeroTelephone}',
                                style: const TextStyle(fontSize: 14),
                              ),                          
                              Text(
                                _getOperationDescription(depos),
                                style: const TextStyle(fontSize: 14),
                              ),

                              FutureBuilder<String>(
                                future: getLibOperateur(depos.operateur),
                                builder: (context, snapshot) {
                                  String libelle = snapshot.connectionState == ConnectionState.waiting
                                      ? 'Chargement...'
                                      : snapshot.data ?? '';

                                  return Text(
                                    'Opérateur: $libelle',
                                    style: const TextStyle(fontSize: 14),
                                  );
                                },
                              ),
                              
                            ],
                          ),
                          onTap: () => _handleRowClicked(depos),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AjoutOtreOperationPage()),
                  );
                },
                  child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
