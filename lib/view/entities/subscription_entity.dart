class Subscription {
  String? id;
  String? name;
  String? time;
  String? amount;
  String? subscriptionType;
  String? status;

  Subscription({this.id, this.name, this.time, this.amount, this.subscriptionType, this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['time'] = time;
    data['amount'] = amount;
    data['subscriptionType'] = subscriptionType;
    data['status'] = status;
    return data;
  }
}
