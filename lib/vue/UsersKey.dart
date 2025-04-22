import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';

void showAddItemDialog(BuildContext context, Box<UsersKeyModel> box) {
  final TextEditingController inputController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Saisissez votre code"),
        content: TextField(
          controller: inputController,
          decoration: const InputDecoration(hintText: "Saisir le code..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final input = inputController.text.trim();
              if (input.isNotEmpty) {
                // ✅ Supprimer chaque élément un par un
                final keys = box.keys.toList();
                for (var key in keys) {
                  await box.delete(key);
                }

                // ✅ Ajouter le nouvel élément
                final newKey = UsersKeyModel(
                  numauto: 1,
                  numeroaleatoire: input,
                );
                await box.add(newKey);

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ajouté : $input")),
                );
              }
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}



Future<Box<UsersKeyModel>> getUsersKeyBox() async {
  if (Hive.isBoxOpen('todobos7')) {
    return Hive.box<UsersKeyModel>('todobos7');
  } else {
    return await Hive.openBox<UsersKeyModel>('todobos7');
  }
}
