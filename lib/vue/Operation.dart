import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/TransactionOrange.dart';

class Operation extends StatefulWidget {
  const Operation({Key? key}) : super(key: key);

  @override
  State<Operation> createState() => _OperationState();
}

class _OperationState extends State<Operation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Orange Money / Moov Money',
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
                          'Moov Money',
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
      
    );
  }
}
