import 'package:snplay/view/entities/user_data_entity.dart';

class LoginResponseModel {
  String? status;
  String? iD;
  String? name;
  String? email;
  String? password;
  String? role;
  String? activeSubscription;
  String? subscriptionType;
  String? subscriptionExp;
  int? subscriptionRemaining;

  LoginResponseModel({this.status, this.iD, this.name, this.email, this.password, this.role, this.activeSubscription, this.subscriptionType, this.subscriptionExp, this.subscriptionRemaining});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    iD = json['ID'];
    name = json['Name'];
    email = json['Email'];
    password = json['Password'];
    role = json['Role'];
    activeSubscription = json['active_subscription'];
    subscriptionType = json['subscription_type'];
    subscriptionExp = json['subscription_exp'];
    subscriptionRemaining = int.tryParse(json['subscription_remaining'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['ID'] = iD;
    data['Name'] = name;
    data['Email'] = email;
    data['Password'] = password;
    data['Role'] = role;
    data['active_subscription'] = activeSubscription;
    data['subscription_type'] = subscriptionType;
    data['subscription_exp'] = subscriptionExp;
    data['subscription_remaining'] = subscriptionRemaining;
    return data;
  }

  UserData toEntity() => UserData(
        id: iD,
        name: name,
        email: email,
        role: role,
        activeSubscription: activeSubscription,
        subscriptionType: subscriptionType,
        subscriptionExp: DateTime.tryParse(subscriptionExp ?? ''),
        subscriptionRemaining: subscriptionRemaining,
      );
}
