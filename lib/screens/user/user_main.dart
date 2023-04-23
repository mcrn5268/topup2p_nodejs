import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/providers/favorites_provider.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/screens/user/favorites.dart';
import 'package:topup2p_nodejs/screens/user/user_home.dart';
import 'package:topup2p_nodejs/utilities/models_utils.dart';
import 'package:topup2p_nodejs/widgets/appbar/appbar.dart';
import 'package:topup2p_nodejs/widgets/headline6.dart';
import 'package:topup2p_nodejs/widgets/loading_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});
  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    print('name: ${userProvider.user!.name}');
    print('email: ${userProvider.user!.email}');
    print('uid: ${userProvider.user!.uid}');
    return FutureBuilder(
        //check for favorited items in firestore for UI
        future:
            UserAPIService.getUserFavorites(userId: userProvider.user!.uid!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isNotEmpty) {
              // Read Firestore data into a List of MapEntry objects
              List<MapEntry<String, dynamic>> data =
                  snapshot.data!.entries.toList();
              // Sort the List based on the order of fields in the Firestore document - inverted
              if (data.length > 1) {
                data.sort((a, b) => a.value.compareTo(b.value));
              }

              // Iterate over the sorted List to add items to the FavoritesProvider
              for (var entry in data) {
                var favoritedItem = getItemByName(entry.key);
                // Add Item to favorited items list
                Provider.of<FavoritesProvider>(context, listen: false)
                    .toggleFavorite(favoritedItem!, notify: false);
              }
            } else {
              if (kDebugMode) {
                print("snapshot is empty users_game_data - favorited");
              }
            }
            return Scaffold(
                appBar: AppBarWidget(
                    home: true,
                    search: true,
                    isloggedin: userProvider.user != null),
                body: ListView(
                  addAutomaticKeepAlives: true,
                  shrinkWrap: false,
                  children: const <Widget>[
                    HeadLine6('FAVORITES'),
                    FavoritesList(),
                    Divider(),
                    HeadLine6('GAMES'),
                    GamesList(),
                  ],
                ));
          } else {
            return const SizedBox(
              width: 50,
              height: 50,
              child: LoadingScreen(),
            );
          }
        });
  }
}
