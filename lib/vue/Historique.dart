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
    loadData();
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
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment marquer cet élément comme supprimé ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _deposList[index].supprimer = 1;
                });
                Navigator.of(context).pop();
                refreshData(); // Actualiser les données après la suppression
              },
              child: Text('Supprimé'),
            ),
          ],
        );
      },
    );
  }

  void _handleRowClicked(OrangeModel clickedDepos) {
    print('Ligne cliquée : ${clickedDepos.montant}, ${clickedDepos.numeroTelephone}, ${clickedDepos.infoClient}');
  }

  @override
  Widget build(BuildContext context) {
    List<OrangeModel> filteredList = _deposList.where((depos) => depos.supprimer == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
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
                          deleteItem(index);
                        },
                        child: Icon(Icons.delete),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateDeposOrange(
                              depos: depos,
                              onRowClicked: _handleRowClicked,
                              deposList: _deposList,
                              refreshData: refreshData,
                            )),
                          ).then((_) => refreshData()); // Actualiser les données après la mise à jour
                        },
                        child: Icon(Icons.update),
                      ),
                    ],
                  ),
                  title: Text(
                    'Montant: ${depos.montant}',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Numéro de téléphone: ${depos.numeroTelephone}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Information client: ${depos.infoClient}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
