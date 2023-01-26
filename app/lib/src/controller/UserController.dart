import 'package:get/get.dart';
import 'package:app/src/repository/user/UserRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  final userRepo = Get.put(UserRepository());

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return (token != null) ? token : '';
  }

  Future<String?> register(String id, String name, String email,
      String password, String sid, String department) async {
    final prefs = await SharedPreferences.getInstance();
    Map body =
        await userRepo.register(id, name, email, password, sid, department);
    if (body['message'] == 'success') {
      prefs.setString('token', body['token']);
      return null;
    } else {
      return body['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    Map body = await userRepo.login(email, password);
    print("body $body");
    if (body['result'] == 'success') {
      prefs.setString('token', body['values']['id']);
      return null;
    } else {
      return body['result'];
    }
  }
}
