import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/auth_api.dart';
import 'package:topup2p_nodejs/main.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/utilities/globals.dart';
import 'package:topup2p_nodejs/utilities/sharedpreference.dart';
import 'package:topup2p_nodejs/widgets/show_dialog.dart';

class SignoutButton extends StatelessWidget {
  const SignoutButton({super.key});
  @override
  Widget build(BuildContext context) {
    UserProvider? userProvder;
    return ElevatedButton(
      onPressed: () async {
        try {
          final navigator = Navigator.of(context);
          userProvder = Provider.of<UserProvider>(context, listen: false);
          bool? flag = await dialogBuilder(
              context, 'Sign out', 'Are you sure you want to sign out?');
          if (flag!) {
            final response = await AuthAPIService.logout();
            if (response.statusCode == 200) {
              navigator.popUntil((route) => route.isFirst);
              itemsObjectList.clear();
              userProvder!.clearUser();
              await SharedPreferencesService().remove('jwt');
              // Navigate back to main
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Topup2p(),
                ),
              );
            } else {
              //failed
              throw 'Signing out failed';
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error signing out: $e');
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.red)),
      ),
      child: Row(
        children: const <Widget>[
          Text(
            'Sign Out',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
