class RevenueGraphResModel {
  bool? status;
  RevenueGraph? revenueGraph;
  OrderGraph? orderGraph;

  RevenueGraphResModel({this.status, this.revenueGraph, this.orderGraph});

  RevenueGraphResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString().toLowerCase() == 'true';
    revenueGraph = json['revenueGraph'] != null
        ? RevenueGraph.fromJson(json['revenueGraph'])
        : null;
    orderGraph = json['orderGraph'] != null
        ? OrderGraph.fromJson(json['orderGraph'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status.toString();
    if (revenueGraph != null) {
      data['revenueGraph'] = revenueGraph!.toJson();
    }
    if (orderGraph != null) {
      data['orderGraph'] = orderGraph!.toJson();
    }
    return data;
  }
}

class RevenueGraph {
  String? currencyCode;
  String? currencySymbol;
  int? weeklyTotal;
  int? monthlyTotal;
  List<MonthData>? month;
  List<WeekData>? week;

  RevenueGraph(
      {this.currencyCode,
      this.currencySymbol,
      this.weeklyTotal,
      this.monthlyTotal,
      this.month,
      this.week});

  RevenueGraph.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    weeklyTotal = json['weeklyTotal'];
    monthlyTotal = json['monthlyTotal'];
    if (json['month'] != null) {
      month = <MonthData>[];
      json['month'].forEach((v) {
        month!.add(MonthData.fromJson(v));
      });
    }
    if (json['week'] != null) {
      week = <WeekData>[];
      json['week'].forEach((v) {
        week!.add(WeekData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['weeklyTotal'] = weeklyTotal;
    data['monthlyTotal'] = monthlyTotal;
    if (month != null) {
      data['month'] = month!.map((v) => v.toJson()).toList();
    }
    if (week != null) {
      data['week'] = week!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MonthData {
  int? name;
  int? amount;

  MonthData({this.name, this.amount});

  MonthData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}

class WeekData {
  int? id;
  String? name;
  int? amount;

  WeekData({this.id, this.name, this.amount});

  WeekData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}

class OrderGraph {
  List<OrderData>? week;
  List<OrderData>? month;
  int? weeklyTotal;
  int? monthlyTotal;

  OrderGraph({this.week, this.month, this.weeklyTotal, this.monthlyTotal});

  OrderGraph.fromJson(Map<String, dynamic> json) {
    if (json['week'] != null) {
      week = <OrderData>[];
      json['week'].forEach((v) {
        week!.add(OrderData.fromJson(v));
      });
    }
    if (json['month'] != null) {
      month = <OrderData>[];
      json['month'].forEach((v) {
        month!.add(OrderData.fromJson(v));
      });
    }
    weeklyTotal = json['weeklyTotal'];
    monthlyTotal = json['monthlyTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (week != null) {
      data['week'] = week!.map((v) => v.toJson()).toList();
    }
    if (month != null) {
      data['month'] = month!.map((v) => v.toJson()).toList();
    }
    data['weeklyTotal'] = weeklyTotal;
    data['monthlyTotal'] = monthlyTotal;
    return data;
  }
}

class OrderData {
  String? name;
  int? amount;

  OrderData({this.name, this.amount});

  OrderData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}
