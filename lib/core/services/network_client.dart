import 'base_api_service.dart';
import 'package:http/http.dart' as http;

class NetworkClient extends BaseApiServices {

  @override
  Future<dynamic> postApiResponse(String url, dynamic data) async {}

  @override
  Future getApiResponse(String url) async {
      final response = await http
          .get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      print('${response.statusCode}----------&&');
      print('${response.body}---from get api call-------&&');
      print(response.body);
      return response;
  }
}
