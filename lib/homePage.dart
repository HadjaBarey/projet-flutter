import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/AddSim.dart';
import 'package:kadoustransfert/vue/Historique.dart';
import 'package:kadoustransfert/vue/Parametrage.dart';
import 'package:kadoustransfert/vue/TransactionOrange.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;
  
   void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    switch(index) {
      case 1:
        // Naviguer vers la page historique
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Historique()), // Remplacez HistoriquePage() par votre propre widget de page historique
        );
        break;
         case 2:
        // Naviguer vers la page Add Sim
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddSim()), // Remplacez HistoriquePage() par votre propre widget de page historique
        );
        break;
         case 3:
        // Naviguer vers la page parametre
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Parametrage()), // Remplacez HistoriquePage() par votre propre widget de page historique
        );
        break;
      // Ajoutez d'autres cas pour les autres éléments de la barre de navigation si nécessaire
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 500.0,
                height: 90.0,
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Center(
                  child: Text(
                    'KADOUS TRANSFERT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 13.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Orange Monney / Moov Monney',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Choisissez votre opérateur',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
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
                    MaterialPageRoute(builder: (context) => TransactionOrange()),
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
                          'Orange Monney',
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
                    MaterialPageRoute(builder: (context) => TransactionOrange()),
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
                          'images/moovmoney.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Moov Monney',
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units_rounded),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Ajouter Sim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_system_daydream),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        onTap: _onItemTapped,
      ),

    );
  }

}
