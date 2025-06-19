import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kadoustransfert/apiSprintBoot/rechercheGlobalHostinger.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:kadoustransfert/apiSprintBoot/rechercheGlobalSprintBoot.dart';
import 'package:kadoustransfert/vue/AutresPage.dart';
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
  int? _formatAbonnement;

  @override
  void initState() {
    super.initState();
    _loadFormatAbonnement();
  }

  void _loadFormatAbonnement() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _formatAbonnement = prefs.getInt('formatabonnement') ?? 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_formatAbonnement == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Liste dynamique des pages selon formatAbonnement
    final List<Widget> _pages = [
      _buildMainMenu(),                   // index 0 - Orange
      if (_formatAbonnement == 1 || _formatAbonnement == 2) MoovPage(),      // index 1
      if (_formatAbonnement == 2) AutresPage(),                              // index 2
      CaissePage(),                                                           // index 3
      Parametrage(),                                                          // index 4
    ];

    return WillPopScope(
      onWillPop: () {
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
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.ad_units_rounded),
              label: 'Orange',
            ),
            if (_formatAbonnement == 1 || _formatAbonnement == 2)
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: 'Moov',
              ),
            if (_formatAbonnement == 2)
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
        ),
      ),
    );
  }

  Widget _buildMainMenu() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
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

            _buildMenuItem(
              image: 'images/orangemoney.jpg',
              label: 'Orange Money',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeposOrangePage()),
              ),
            ),

            SizedBox(height: 40.0),

            _buildMenuItem(
              image: 'images/HNS.png',
              label: 'Opération à valider',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriqueNScannePage()),
              ),
            ),

            SizedBox(height: 40.0),

            _buildMenuItem(
              image: 'images/Historique.png',
              label: 'Historique',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriquePage()),
              ),
            ),

            SizedBox(height: 40.0),

            if (_formatAbonnement == 1 || _formatAbonnement == 2)
              _buildMenuItem(
                image: 'images/Recherche.png',
                label: 'Recherche Internet',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RechercheGlobal()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String image,
    required String label,
    required VoidCallback onTap,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: onTap,
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
                  image,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Text(
                  label,
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
    );
  }
}
