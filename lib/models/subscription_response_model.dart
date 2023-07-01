import 'package:snplay/view/entities/subscription_entity.dart';

class SubscriptionResponseModel {
  String? id;
  String? name;
  String? time;
  String? amount;
  String? currency;
  String? background;
  String? subscriptionType;
  String? status;

  SubscriptionResponseModel({this.id, this.name, this.time, this.amount, this.currency, this.background, this.subscriptionType, this.status});

  SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
    amount = json['amount'];
    currency = json['currency'];
    background = json['background'];
    subscriptionType = json['subscription_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['time'] = time;
    data['amount'] = amount;
    data['currency'] = currency;
    data['background'] = background;
    data['subscription_type'] = subscriptionType;
    data['status'] = status;
    return data;
  }

  Subscription toEntity() => Subscription(id: id, name: name, time: time, amount: amount, subscriptionType: subscriptionType, status: status);
}
