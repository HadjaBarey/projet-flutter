import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart';
import 'package:kadoustransfert/vue/Entreprise.dart';
import 'package:kadoustransfert/vue/ListClient.dart';
import 'package:kadoustransfert/vue/ListOpTransaction.dart';


class Parametrage extends StatefulWidget {
  const Parametrage({Key? key}) : super(key: key);

  @override
  State<Parametrage> createState() => _ParametrageState();
}

class _ParametrageState extends State<Parametrage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const ClientPage()),
                      // );
                    },
                    child: Center(
                      child: Text(
                        'Utilisateur',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListeClientPage()),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Client',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageListOpTransaction(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Opération Transaction',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntreprisePage(
                            entrepriseController: EntrepriseController(),
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Entreprise',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
