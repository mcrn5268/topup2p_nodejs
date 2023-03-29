import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/seller_api.dart';
import 'package:topup2p_nodejs/models/item_model.dart';
import 'package:topup2p_nodejs/models/payment_model.dart';
import 'package:topup2p_nodejs/providers/payment_provider.dart';
import 'package:topup2p_nodejs/providers/sell_items_provider.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/screens/messages.dart';
import 'package:topup2p_nodejs/screens/profile.dart';
import 'package:topup2p_nodejs/screens/seller/seller_home.dart';
import 'package:topup2p_nodejs/utilities/models_utils.dart';
import 'package:topup2p_nodejs/widgets/loading_screen.dart';

class SellerMain extends StatefulWidget {
  final int? index;
  const SellerMain({this.index, super.key});

  @override
  State<SellerMain> createState() => _SellerMainState();
}

class _SellerMainState extends State<SellerMain> {
  bool _isLoading = false;
  late int _currentIndex;
  final PageStorageBucket bucket = PageStorageBucket();
  late final List<Widget> _children;
  late PaymentProvider paymentProvider;

  @override
  void initState() {
    super.initState();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    _isLoading = true;
    readSellerMongoDB();
    _currentIndex = widget.index ?? 0;
    _children = [
      const SellerMainScreen(),
      const Scaffold(
        body: Center(child: Text('Messages')),
      ),
      // MultiProvider(
      //     providers: [
      //       ChangeNotifierProvider<SellItemsProvider>.value(
      //         value: SellItemsProvider(),
      //       ),
      //       ChangeNotifierProvider<PaymentProvider>.value(
      //         value: PaymentProvider(),
      //       ),
      //     ],
      //     child: MessagesScreen(
      //         siItems:
      //             Provider.of<SellItemsProvider>(context, listen: false).Sitems,
      //         payments: Provider.of<PaymentProvider>(context, listen: false)
      //             .payments)),
      const ProfileScreen()
    ];
  }

  Future<void> readSellerMongoDB() async {
    //todo
    // Map<String, dynamic>? sellerData = await FirestoreService().read(
    //     collection: 'sellers',
    //     documentId:
    //         Provider.of<UserProvider>(context, listen: false).user!.uid);
    final sellerData = await SellerAPIService.readSellerData(
        shopName: Provider.of<UserProvider>(context, listen: false).user!.name);
    print('sellerData: $sellerData');
    if (sellerData != null) {
      //MoPs
      try {
        Map<String, dynamic>? mopMap = sellerData['mop'];
        //If seller has MoP from firestore
        if (mopMap!.isNotEmpty) {
          for (String paymentName in mopMap.keys) {
            Map<String, dynamic> paymentData = mopMap[paymentName];

            Payment payment = Payment(
              paymentname: paymentName,
              accountname: paymentData['account_name'],
              accountnumber: paymentData['account_number'],
              isEnabled: paymentData['status'] == 'enabled',
              paymentimage: 'assets/images/MoP/${paymentName}Card.png',
            );
            paymentProvider.addPayment(payment);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              'Something went wrong with reading seller MoP data from MongoDB: $e');
        }
      }
      //MoPs
      try {
        Map<String, dynamic>? gamesMap = sellerData['games'];
        //If seller has games posted from firestore
        if (gamesMap!.isNotEmpty) {
          gamesMap.forEach((key, value) {
            Item? item = getItemByName(key);
            if (item != null) {
              Provider.of<SellItemsProvider>(context, listen: false)
                  .addItem(item, value, notify: false);
            }
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              'Something went wrong with reading seller games data from MongoDB: $e');
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: PageStorage(
              bucket: bucket,
              child: IndexedStack(
                index: _currentIndex,
                children: _children,
              ),
            ),
            bottomNavigationBar: Stack(
              children: [
                BottomNavigationBar(
                  onTap: onTabTapped,
                  currentIndex: _currentIndex,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.message),
                      label: 'Messages',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
                Positioned(
                    right: MediaQuery.of(context).size.width / 2 - 15,
                    bottom: 35,
                    child: StreamBuilder(
                        //todo
                        stream: null,
                        // stream: FirestoreService().getSeenStream(
                        //     uid: Provider.of<UserProvider>(context,
                        //             listen: false)
                        //         .user!
                        //         .uid),
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: snapshot.hasData,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                              ),
                            ),
                          );
                        }))
              ],
            ),
          );
  }

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
