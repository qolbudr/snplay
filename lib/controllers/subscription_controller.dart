import 'dart:convert';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/login_controller.dart';
import 'package:snplay/controllers/services/api_service.dart';
import 'package:snplay/models/subscription_response_model.dart';
import 'package:snplay/view/entities/midtrans_param_entity.dart';
import 'package:snplay/view/entities/subscription_entity.dart';

class SubscriptionController extends GetxController {
  static SubscriptionController instance = Get.find();
  final Rx<List<Subscription>> _subscription = Rx<List<Subscription>>([]);
  final Rx<Status> _status = Rx<Status>(Status.empty);
  final Rx<List<bool>> _buttonLoading = Rx<List<bool>>([]);
  final apiService = ApiService();
  final LoginController loginController = Get.put(LoginController());
  final Rx<int> _updater = Rx<int>(0);

  Status get status => _status.value;
  int get updater => _updater.value;
  List<bool> get buttonLoading => _buttonLoading.value;
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
      for (int i = 0; i <= data.length; i++) {
        _buttonLoading.value.add(false);
      }
      _status.value = Status.success;
    } catch (e) {
      _status.value = Status.error;
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }

  createPayment(int index) async {
    try {
      List<int> encoded = utf8.encode('${subscription[index].id}#${loginController.user.id}#${DateTime.now().millisecondsSinceEpoch}');
      String orderId = base64Encode(encoded);
      _buttonLoading.value[index] = true;
      _updater.value += 1;
      Map<String, dynamic> param = {
        'transaction_details': {
          'order_id': orderId,
          'gross_amount': subscription[index].amount,
        },
        'credit_card': {
          'secure': true,
        }
      };
      String token = await apiService.post("$vercelURL/create/snap", param);
      _buttonLoading.value[index] = false;
      _updater.value += 1;
      Get.toNamed('/midtrans-pay', arguments: MidtransParam(token: token, subscription: subscription[index]));
    } catch (e) {
      Get.snackbar('Ada Kesalahan', getError(e));
    }
  }
}
