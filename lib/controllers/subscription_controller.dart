import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/subscription_response_model.dart';
import 'package:snplay/view/entities/subscription_entity.dart';

class SubscriptionController extends GetxController {
  static SubscriptionController instance = Get.find();
  final Rx<List<Subscription>> _subscription = Rx<List<Subscription>>([]);
  final Rx<Status> _status = Rx<Status>(Status.empty);
  final apiService = ApiService();

  Status get status => _status.value;
  List<Subscription> get subscription => _subscription.value;

  @override
  void onInit() {
    getSubscription();
    super.onInit();
  }

  getSubscription() async {
    try {
      _status.value = Status.loading;
      List<dynamic> response = await apiService.get("$baseURL/getSubscriptionPlans");
      List<Subscription> data = response.map((e) => SubscriptionResponseModel.fromJson(e).toEntity()).toList();
      _subscription.value = data;
      _status.value = Status.success;
    } catch (e) {
      _status.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }
}
