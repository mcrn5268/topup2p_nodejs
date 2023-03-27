import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/providers/favorites_provider.dart';
import 'package:topup2p_nodejs/screens/profile.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    FavoritesProvider favProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: Colors.transparent),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ProfileScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      },
      child: Row(
        children: const <Widget>[Icon(Icons.person_outline_sharp)],
      ),
    );
  }
}
