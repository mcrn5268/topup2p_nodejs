// ignore_for_file: non_constant_identifier_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/models/item_model.dart';
import 'package:topup2p_nodejs/providers/favorites_provider.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/utilities/image_file_utils.dart';
import 'package:topup2p_nodejs/utilities/profile_image.dart';
import 'package:topup2p_nodejs/widgets/loading_screen.dart';
import 'dart:io';

import 'package:topup2p_nodejs/widgets/toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _Sname = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  PlatformFile? pickedFile;
  //UploadTask is part of firebase_storage package
  //UploadTask? uploadTask;
  String? urlDownload;
  late UserProvider userProvider;
  FavoritesProvider? favProvider;

  Future<void> _textValidator(String value) async {
    if (value.isEmpty) {
      setState(() {
        _errorMessage = 'Shop name is required';
      });
    }
  }

  @override
  void dispose() {
    _Sname.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _Sname.text = userProvider.user!.name;
  }

  @override
  Widget build(BuildContext context) {
    bool flag = MediaQuery.of(context).orientation == Orientation.portrait;
    Widget editProfileSection = Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //todo maybe let the user type normal edit name
            Visibility(
              visible: userProvider.user!.type == 'seller',
              child: TextFormField(
                controller: _Sname,
                decoration: const InputDecoration(hintText: 'Shop name'),
                validator: (value) {
                  if (userProvider.user!.type == 'seller') {
                    _textValidator(value!);
                    return _errorMessage;
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  _errorMessage = null;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (_formKey.currentState!.validate()) {
                    // form is valid
                    if (pickedFile != null ||
                        _Sname.text != userProvider.user!.name) {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_Sname.text != userProvider.user!.name) {
                        await _textValidator(_Sname.text);
                      }
                      if (_errorMessage == null) {
                        //image is changed
                        if (pickedFile != null) {
                          urlDownload = await uploadImageFile(
                              pickedFile!, userProvider.user!.uid!);
                          String assetsPath =
                              userProvider.user!.type == 'seller'
                                  ? 'assets/images/store-placeholder.png'
                                  : 'assets/images/person-placeholder.png';
                          Map<String, dynamic> imageMap = {'image': assetsPath};

                          if (urlDownload != null) {
                            imageMap['image'] = await imageToAssets(
                                url: urlDownload!,
                                uid: userProvider.user!.uid!);
                            imageMap['image_url'] = urlDownload;
                          }
                          UserAPIService.update(
                              uid: userProvider.user!.uid!,
                              data: imageMap,
                              updateType: 'image');
                          userProvider
                              .updateUser(data: {'image': imageMap['image']});
                        }

                        //name is changed
                        if (_Sname.text != userProvider.user!.name) {
                          UserAPIService.update(
                              uid: userProvider.user!.uid!,
                              data: {'name': _Sname.text},
                              updateType: 'name');
                          userProvider.updateUser(data: {'name': _Sname.text});
                        }
                        navigator.pop();

                        setState(() {
                          _isLoading = false;
                        });
                        showToast('Profile Updated');
                      } else {
                        setState(() {
                          _isLoading = false;
                          showToast('Shop name is already taken. Try again.');
                        });
                      }
                    } else {
                      showToast('No changes has been made');
                      Navigator.pop(context);
                    }
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
                      'Update',
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
                children: const <Widget>[Icon(Icons.arrow_back_ios_outlined)],
              ),
            )
          ],
        ),
      ],
    );
    Widget editProfileBody = ListView(
      children: [
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              backButton,
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  child: Stack(
                    children: [
                      //display photo
                      SizedBox(
                        height: flag
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width / 2,
                        width: flag
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.height / 2,
                        child: ClipPath(
                            clipper:
                                const ShapeBorderClipper(shape: CircleBorder()),
                            clipBehavior: Clip.hardEdge,
                            child: (pickedFile != null)
                                ? Image.file(
                                    File(pickedFile!.path!),
                                    fit: BoxFit.cover,
                                  )
                                : getImage(context)),
                      ),
                      //upload icon
                      Positioned(
                        right: flag ? 0 : 85,
                        bottom: flag ? 20 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
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
                              clipper:
                                  ShapeBorderClipper(shape: CircleBorder()),
                              clipBehavior: Clip.hardEdge,
                              child: Icon(
                                Icons.upload,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      if (pickedFile != null) ...[
                        //remove image icon
                        Positioned(
                          right: flag ? 20 : 100,
                          top: flag ? 20 : 0,
                          child: InkWell(
                            child: const ClipPath(
                                clipper:
                                    ShapeBorderClipper(shape: CircleBorder()),
                                clipBehavior: Clip.hardEdge,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                )),
                            onTap: () => setState(() {
                              pickedFile = null;
                            }),
                          ),
                        ),
                      ]
                    ],
                  ),
                  onTap: () async {
                    pickedFile = await selectImageFile();

                    setState(() {});
                  },
                ),
              ),
              editProfileSection,
            ],
          ),
        ),
      ],
    );
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: LoadingScreen(),
              )
            : editProfileBody);
  }
}
