import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/AutresOperation.dart';

class AutresPage extends StatefulWidget {
  const AutresPage({super.key});

  @override
  State<AutresPage> createState() => _AutresPageState();
}

class _AutresPageState extends State<AutresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0), // Ajustez la valeur de padding ici
          child: Column(
            children: [
              // const Text(
              //   '',
              //   style: TextStyle(
              //     fontSize: 25.0,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
             // const SizedBox(height: 5.0), // Ajustez la valeur de SizedBox ici
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AutreOperationPage()),
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
                            'images/AutresOperations.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Autres Opérations',
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
            ],
          ),
        ),
      ),
    );
  }
}