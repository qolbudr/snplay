import 'package:snplay/view/entities/subscription_entity.dart';

class UserData {
  String? id;
  String? name;
  String? email;
  String? role;
  String? activeSubscription;
  String? subscriptionType;
  DateTime? subscriptionExp;
  int? subscriptionRemaining;

  UserData({this.id, this.name, this.email, this.role, this.activeSubscription, this.subscriptionType, this.subscriptionExp, this.subscriptionRemaining});

  void setSubscription(Subscription subscription) {
    activeSubscription = subscription.name;
    subscriptionType = subscriptionType;
    subscriptionExp = DateTime.now().add(Duration(days: int.parse(subscription.time!)));
    subscriptionRemaining = int.parse(subscription.time!);
  }

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    activeSubscription = json['active_subscription'];
    subscriptionType = json['subscription_type'];
    subscriptionExp = DateTime.tryParse(json['subscription_exp']);
    subscriptionRemaining = json['subscription_remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['active_subscription'] = activeSubscription;
    data['subscription_type'] = subscriptionType;
    data['subscription_exp'] = subscriptionExp?.toIso8601String();
    data['subscription_remaining'] = subscriptionRemaining;
    return data;
  }
}
