import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/favorite_api.dart';
import 'package:topup2p_nodejs/models/item_model.dart';
import 'package:topup2p_nodejs/providers/favorites_provider.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/utilities/globals.dart';
import 'package:topup2p_nodejs/utilities/models_utils.dart';

class FavoritesIcon extends StatefulWidget {
  final String itemName;
  final double size;
  const FavoritesIcon({required this.itemName, required this.size, super.key});

  @override
  State<FavoritesIcon> createState() => _FavoritesIconState();
}

class _FavoritesIconState extends State<FavoritesIcon> {
  @override
  Widget build(BuildContext context) {
    Item? itemObject = getItemByName(widget.itemName);
    FavoritesProvider favProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (itemObject != null) {
      return Align(
          alignment: Alignment.topRight,
          child: IconButton(
            key: ValueKey('${widget.itemName}favButton'),
            icon: Image.asset(
                Provider.of<FavoritesProvider>(context).isFavorite(itemObject)
                    ? icon[true]!
                    : icon[false]!),
            color: null,
            padding: const EdgeInsets.only(right: 10),
            constraints: const BoxConstraints(),
            iconSize: widget.size,
            onPressed: () async {
              late dynamic response;
              if (favProvider.isFavorite(itemObject)) {
                response = await FavAPIService.toggleFavorite(
                  type: 'remove',
                  gameName: widget.itemName,
                  uid: userProvider.user!.uid!,
                );
              } else {
                response = await FavAPIService.toggleFavorite(
                  type: 'add',
                  gameName: widget.itemName,
                  uid: userProvider.user!.uid!,
                );
              }
              if (response.statusCode == 200) {
                favProvider.toggleFavorite(itemObject);
              } else {
                print('something went wrong with toggle favorite item. Status code: ${response.statusCode}');
              }
            },
          ));
    } else {
      return const Align(
          alignment: Alignment.topRight, child: Icon(Icons.error));
    }
  }
}
