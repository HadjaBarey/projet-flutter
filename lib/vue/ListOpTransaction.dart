import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/OpTransactionController.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/vue/OpTransaction.dart';

class PageListOpTransaction extends StatefulWidget {
  const PageListOpTransaction({Key? key}) : super(key: key);

  @override
  State<PageListOpTransaction> createState() => _PageListOpTransactionState();
}

class _PageListOpTransactionState extends State<PageListOpTransaction> {
  final OpTransactionController _controller = OpTransactionController();
  List<OpTransactionModel> _TransactionsList = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initializeBox();
    await loadData();
  }

  Future<void> loadData() async {
    List<OpTransactionModel> Transactions = await _controller.loadData();
    setState(() {
      _TransactionsList = Transactions;
    });
    //print('Données chargées : $_TransactionsList');
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
                    _TransactionsList[index].supprimer = 1;
                  });

                  await _controller.markAsDeleted(_TransactionsList[index]);
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

  void _handleRowClicked(OpTransactionModel clickedTransaction) {
    print('Ligne cliquée : ${clickedTransaction.CodeTransaction}, ${clickedTransaction.Operateur}, ${clickedTransaction.TypeOperation}');
  }

  @override
  Widget build(BuildContext context) {
    List<OpTransactionModel> filteredList = _TransactionsList.where((client) => client.supprimer == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            OpTransactionModel Transaction = filteredList[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          int actualIndex = _TransactionsList.indexWhere((item) => item.idOpTransaction == Transaction.idOpTransaction);
                          deleteItem(actualIndex);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  title: Text(
                    'Transaction: ${Transaction.CodeTransaction}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getOperationDescription(Transaction),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  onTap: () {
                    _handleRowClicked(Transaction);
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
            MaterialPageRoute(builder: (context) => OpeTransactionPage(OpeTransactionController: _controller)),
          );
          if (result == true) {
            await loadData();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une Transaction',
      ),
    );
  }

 String _getOperationDescription(OpTransactionModel transaction) {
  String operateurLabel = _controller.getOperateurLabel(transaction.Operateur);
  String typeOperationLabel = _controller.getTypeOperationLabel(transaction.TypeOperation);

  if (typeOperationLabel.isNotEmpty && operateurLabel.isNotEmpty) {
    return 'Opérateur: $operateurLabel / type Opération: $typeOperationLabel';
  }
  
  return 'na';
}


}
