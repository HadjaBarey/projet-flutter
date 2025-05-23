import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kadoustransfert/apiSprintBoot/rechercheGlobalSprintBoot.dart';
import 'package:kadoustransfert/vue/AutresPage.dart';
import 'package:kadoustransfert/vue/CaissePage.dart';
import 'package:kadoustransfert/vue/DeposOrange.dart';
import 'package:kadoustransfert/vue/Historique.dart';
import 'package:kadoustransfert/vue/HistoriqueNScanne.dart';
import 'package:kadoustransfert/vue/MoovPage.dart';
import 'package:kadoustransfert/vue/Parametrage.dart';
import 'package:kadoustransfert/vue/UnitePage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MoovPage(),
    AutresPage(),
    CaissePage(),
    Parametrage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        exit(0);
      },
      child: Scaffold(
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
      
                    // Align(
                    //   alignment: Alignment.topCenter,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => UnitePage()),
                    //       );
                    //     },
                    //     child: Container(
                    //       width: 500.0,
                    //       height: 90.0,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(20.0),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.5),
                    //             spreadRadius: 5,
                    //             blurRadius: 7,
                    //             offset: Offset(0, 3),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Container(
                    //             width: 90.0,
                    //             height: double.infinity,
                    //             child: Image.asset(
                    //               'images/Depos.jpg',
                    //               fit: BoxFit.fill,
                    //             ),
                    //           ),
                    //           Expanded(
                    //             child: Text(
                    //               'Unité',
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 27.0,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.arrow_forward_ios_rounded,
                    //             color: Colors.black,
                    //             size: 30.0,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
      
                    //  SizedBox(height: 40.0),
      
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
                   
                    SizedBox(height: 40.0),
      
                    Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RechercheGlobal()),
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
                                  'images/Recherche.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Recherche Internet',
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
            MoovPage(),
            AutresPage(),
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
              icon: Icon(Icons.ads_click),
              label: 'Autres',
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
      ),
    );
  }
}




