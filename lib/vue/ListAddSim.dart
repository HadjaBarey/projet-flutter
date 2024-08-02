import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/AddSimController.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/vue/AddSim.dart';

class PageListAddSim extends StatefulWidget {
  const PageListAddSim({Key? key}) : super(key: key);

  @override
  State<PageListAddSim> createState() => _PageListAddSimState();
}

class _PageListAddSimState extends State<PageListAddSim> {
  final AddSimController _controller = AddSimController();
  List<AddSimModel> _OperateursList = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initializeBox(); // Correction ici
    await loadData();
  }

  Future<void> loadData() async {
    List<AddSimModel> Operateurs = await _controller.loadData();
    setState(() {
      _OperateursList = Operateurs;
    });
    //print('Données chargées : $_OperateursList');
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
                try {
                  setState(() {
                    _OperateursList[index].supprimer = 1;
                  });

                  await _controller.markAsDeleted(_OperateursList[index]);
                  Navigator.of(context).pop();
                  await loadData();
                } catch (e) {
                  print("Erreur lors de la suppression : $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors de la suppression')),
                  );
                }
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _handleRowClicked(AddSimModel clickedOperateurs) {
    print('Ligne cliquée : ${clickedOperateurs.CodeAgent}, ${clickedOperateurs.LibOperateur}, ${clickedOperateurs.NumPhone}');
  }

  @override
  Widget build(BuildContext context) {
    List<AddSimModel> filteredList = _OperateursList.where((Sim) => Sim.supprimer == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Opérateurs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            AddSimModel Sim = filteredList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          int actualIndex = _OperateursList.indexWhere((item) => item.idOperateur == Sim.idOperateur);
                          deleteItem(actualIndex);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  title: Text(
                    'Opérateur: ${Sim.LibOperateur}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code Agent: ${Sim.CodeAgent}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'N° Téléphone: ${Sim.NumPhone}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  onTap: () {
                    _handleRowClicked(Sim);
                  },
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageAddSim(SimController: _controller)), // Naviguez vers la nouvelle page
          );
          if (result == true) {
            await loadData();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un client',
      ),
    );
  }
}
