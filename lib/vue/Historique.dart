import 'package:flutter/material.dart';
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
    await loadData();
  }

  Future<void> loadData() async {
    List<OrangeModel> deposits = await _controller.loadData();
    setState(() {
      _deposList = deposits;
    });
  }

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment marquer cet élément comme supprimé ?'),
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
    print('Ligne cliquée : ${clickedDepos.montant}, ${clickedDepos.numeroTelephone}, ${clickedDepos.infoClient}, ${clickedDepos.typeOperation}, ${clickedDepos.operateur}');
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
