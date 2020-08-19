import 'dart:convert';
import 'package:eopy_management_system/http/http_base_service.dart';
import 'package:eopy_management_system/models/stock_barcode.dart';
import 'package:http/http.dart' as http;

class StockService extends HttpBaseService {
  final String _serviceUrl = '192.168.0.108:8080';

  //Get -> Order/GetStock/{barcode}
  Future<StockBarcode> getStock(String barcode) async {
    var uri = Uri.http(_serviceUrl, "order/GetStock/$barcode");
    final response = await http.get(uri).timeout(new Duration(seconds: 5));
    if (response.statusCode == 200) {
      return StockBarcode.fromJson(json.decode(response.body)["Result"]);
    } else {
      throw Exception("Something went wrong : $response");
    }
  }
}
