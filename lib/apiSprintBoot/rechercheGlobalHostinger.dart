import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';

class RechercheGlobal extends StatefulWidget {
  @override
  _RechercheGlobalState createState() => _RechercheGlobalState();
}

class _RechercheGlobalState extends State<RechercheGlobal> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<OrangeModel> _deposList = [];
  bool isLoading = false;

  Future<void> loadData() async {
    if (_searchController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _showAlertDialog(context, "Veuillez remplir toutes les informations");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      List<OrangeModel> fetchedData = await fetchDataFromApi(
        _searchController.text,
        _startDateController.text,
        _endDateController.text,
      );

      setState(() {
        _deposList = fetchedData;
      });
    } catch (e) {
      _showAlertDialog(
        context,
        e.toString().contains("connexion") || e.toString().contains("Socket")
            ? "📡 Aucune connexion Internet. Vérifiez votre réseau."
            : "❌ Une erreur est survenue : $e",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<OrangeModel>> fetchDataFromApi(
    String numeroTelephone,
    String dateDebutFr,
    String dateFinFr,
  ) async {
    try {
      // 🔁 Conversion format date jj/mm/yyyy -> yyyy-mm-dd
      String convertirDatePourMySQL(String dateFr) {
        final parts = dateFr.split('/');
        if (parts.length == 3) {
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
        return dateFr; // fallback
      }

      String dateDebut = convertirDatePourMySQL(dateDebutFr);
      String dateFin = convertirDatePourMySQL(dateFinFr);

      final url = Uri.parse('https://kadoussconnect.com/transfertflutter/backend/listRechercher.php'); // 🔄 Remplace par ton vrai lien

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_telephone': numeroTelephone,
          'datedebut': dateDebut,
          'datefin': dateFin,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true && result['data'] != null) {
          List<dynamic> data = result['data'];
          return data.map((item) => OrangeModel.fromJSON(item)).toList();
        }
      }

      print('Erreur API: ${response.statusCode} - ${response.body}');
      return [];
    } on SocketException {
      throw Exception("Pas de connexion Internet");
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text("Attention"),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recherche Globale")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Téléphone',
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) async => await loadData(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date de début',
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _startDateController),
                      validator: (value) => value!.isEmpty ? 'Date requise' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date de fin',
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _endDateController),
                      validator: (value) => value!.isEmpty ? 'Date requise' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                    itemCount: _deposList.length,
                    itemBuilder: (context, index) {
                      final depos = _deposList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            key: ValueKey(depos.idoperation),
                            title: Text('Montant: ${depos.montant}', style: TextStyle(fontSize: 18)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Téléphone: ${depos.numero_telephone}', style: TextStyle(fontSize: 14)),
                                Text('Client: ${depos.info_client}', style: TextStyle(fontSize: 14)),
                                Text('Date: ${depos.dateoperation}', style: TextStyle(fontSize: 14)),
                                Text(
                                  'Type: ${depos.typeoperation == 1 ? 'Dépôt' : depos.typeoperation == 2 ? 'Retrait' : 'Inconnu'}',
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
            ],
          ),
        ),
      ),
    );
  }
}

