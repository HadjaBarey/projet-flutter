import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/ClientController.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/vue/Client.dart'; // Importez votre nouvelle page ici

class ListeClientPage extends StatefulWidget {
  const ListeClientPage({Key? key}) : super(key: key);

  @override
  State<ListeClientPage> createState() => _ListeClientPageState();
}

class _ListeClientPageState extends State<ListeClientPage> {
  final ClientController _controller = ClientController();
  List<ClientModel> _clientList = [];

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
    List<ClientModel> clients = await _controller.loadData();
    setState(() {
      _clientList = clients;
    });
    print('Données chargées : $_clientList');
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
                    _clientList[index].supprimer = 1;
                  });

                  await _controller.markAsDeleted(_clientList[index]);
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

  void _handleRowClicked(ClientModel clickedClient) {
    print('Ligne cliquée : ${clickedClient.Identite}, ${clickedClient.RefCNIB}, ${clickedClient.numeroTelephone}');
  }

  @override
  Widget build(BuildContext context) {
    List<ClientModel> filteredList = _clientList.where((client) => client.supprimer == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Clients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            ClientModel client = filteredList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          int actualIndex = _clientList.indexWhere((item) => item.idClient == client.idClient);
                          deleteItem(actualIndex);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  title: Text(
                    'Identité: ${client.Identite}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Numéro de téléphone: ${client.numeroTelephone}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Ref CNIB: ${client.RefCNIB}',
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
            MaterialPageRoute(builder: (context) => ClientPage(clientController: _controller)), // Naviguez vers la nouvelle page
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
