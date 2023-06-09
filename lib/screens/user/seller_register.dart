// ignore_for_file: non_constant_identifier_names
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/seller_api.dart';
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/main.dart';
import 'package:topup2p_nodejs/providers/favorites_provider.dart';
import 'dart:io';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/utilities/globals.dart';
import 'package:topup2p_nodejs/utilities/image_file_utils.dart';
import 'package:topup2p_nodejs/widgets/loading_screen.dart';

class SellerRegisterScreen extends StatefulWidget {
  const SellerRegisterScreen({super.key});

  @override
  State<SellerRegisterScreen> createState() => _SellerRegisterScreenState();
}

class _SellerRegisterScreenState extends State<SellerRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _Sname = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  PlatformFile? pickedFile;
  String? urlDownload;

  void _textValidator(String value) async {
    if (value.isEmpty) {
      _errorMessage = 'Shop name is required';
    }
    final doesExist = await SellerAPIService.readSellerData(shopName: value);
    bool flag = doesExist != null ? true : false;
    setState(() {
      _errorMessage = flag ? 'Shop name is already taken' : null;
    });
  }

  @override
  void dispose() {
    _Sname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool flag = MediaQuery.of(context).orientation == Orientation.portrait;
    Widget registerName = Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Form(
        //autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _Sname,
              decoration: const InputDecoration(hintText: 'Shop Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Shop name is required';
                }
                _textValidator(value);
                return _errorMessage;
              },
              onChanged: _errorMessage = null,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (_formKey.currentState!.validate()) {
                    // form is valid
                    setState(() {
                      _isLoading = true;
                    });
                    //picked a file
                    if (pickedFile != null) {
                      urlDownload = await uploadImageFile(
                          pickedFile!, userProvider.user!.uid!);
                    }
                    String assetsPath = 'assets/images/store-placeholder.png';
                    if (urlDownload != null) {
                      assetsPath = await imageToAssets(
                          url: urlDownload!, uid: userProvider.user!.uid!);
                    }
                    final imageUrl =
                        urlDownload ?? 'assets/images/store-placeholder.png';
                    final updateData = <String, dynamic>{
                      "name": _Sname.text.trim(),
                      "type": "seller",
                      "image": assetsPath,
                      "image_url": imageUrl
                    };
                    //update users info to sellers info (ex: name to shop name)
                    final responses = await UserAPIService.update(
                        uid: userProvider.user!.uid!,
                        data: updateData,
                        updateType: 'convertToSeller');
                    bool flag = true;
                    for (var response in responses) {
                      if (response.statusCode != 200) {
                        //do something
                        //todo
                        print('Error Status Code: ${response.statusCode}');
                        flag = false;
                      }
                    }
                    if (flag) {
                      navigator.popUntil((route) => route.isFirst);
                      itemsObjectList.clear();
                      userProvider.updateUser(data: updateData);
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Topup2p(),
                        ),
                      );
                    } else {
                      throw 'Conversion to seller failed';
                    }
                    setState(() {
                      _isLoading = false;
                    });
                    //optional
                    //Restart.restartApp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Proceed',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //back to log in page
    Widget backButton = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const <Widget>[
                  Icon(Icons.arrow_back_ios_outlined),
                  Text(
                    'Back',
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
    Widget registerImage = Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        child: Stack(
          children: [
            SizedBox(
              height: flag
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2,
              width: flag
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height / 2,
              child: ClipPath(
                clipper: const ShapeBorderClipper(shape: CircleBorder()),
                clipBehavior: Clip.hardEdge,
                child: (pickedFile != null)
                    ? Image.file(
                        File(pickedFile!.path!),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/upload-image.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            //upload icon
            Positioned(
              right: flag ? 0 : 85,
              bottom: flag ? 20 : 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Colors.teal
                      : Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                height: flag
                    ? MediaQuery.of(context).size.width / 7
                    : MediaQuery.of(context).size.width / 9,
                width: flag
                    ? MediaQuery.of(context).size.height / 7
                    : MediaQuery.of(context).size.height / 9,
                child: const ClipPath(
                    clipper: ShapeBorderClipper(shape: CircleBorder()),
                    clipBehavior: Clip.hardEdge,
                    child: Icon(
                      Icons.upload,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
        onTap: () async {
          pickedFile = await selectImageFile();
          setState(() {});
        },
      ),
    );
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: LoadingScreen(),
            )
          : ListView(
              children: [
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      backButton,
                      registerImage,
                      registerName,
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
