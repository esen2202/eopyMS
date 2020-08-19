import 'dart:convert';
import 'package:eopy_management_system/http/http_base_service.dart';
import 'package:eopy_management_system/models/order_detail.dart';
import 'package:http/http.dart' as http;

class OrderDetailService extends HttpBaseService {
  String _serviceUrl = '192.168.0.108:8080';

//Get -> OrderDetails/{orderId}
  Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    var uri = Uri.http(_serviceUrl, "order/getOrderDetails/$orderId");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Iterable items = json.decode(response.body)["Result"];
      return items.map((item) => OrderDetail.fromJson(item)).toList();
    } else {
      throw Exception("Something went wrong : $response");
    }
  }

//Post -> Order/addOrderDetail -> {orderdetail}
  Future<OrderDetail> addOrderDetail(OrderDetail orderdetail) async {
    var uri = Uri.http(_serviceUrl, "order/addOrderDetail");
    var _orderDetailJson = jsonEncode(orderdetail.toJson());
    final response = await http.post(uri,
        headers: {'content-type': 'application/json'}, body: _orderDetailJson);

    if (response.statusCode == 200) {
      Map item = json.decode(response.body)["Result"];
      return OrderDetail.fromJson(item);
    } else {
      throw Exception("Something went wrong : $response");
    }
  }

//Patch -> Order/updateOrderDetail -> {orderdetail}
  Future<OrderDetail> updateOrderDetail(OrderDetail orderdetail) async {
    var uri = Uri.http(_serviceUrl, "order/updateOrderDetail");
    final response = await http.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(orderdetail.toJson()),
    );

    if (response.statusCode == 200) {
      Map item = json.decode(response.body)["Result"];
      return OrderDetail.fromJson(item);
    } else {
      throw Exception("Something went wrong : $response");
    }
  }
}
