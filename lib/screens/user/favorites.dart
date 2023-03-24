// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/providers/favorites_provider.dart';
import 'package:topup2p_nodejs/screens/user/user_home.dart';
import 'package:topup2p_nodejs/widgets/favorite_icon.dart';
import 'package:topup2p_nodejs/widgets/favorite_placeholder.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

//change move AutomaticKeepAliveClientMixin to user_main.dart
class _FavoritesListState extends State<FavoritesList>
    with AutomaticKeepAliveClientMixin {
  final controller = ScrollController();
  bool flag = true;

  @override
  bool get wantKeepAlive => true;

  //arrow_forward_ios_outlined
  //arrow_back_ios_outlined
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 150,
      child: Consumer<FavoritesProvider>(builder: (context, favProvider, _) {
        if (favProvider.favorites.isEmpty) {
          return const FavoritesPlaceholder();
        } else {
          return ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: favProvider.favorites.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: SizedBox(
                        width: 114.5,
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Stack(children: [
                            GestureDetector(
                              onTap: () {
                                GameItemScreenNavigator(
                                    name: favProvider.favorites[index].name,
                                    flag: true);
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.asset(favProvider
                                              .favorites[index].image)),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            favProvider.favorites[index].name,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FavoritesIcon(
                                itemName: favProvider.favorites[index].name,
                                size: 20)
                          ]),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      }),
    );
  }
}
