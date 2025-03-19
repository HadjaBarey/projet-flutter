import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'api_service.dart';

class OperationTransactionService {
  final ApiService<OrangeModel> apiService = ApiService("http://192.168.100.6:8081/transaction/v1/OperationTranslation/all");

  Future<void> sendOperationTransactionData(OrangeModel OperationTransaction) async {
    await apiService.sendData(OperationTransaction, (c) => c.toJson());
  }

  Future<List<OrangeModel>> fetchOperationTransactionData() async {
    return await apiService.fetchData((json) => OrangeModel.fromJSON(json));
  }
}
