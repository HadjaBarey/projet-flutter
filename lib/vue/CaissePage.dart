import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/CaisseController.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/vue/AddCaisse.dart';

class CaissePage extends StatefulWidget {
  const CaissePage({super.key});

  @override
  State<CaissePage> createState() => _CaissePageState();
}

class _CaissePageState extends State<CaissePage> {
  final CaisseController _controller = CaisseController();
  List<JournalCaisseModel> listCaiss=[];
  List<TableRow> buildTableRows() {
      return listCaiss.map((item) {
        return TableRow(
          children: [
            TableCell(
              child: Center(
                child: Text(item.typeCompte == '1' ? 'Transfert' : 'caisse'),
              ),
            ),
            // TableCell(
            //   child: Center(
            //     child: Text(item.operateur == '1' ? 'Orange' : 'Moov'),
            //   ),
            // ),
            TableCell(child: Center(child: Text(item.montantJ))),
            TableCell(child: Center(child: Text("---"))),
            TableCell(child: Center(child: Text("---"))),
            TableCell(child: Center(child: Text('---'))),
          ],
        );

      }).toList();
    }
  Future iniData() async{
    try{
      await _controller.loadData().then((value){
        setState(() {
          listCaiss = value;
        });
      });
      print("taille ${listCaiss.length}");
    }catch(e){
      print("ERREUR SUR LE LA RECUP DE LA LISTE $e");
    }
  }

@override
void initState() {
  super.initState();
  iniData();
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('caisse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(width: 1.0),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                TableCell(
                  child: Center(
                    child: Text('Compte'),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text('Solde Initial'),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text('Mvt Aug'),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text('Mvt Dimi'),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text('Solde Final'),
                  ),
                ),
              ],
            ),
            ...buildTableRows(),
            TableRow(
              children: [
                TableCell(
                  child: Center(
                    child: Text('Totaux'),
                  ),
                ),
                TableCell(child: Text('Cell 7')),
                TableCell(child: Text('Cell 8')),
                TableCell(child: Text('Cell 9')),
                TableCell(child: Text('Cell 10')),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCaisssePage(caisseController: _controller),
            ),
          );
          if (result == true) {
            setState(() {
              _controller.loadData();
            });
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un client',
      ),
    );
  }
}