import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/utilities/image_file_utils.dart';

Widget getImage(context) {
  UserProvider userProvider = Provider.of<UserProvider>(context);
  if (userProvider.user!.image == 'assets/images/person-placeholder.png' ||
      userProvider.user!.image == 'assets/images/store-placeholder.png') {
    return CircleAvatar(
        radius: 70, backgroundImage: AssetImage(userProvider.user!.image));
  } else {
    final file = File(userProvider.user!.image);
    //if file doesn't exist in local files
    if (!file.existsSync()) {
      //image url to assets
      imageToAssets(
              url: userProvider.user!.image_url, uid: userProvider.user!.uid!)
          .then((path) {
        userProvider.updateUser(data: {'image': path});
      });
      //temporary container while waiting for userprovider notifylistener
      return Container();
    } else {
      return CircleAvatar(
        radius: 70,
        backgroundImage: FileImage(File(userProvider.user!.image)),
      );
    }
  }
}
