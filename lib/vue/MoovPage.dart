import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/HistoriqueMoov.dart';
import 'package:kadoustransfert/vue/HistoriqueMoovNScanne.dart';
import 'package:kadoustransfert/vue/TransactionMoov.dart';

class MoovPage extends StatefulWidget {
  const MoovPage({super.key});

  @override
  State<MoovPage> createState() => _MoovPageState();
}

class _MoovPageState extends State<MoovPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Moov Money'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0), // Ajustez la valeur de padding ici
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0), // Ajustez la valeur de padding ici
                child: Text(
                  'Moov Money',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 5.0), // Ajustez la valeur de SizedBox ici
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransactionMoovPage()),
                    );
                  },
                  child: Container(
                    width: 500.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90.0,
                          height: double.infinity,
                          child: Image.asset(
                            'images/moovmoney.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Moov Money',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.0),
              Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoriqueNScanMoovPage()),
                        );
                      },
                      child: Container(
                        width: 500.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90.0,
                              height: double.infinity,
                              child: Image.asset(
                                'images/HNS.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Opération à valider',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.0),

                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoriqueMoovPage()),
                        );
                      }
                      },
                      child: Container(
                        width: 500.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90.0,
                              height: double.infinity,
                              child: Image.asset(
                                'images/Historique.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Historique',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

            ],
          ),
        ),
      ),
    );
  }
}