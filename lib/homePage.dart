import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/CaissePage.dart';
import 'package:kadoustransfert/vue/DeposOrange.dart';
import 'package:kadoustransfert/vue/Historique.dart';
import 'package:kadoustransfert/vue/HistoriqueNScanne.dart';
import 'package:kadoustransfert/vue/MoovPage.dart';
import 'package:kadoustransfert/vue/Parametrage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MoovPage(),
    CaissePage(),
    Parametrage(),
  ];

  //  @override
  // void initState() {
  //   super.initState();
  //   // Appeler la fonction de sauvegarde automatiquement lors du chargement de la page
  //  exportDataToLocalStorage();

  //   //exportDataToLocalStorage('/storage/emulated/0/Download/data_export.json');

  //    ///storage/emulated/0/Android/data/com.example.kadoustransfert/files/data_export.json



  //  // exportDataToLocalStorage('/chemin/vers/mon_fichier/data_export.json');


  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KADOUS TRANSFERT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0), // Adding padding to create space
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Orange Money',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // SizedBox(height: 5.0),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 20.0),
                  //   child: Text(
                  //     'Choisissez votre opérateur',
                  //     style: TextStyle(
                  //       fontSize: 25.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.blueAccent,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 13.0),
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeposOrangePage()),
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
                                'images/orangemoney.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Orange Money',
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => DeposOrangePage()),
                        // );
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
                                'images/Depos.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Unité',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoriqueNScannePage()),
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
                                'images/HistoriqueNV.jpg',
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
                          MaterialPageRoute(builder: (context) => HistoriquePage()),
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
                  SizedBox(height: 20.0),
                  // Adding WhatsApp and Phone icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.whatshot),
                        color: Colors.green,
                        iconSize: 30.0,
                        onPressed: () {
                          // Add logic for WhatsApp action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.phone),
                        color: Colors.blue,
                        iconSize: 30.0,
                        onPressed: () {
                          // Add logic for Phone action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          MoovPage(),
          CaissePage(),
          Parametrage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units_rounded),
            label: 'Orange',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Moov',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Caisse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_system_daydream),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
