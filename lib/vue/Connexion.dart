import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kadoustransfert/auth/auth.dart';
import 'package:kadoustransfert/homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool auth = false;
  DateTime? madate;
  bool logi = false;
  DateTime today = DateTime.now();
  
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    try {
      _verif().then((_) {
        if (mounted) {
          _verification();
        }
      });
    } catch(e) {
      print("pas de boot");
    }
  }

  Future<void> _verification() async {
    if (!mounted) return;  // Vérification ajoutée pour éviter des problèmes si widget est démonté
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String? savedDate = prefs.getString('date_fin');
      madate = savedDate != null ? DateTime.tryParse(savedDate) : null;

      if (mounted) {
        setState(() {
          auth = prefs.getBool("auth") ?? false;
        });
      }

      if (madate == null || madate!.isBefore(DateTime.now())) {
        print("Licence expirée ou inexistante.");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Votre licence a expiré ou est inexistante. Veuillez la renouveler.'),
            ),
          );
        }
      } else {
        if (auth && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e, stacktrace) {
      print("Erreur dans la vérification de la licence : $e");
      print("Trace : $stacktrace");
    }
  }

  Future<void> _verif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Récupération de la valeur sauvegardée
      String? madatasave = prefs.getString("password");

      if (madatasave != null && madatasave.isNotEmpty && mounted) {
        // Appel de la méthode si la valeur est valide
        verifAndprolonge(madatasave);
      } else {
        print("Aucune donnée sauvegardée pour 'password'.");
      }
    } catch (e, stacktrace) {
      // Gestion des erreurs et log des détails
      print("Erreur lors de la récupération des données : $e");
      print("Trace : $stacktrace");
    }
  }

  Future<void> verifAndprolonge(String password) async {
    if (!mounted) return;  // Vérification ajoutée pour éviter des problèmes si widget est démonté
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (mounted) {
        setState(() {
          logi = true; // Affiche un chargement
        });
      }

      // Appeler l'authentification avec le mot de passe
      final response = await AuthKTransfert.authBypass({"password": password});

      if (!mounted) return;  // Vérification après l'opération asynchrone

      if (response.containsKey('date_fin')) {
        DateTime today = DateTime.now();
        DateTime newExpiryDate = DateTime.parse(response['date_fin']);

        if (newExpiryDate.isAfter(today)) {
          // La licence est valide
          prefs.setBool('auth', true);
          prefs.setString('password', password);
          prefs.setString('date_fin', newExpiryDate.toIso8601String());
          print("Licence valide jusqu'à $newExpiryDate");

          if (mounted) {  // Vérification avant d'utiliser context
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Licence prolongée jusqu\'au $newExpiryDate.')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } else {
          // Licence expirée
          prefs.setBool('auth', false);
          print("La licence a expiré. Veuillez renouveler.");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Licence expirée. Veuillez la renouveler.')),
            );
          }
        }
      } else if (response.containsKey('error')) {
        // Erreur côté serveur ou mot de passe invalide
        print("Erreur du serveur : ${response['error']}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur du serveur : ${response['error']}')),
          );
        }
      } else {
        // Réponse inattendue
        print("Mot de passe invalide ou réponse inconnue du serveur.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mot de passe invalide ou licence expirée.')),
          );
        }
      }
    } catch (e) {
      // Gestion des erreurs réseau ou autres
      print("Erreur de connexion : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          logi = false; // Masque le chargement
        });
      }
    }
  }

  // Connexion avec validation du mot de passe
  Future<void> connectmyUser() async {
    if (!mounted) return;  // Vérification ajoutée
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (mounted) {
        setState(() {
          logi = true; // Affiche un chargement
        });
      }

      final response = await AuthKTransfert.authBypass({"password": _passwordController.text});
      
      if (!mounted) return;  // Vérification après l'opération asynchrone

      if (response['response'] == "true") {
        DateTime newExpiryDate = DateTime.parse(response['date_fin']);
        prefs.setBool('auth', true);
        prefs.setString('password', _passwordController.text);
        prefs.setString('date_fin', newExpiryDate.toString());
        print(newExpiryDate.toString());
        
        DateTime today = DateTime.now();
        if (today.isAfter(newExpiryDate)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Mot de-passe incorrect ou licence expirée.')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Connexion réussie.')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        }
      } else {
        if (mounted) {
          verifAndprolonge(_passwordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mot de-passe incorrect ou licence expirée.')),
          );
        }
      }
    } catch (e) {
      print("Erreur dans la connexion : $e");
    } finally {
      if (mounted) {
        setState(() {
          logi = false; // Masque le chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LICENCE KADOUS TRANSFERT'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: logi
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Veuillez entrer votre licence',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: connectmyUser,
                      child: Text('Se connecter'),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Veuillez contacter le +226 70808881/77917802 pour acquérir une licence !',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:kadoustransfert/auth/auth.dart';
// import 'package:kadoustransfert/homePage.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _passwordController = TextEditingController();
//   bool auth = false;
//   DateTime? madate;
//   bool logi = false;
//   DateTime today = DateTime.now();
//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     try{
//       _verif().then((_){
//       _verification();
//       });
//     }catch(e){
//       print("pas de boot");
//     }
//   }


// Future<void> _verification() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   try {
//     String? savedDate = prefs.getString('date_fin');
//     madate = savedDate != null ? DateTime.tryParse(savedDate) : null;

//     if (mounted) {
//       setState(() {
//         auth = prefs.getBool("auth") ?? false;
//       });
//     }

//     if (madate == null || madate!.isBefore(DateTime.now())) {
//       print("Licence expirée ou inexistante.");

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Votre licence a expiré ou est inexistante. Veuillez la renouveler.'),
//           ),
//         );
//       }
//     } else {
//       if (auth && mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       }
//     }
//   } catch (e, stacktrace) {
//     print("Erreur dans la vérification de la licence : $e");
//     print("Trace : $stacktrace");
//   }
// }


//   Future<void> _verif() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   try {
//     // Récupération de la valeur sauvegardée
//     String? madatasave = prefs.getString("password");

//     if (madatasave != null && madatasave.isNotEmpty) {
//       // Appel de la méthode si la valeur est valide
//       verifAndprolonge(madatasave);
//     } else {
//       print("Aucune donnée sauvegardée pour 'password'.");
//     }
//   } catch (e, stacktrace) {
//     // Gestion des erreurs et log des détails
//     print("Erreur lors de la récupération des données : $e");
//     print("Trace : $stacktrace");
//   }
// }



// Future<void> verifAndprolonge(String password) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   try {
//     setState(() {
//       logi = true; // Affiche un chargement
//     });

//     // Appeler l'authentification avec le mot de passe
//     final response = await AuthKTransfert.authBypass({"password": password});

//     if (response.containsKey('date_fin')) {
//       DateTime today = DateTime.now();
//       DateTime newExpiryDate = DateTime.parse(response['date_fin']);

//       if (newExpiryDate.isAfter(today)) {
//         // La licence est valide
//         prefs.setBool('auth', true);
//         prefs.setString('password', password);
//         prefs.setString('date_fin', newExpiryDate.toIso8601String());
//         print("Licence valide jusqu'à $newExpiryDate");

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Licence prolongée jusqu\'au $newExpiryDate.')),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       } else {
//         // Licence expirée
//         prefs.setBool('auth', false);
//         print("La licence a expiré. Veuillez renouveler.");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Licence expirée. Veuillez la renouveler.')),
//         );
//       }
//     } else if (response.containsKey('error')) {
//       // Erreur côté serveur ou mot de passe invalide
//       print("Erreur du serveur : ${response['error']}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur du serveur : ${response['error']}')),
//       );
//     } else {
//       // Réponse inattendue
//       print("Mot de passe invalide ou réponse inconnue du serveur.");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Mot de passe invalide ou licence expirée.')),
//       );
//     }
//   } catch (e) {
//     // Gestion des erreurs réseau ou autres
//     print("Erreur22222 de connexion : $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Erreur111111 de connexion : $e')),
//     );
//   }
//    finally {
//     setState(() {
//       logi = false; // Masque le chargement
//     });
//   }
// }

//   // Connexion avec validation du mot de passe
//   Future<void> connectmyUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     try {
//       setState(() {
//         logi = true; // Affiche un chargement
//       });

//       //var response =
//       await AuthKTransfert.authBypass({"password": _passwordController.text})
//           .then((response) {
//         if (response['response'] == "true") {
//           DateTime newExpiryDate = DateTime.parse(response['date_fin']);
//           prefs.setBool('auth', true);
//           prefs.setString('password', _passwordController.text);
//           prefs.setString('date_fin', newExpiryDate.toString());
//           print(newExpiryDate.toString());
//           DateTime today = DateTime.now();
//           if(today.isAfter(newExpiryDate)) {
//             ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text('Mot de-passe incorrect ou licence expirée.')),
//           );
//           }else{
//             ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Connexion réussie.')),
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomePage()),
//           );
//           }
          
          
//         } else {
//           verifAndprolonge(_passwordController.text);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text('Mot de-passe incorrect ou licence expirée.')),
//           );
//         }
//       });

//       //print("Réponse du serveur : $response");

//       // Si la licence est valide
//     } catch (e) {
//       print("Erreur dans la connexion : $e");
//     } finally {
//       setState(() {
//         logi = false; // Masque le chargement
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('LICENCE KADOUS TRANSFERT'),
//         centerTitle: true,
//         backgroundColor: Colors.orange,
//       ),
//       body: logi
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Veuillez entrer votre licence',
//                       style: TextStyle(fontSize: 24.0),
//                     ),
//                     SizedBox(height: 20.0),
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Mot de passe',
//                       ),
//                     ),
//                     SizedBox(height: 20.0),
//                     ElevatedButton(
//                       onPressed: connectmyUser,
//                       child: Text('Se connecter'),
//                     ),
//                     SizedBox(height: 20.0),
//                     Container(
//                       padding: EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Text(
//                         'Veuillez contacter le +226 70808881/77917802 pour acquérir une licence !',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
