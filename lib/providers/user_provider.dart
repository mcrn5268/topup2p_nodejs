import 'package:flutter/foundation.dart';
import 'package:topup2p_nodejs/api/auth_api.dart';
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/models/user_model.dart';
import 'package:topup2p_nodejs/utilities/sharedpreference.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserProvider() {
    init();
  }

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateUser(
      {required Map<String, dynamic> data}) {
    if (_user != null) {
      _user = UserModel(
          uid: _user!.uid,
          email: _user!.email,
          name: data['name'] ?? _user!.name,
          type: data['type'] ?? _user!.type,
          image: data['image'] ?? _user!.image,
          image_url: data['image_url'] ?? _user!.image_url);

      notifyListeners();
    }
  }

  Future<void> init() async {
    final SharedPreferencesService prefService = SharedPreferencesService();
    //index - value
    //0 - uid
    //1 - jwt token
    final List<String>? userPrefs = await prefService.getStringList('jwt');
    if (userPrefs != null) {
      print('init() jwt token: ${userPrefs[1]}');
      final response = await AuthAPIService.checkJwtToken(userPrefs[1]);
      if (response.statusCode == 200) {
        // Token is valid
        final user = await UserAPIService.getUser(userId: userPrefs[0]);
        if (user != null) {
          setUser(user);
        }
      } else {
        //not valid
        //user needs to log back in
        await AuthAPIService.logout();
        await prefService.remove('jwt');
      }
    } else {
      print('userPrefence is null');
    }
  }
}
