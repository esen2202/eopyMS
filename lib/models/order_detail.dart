import 'package:flutter/material.dart';

class OrderDetail {
  int id;
  int orderId;
  int sequence;
  String stockCode;
  String stockName;
  int amount;
  String status;

  OrderDetail({
    this.id,
    @required this.orderId,
    this.sequence,
    this.stockCode,
    this.stockName,
    this.amount = 0,
    this.status = "",
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    orderId = json['OrderId'];
    sequence = json['Sequence'];
    stockCode = json['StockCode'];
    stockName = json['StockName'];
    amount = json['Amount'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'OrderId': this.orderId,
        'Sequence': this.sequence,
        'StockCode': this.stockCode,
        'StockName': this.stockName,
        'Amount': this.amount,
        'Status': this.status
      };
}
