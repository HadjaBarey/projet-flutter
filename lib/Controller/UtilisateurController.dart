import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';

class UtilisateurController {
  final formKey = GlobalKey<FormState>();
  late Box<UtilisateurModel> _todobos4;

  UtilisateurModel utilisateur = UtilisateurModel(
    idUtilisateur: 0,
    IdentiteUtilisateur: '',
    RefCNIBUtilisateur: '',
    NumPhoneUtilisateur: '',
    supprimer: 0,
  );

  UtilisateurController() {
    initializeBox();
  }

  TextEditingController idUtilisateurController = TextEditingController();
  TextEditingController IdentiteUtilisateurController = TextEditingController();
  TextEditingController RefCNIBUtilisateurController = TextEditingController();
  TextEditingController NumPhoneUtilisateurController = TextEditingController();
  TextEditingController supprimerController = TextEditingController(text: '0');

  void resetFormFields() {
    utilisateur = UtilisateurModel(
      idUtilisateur: utilisateur.idUtilisateur + 1,
      IdentiteUtilisateur: '',
      RefCNIBUtilisateur: '',
      NumPhoneUtilisateur: '',
      supprimer: 0,
    );
    idUtilisateurController.text = utilisateur.idUtilisateur.toString();
    IdentiteUtilisateurController.clear();
    RefCNIBUtilisateurController.clear();
    NumPhoneUtilisateurController.clear();
  }

  void _initializeUtilisateurId() {
    if (_todobos4.isNotEmpty) {
      final sortedUtilisateurs = _todobos4.values.toList()
        ..sort((a, b) => a.idUtilisateur.compareTo(b.idUtilisateur));
      final lastUtilisateur = sortedUtilisateurs.last;
      utilisateur.idUtilisateur = lastUtilisateur.idUtilisateur + 1;
    } else {
      utilisateur.idUtilisateur = 1;
    }
    idUtilisateurController.text = utilisateur.idUtilisateur.toString();
  }

  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(UtilisateurModelAdapter().typeId)) {
      Hive.registerAdapter(UtilisateurModelAdapter());
    }
    _todobos4 = await Hive.openBox<UtilisateurModel>("todobos4");
    _initializeUtilisateurId();
  }

  Future<List<UtilisateurModel>> loadData() async {
    if (_todobos4.isEmpty) {
      return [];
    }
    return _todobos4.values.where((utilisateur) => utilisateur.supprimer == 0).toList();
  }

  void updateUtilisateur({
    int? idUtilisateur,
    String? IdentiteUtilisateur,
    String? RefCNIBUtilisateur,
    String? NumPhoneUtilisateur,
    int? supprimer,
  }) {
    if (idUtilisateur != null) utilisateur.idUtilisateur = idUtilisateur;
    if (IdentiteUtilisateur != null) utilisateur.IdentiteUtilisateur = IdentiteUtilisateur;
    if (RefCNIBUtilisateur != null) utilisateur.RefCNIBUtilisateur = RefCNIBUtilisateur;
    if (NumPhoneUtilisateur != null) utilisateur.NumPhoneUtilisateur = NumPhoneUtilisateur;
    if (supprimer != null) utilisateur.supprimer = supprimer;
  }

  Future<void> saveUtilisateurData() async {
    try {
      await _todobos4.put(utilisateur.idUtilisateur, utilisateur);
      print("Enregistrement réussi : $utilisateur");
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(UtilisateurModel utilisateur) async {
    try {
      utilisateur.supprimer = 1;
      await _todobos4.put(utilisateur.idUtilisateur, utilisateur);
      print("Utilisateur marqué comme supprimé : $utilisateur");
    } catch (e) {
      print("Erreur lors de la mise à jour : $e");
    }
  }
}
