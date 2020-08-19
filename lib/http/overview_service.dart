import 'dart:convert';
import 'package:eopy_management_system/http/http_base_service.dart';
import 'package:eopy_management_system/models/overview.dart';
import 'package:http/http.dart' as http;

class OverviewService extends HttpBaseService {
  final String _serviceUrl = '192.168.0.108:8080';

  Future<Overview> getOverview() async {
    var uri = Uri.http(_serviceUrl, "order/getOverview");
    final response = await http.get(uri).timeout(new Duration(seconds: 5));

    if (response.statusCode == 200) {
      Map overview = json.decode(response.body)["Result"];
      return Overview.fromJson(overview);
    } else {
      throw Exception("Something went wrong : $response");
    }
  }
}
