import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';

Future<void> saveMultipleDefaultAddSimModels() async {
  // Ouvrir la boîte Hive pour AddSimModel
  var box = await Hive.openBox<AddSimModel>('todobos5');

  List<AddSimModel> defaultSims = [
    AddSimModel(
      idOperateur: 1,
      LibOperateur: 'Orange BF',
      NumPhone: '01010101',
      CodeAgent: 'A001',
      supprimer: 0,
    ),
    AddSimModel(
      idOperateur: 2,
      LibOperateur: 'Moov SA',
      NumPhone: '02020202',
      CodeAgent: 'A002',
      supprimer: 0,
    ),
    AddSimModel(
      idOperateur: 3,
      LibOperateur: 'Telecel',
      NumPhone: '03030303',
      CodeAgent: 'A003',
      supprimer: 0,
    ),
    AddSimModel(
      idOperateur: 4,
      LibOperateur: 'Wave',
      NumPhone: '04040404',
      CodeAgent: 'A004',
      supprimer: 0,
    ),
    AddSimModel(
      idOperateur: 5,
      LibOperateur: 'Sank',
      NumPhone: '05050505',
      CodeAgent: 'A005',
      supprimer: 0,
    ),
  ];

  for (var sim in defaultSims) {
    // Spécifier que le type peut être nul
    AddSimModel? existingSim = box.values.firstWhere(
      (element) => element.idOperateur == sim.idOperateur,
      orElse: () => null as AddSimModel, // cast pour satisfaire le typage
    );

    if (existingSim == null) {
      await box.add(sim);
    }
  }
}
