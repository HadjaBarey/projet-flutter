import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/DeposOrange.dart';

class TransactionOrange extends StatefulWidget {
  const TransactionOrange({Key? key}) : super(key: key);

  @override
  State<TransactionOrange> createState() => _TransactionOrangeState();
}

class _TransactionOrangeState extends State<TransactionOrange> {
  @override
  Widget build(BuildContext context) {
    // Calculer la largeur du texte
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'Orange Money',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double textWidth = textPainter.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retour en arrière
          },
        ),
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
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
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Stack(
          children: [
            // Image de fond
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'images/AccueilOrange.png',
                fit: BoxFit.fill,
              ),
            ),
            // Image en haut
            Positioned(
              top: 20.0,
              left: (MediaQuery.of(context).size.width - textWidth) / 2, // Centrer horizontalement
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Image.asset(
                  'images/OrangeMoney.jpeg',
                  width: 120,
                  height: 100,
                ),
              ),
            ),
            // Contenu de la page
            SingleChildScrollView(
              child: Column(
                children: [
                  // Texte centré
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Orange Money',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 120.0), // Espacement entre l'image et le premier container
                  // Container Orange Money
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeposOrangePage(),),
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
                                'images/Depos.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Depos',
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
                  SizedBox(height: 30.0), // Espacement entre les containers
                  // Container Moov Money
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        // Add onTap logic for Moov Money
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
                                'images/retraitorange.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Retrait',
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

                  SizedBox(height: 30.0), // Espacement entre les containers
                  // Container Moov Money
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        // Add onTap logic for Moov Money
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
                                'images/retraitgratuitorange.jpeg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Retrait sans compte',
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
          ],
        ),
      ),
    );
  }
}
