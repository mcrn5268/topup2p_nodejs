// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:topup2p_nodejs/api/auth_api.dart';
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/models/user_model.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/utilities/sharedpreference.dart';
import 'package:topup2p_nodejs/widgets/custom_divider.dart';
import 'package:topup2p_nodejs/widgets/google_signin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _Fname = TextEditingController();
  final TextEditingController _Lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _Cpass = TextEditingController();
  late UserProvider userProvider;
  bool _obscureText = true;
  late FocusNode focusNode;
  bool _hasInputError = false;
  String text = '';

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          //CHECK AGAIN FOR VALID EMAIL ADDRESS NOT ONLY .COM
          if (text.contains('@') && text.endsWith('.com')) {
            _hasInputError = false;
          } else {
            _hasInputError = true;
          }
        });
      }
    });
    _Fname.text = 'John';
    _Lname.text = 'Smith';
    _email.text = 'johnsmith@johnsmith.com';
    _pass.text = 'johnsmith6969';
    _Cpass.text = 'johnsmith6969';
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _isLoading = false;

  Future<void> _registerUser() async {
    final navigator = Navigator.of(context);
    setState(() {
      _isLoading = true;
    });
    final String email = _email.text.trim();
    final String password = _pass.text.trim();
    final String name = ('${_Fname.text} ${_Lname.text}').trim();
    // final String phoneNumber = _phoneController.text.trim();

    final user = UserModel(
      email: email,
      name: name,
      type: 'normal',
      image: 'assets/images/person-placeholder.png',
      image_url: 'assets/images/person-placeholder.png',
    ).toMap();

    try {
      final response =
          await AuthAPIService.register(user: user, password: password);

      if (response.statusCode == 201) {
        // User registered successfully
        print('201 register');
        final responseJson = jsonDecode(response.body);
        print('responseJson $responseJson');
        //index - value
        //0 - uid
        //1 - jwt token
        List<String> authStrings = List<String>.from(
            responseJson.values.map((value) => value.toString()));
        print('authStrings: $authStrings');
        final prefsService = SharedPreferencesService();

        await prefsService.saveStringList('jwt', authStrings);
        final user = await UserAPIService.getUser(userId: authStrings[0]);
        if (user != null) {
          userProvider.setUser(user);
          navigator.pop();
        } else {
          print('something went wrong setting user to UserModel');
        }
      } else {
        print('else ${response.statusCode}');
        print('error register code: ${response.statusCode}');
      }
    } catch (e) {
      print('error register: $e');
      // An exception occurred
      throw ('error register: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _Fname.dispose();
    _Lname.dispose();
    _email.dispose();
    _pass.dispose();
    _Cpass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget registerSection = Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                //first name
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _Fname,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                //last name
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _Lname,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                ),
              ],
            ),
            //email
            TextFormField(
              focusNode: focusNode,
              controller: _email,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                    _hasInputError ? "Enter a Valid Email Address" : null,
              ),
              onChanged: (textt) {
                text = textt;
              },
            ),
            //password
            TextFormField(
              controller: _pass,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: InkWell(
                  onTap: _toggle,
                  child: Icon(
                    _obscureText
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 15.0,
                    color: Colors.black,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a password";
                } else if (value.length < 8) {
                  return "Password must be atleast 8 characters long";
                } else {
                  return null;
                }
              },
              obscureText: _obscureText,
            ),
            //confirm password
            TextFormField(
              controller: _Cpass,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please re-enter the password";
                } else if (value != _pass.text) {
                  return "Password do not match";
                } else {
                  return null;
                }
              },
              obscureText: true,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              //input are valid
                              _registerUser();
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
                                'Sign up',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            )
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
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                backButton,
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 300
                      : 700,
                ),
                registerSection,
                const CustomDivider(),
                //const SignIn_Google(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
