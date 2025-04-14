import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/CaisseController.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';

class PageDetailCaisse extends StatefulWidget {
  final CaisseController caisseController; // Ajout du controller dans le constructeur

  const PageDetailCaisse({Key? key, required this.caisseController}) : super(key: key);

  @override
  State<PageDetailCaisse> createState() => _PageDetailCaisseState();
}

class _PageDetailCaisseState extends State<PageDetailCaisse> {
  Future<List<JournalCaisseModel>>? _caisseDataFuture;

  @override
  void initState() {
     super.initState();
    _loadCaisseData(); // on déplace dans une fonction propre
  }

  void _loadCaisseData() async {
  await widget.caisseController.DateControleRecupere();
  // Vérification debug
  //print("📅 Date utilisée pour le filtre : ${widget.caisseController.dateJournalController.text}");
  setState(() {
    _caisseDataFuture = widget.caisseController.getAllCaisseData(widget.caisseController.dateJournalController);
  });
}


  // Méthode pour filtrer les données selon l'opérateur sélectionné
  Future<List<JournalCaisseModel>> _filterCaisseData(List<JournalCaisseModel> caisseData) async {
    if (widget.caisseController.operateurController.text.isEmpty ||
        widget.caisseController.operateurController.text == 'Tous') {
      return caisseData; // Si aucun opérateur n'est sélectionné, retournez toutes les données
    }
    return caisseData.where((item) => item.operateur == widget.caisseController.operateurController.text).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détail des transactions enregistrées',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Utilisation de ValueListenableBuilder pour le Dropdown opérateur
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: widget.caisseController.operateurOptionsNotifier,
              builder: (context, operateurOptions, _) {
                return DropdownButtonFormField<String>(
                  value: widget.caisseController.operateurController.text.isEmpty
                      ? null
                      : widget.caisseController.operateurController.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Opérateur',
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  items: operateurOptions.map((operateur) {
                    return DropdownMenuItem<String>(
                      value: operateur['value'],
                      child: Text(operateur['label']!),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      widget.caisseController.operateurController.text = newValue!;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<JournalCaisseModel>>(
              future: _caisseDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucune donnée trouvée.'));
                } else {
                  return FutureBuilder<List<JournalCaisseModel>>(
                    future: _filterCaisseData(snapshot.data!), // Appliquez le filtre ici
                    builder: (context, filteredSnapshot) {
                      if (!filteredSnapshot.hasData || filteredSnapshot.data!.isEmpty) {
                        return const Center(child: Text('Aucune donnée pour cet opérateur.'));
                      } else {
                        List<JournalCaisseModel> caisseData = filteredSnapshot.data!;
                        return ListView.builder(
                          itemCount: caisseData.length,
                          itemBuilder: (context, index) {
                            JournalCaisseModel item = caisseData[index];

                            // Logique pour afficher le typeCompte
                            String typeCompteText;
                            if (item.typeCompte == '1') {
                              typeCompteText = 'TRANSFERT';
                            } else if (item.typeCompte == '2') {
                              typeCompteText = 'CAISSE';
                            } else if (item.typeCompte == '3') {
                              typeCompteText = 'UNITÉ';
                            } else {
                              typeCompteText = '';
                            }

                            return Column(
                              children: [
                                FutureBuilder<String>(
                                  future: widget.caisseController.getLibOperateur(item.operateur),
                                  builder: (context, operateurSnapshot) {
                                    if (operateurSnapshot.connectionState == ConnectionState.waiting) {
                                      return const ListTile(
                                        title: Text('Chargement...'),
                                      );
                                    } else if (operateurSnapshot.hasError) {
                                      return ListTile(
                                        title: Text('Erreur : ${operateurSnapshot.error}'),
                                      );
                                    } else {
                                      String libelleOperateur = operateurSnapshot.data ?? 'Inconnu';
                                      return ListTile(
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Transaction ${index + 1}'),
                                            Text('Date : ${item.dateJournal}'),
                                            Text('Montant : ${item.montantJ}'),
                                            Text('Opérateur : $libelleOperateur'),
                                            Text('Type de compte : $typeCompteText'), // Affichage du typeCompte
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const Divider(), // Ajoute un trait pour séparer les transactions
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
