import 'dart:convert';
import 'package:eopy_management_system/models/order.dart';
import 'package:http/http.dart' as http;
import 'http_base_service.dart';

class OrderService extends HttpBaseService {
  final String _serviceUrl = HttpBaseService.serviceUrl;

//Get -> Order/GetOrders
  Future<List<Order>> getOrders() async {
    var uri = Uri.http(_serviceUrl, "order/getOrders");
    final response = await http.get(uri).timeout(new Duration(seconds: 5));

    if (response.statusCode == 200) {
      Iterable items = json.decode(response.body)["Result"];
      return items.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception("Something went wrong : $response");
    }
  }

//Get -> Order/GetOrders
  Future<List<Order>> getOrdersWithStatus(String status) async {
    var uri = Uri.http(_serviceUrl, "order/GetOrdersWithStatus/$status");
    final response = await http.get(uri).timeout(new Duration(seconds: 5));

    if (response.statusCode == 200) {
      Iterable items = json.decode(response.body)["Result"];
      return items.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception("Something went wrong : $response");
    }
  }

//Post -> Order/AddOrder -> {order}
  Future<Order> addOrder(Order order) async {
    var uri = Uri.http(_serviceUrl, "order/addOrder");
    var _orderJson = jsonEncode(order.toJson());
    final response = await http.post(uri,
        headers: {'content-type': 'application/json'}, body: _orderJson);

    if (response.statusCode == 200) {
      Map item = json.decode(response.body)["Result"];
      return Order.fromJson(item);
    } else {
      throw Exception("Something went wrong : $response");
    }
  }

//Patch -> Order/UpdateOrder -> {order}
  Future<Order> updateOrder(Order order) async {
    var uri = Uri.http(_serviceUrl, "order/updateOrder");
    final response = await http.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200) {
      Map item = json.decode(response.body)["Result"];
      return Order.fromJson(item);
    } else {
      throw Exception("Something went wrong : $response");
    }
  }
}
