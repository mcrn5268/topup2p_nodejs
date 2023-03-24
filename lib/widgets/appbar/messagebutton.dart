import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/screens/messages.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({this.fromProfile, super.key});
  final bool? fromProfile;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:null, 
        //todo
        // FirestoreService().getSeenStream(
        //     uid: Provider.of<UserProvider>(context, listen: false).user!.uid),
        builder: (context, snapshot) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Colors.transparent),
            ),
            onPressed: () {
              //todo
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => const MessagesScreen(),
              //     transitionsBuilder: (_, a, __, c) =>
              //         FadeTransition(opacity: a, child: c),
              //   ),
              // );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  child: Stack(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_outlined,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : (fromProfile != null)
                                ? Colors.white
                                : Colors.black,
                      ),
                      Visibility(
                        visible: snapshot.hasData,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
