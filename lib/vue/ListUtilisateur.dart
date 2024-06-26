import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/UtilisateurController.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';
import 'package:kadoustransfert/vue/Utilisateur.dart';


class PageListeUtilisateur extends StatefulWidget {
  const PageListeUtilisateur({Key? key}) : super(key: key);

  @override
  State<PageListeUtilisateur> createState() => _PageListeUtilisateurState();
}

class _PageListeUtilisateurState extends State<PageListeUtilisateur> {
  final UtilisateurController _controller = UtilisateurController();
  List<UtilisateurModel> _UtilisateurList = [];

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
    List<UtilisateurModel> clients = await _controller.loadData();
    setState(() {
      _UtilisateurList = clients;
    });
    print('Données chargées : $_UtilisateurList');
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
                    _UtilisateurList[index].supprimer = 1;
                  });

                  await _controller.markAsDeleted(_UtilisateurList[index]);
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

  void _handleRowClicked(UtilisateurModel clickedUtilisateur) {
    print('Ligne cliquée : ${clickedUtilisateur.IdentiteUtilisateur}, ${clickedUtilisateur.RefCNIBUtilisateur}, ${clickedUtilisateur.NumPhoneUtilisateur}');
  }

  @override
  Widget build(BuildContext context) {
    List<UtilisateurModel> filteredList = _UtilisateurList.where((client) => client.supprimer == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Utilisateurs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            UtilisateurModel client = filteredList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          int actualIndex = _UtilisateurList.indexWhere((item) => item.idUtilisateur == client.idUtilisateur);
                          deleteItem(actualIndex);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  title: Text(
                    'Identité: ${client.IdentiteUtilisateur}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Numéro de téléphone: ${client.NumPhoneUtilisateur}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Ref CNIB: ${client.RefCNIBUtilisateur}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  onTap: () {
                    _handleRowClicked(client);
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
            MaterialPageRoute(builder: (context) => PageUtilisateur(utilisateurController: _controller)),

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