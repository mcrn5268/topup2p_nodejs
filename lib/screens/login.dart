import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topup2p_nodejs/api/auth_api.dart';
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/providers/user_provider.dart';
import 'package:topup2p_nodejs/screens/forgot_password.dart';
import 'package:topup2p_nodejs/screens/register.dart';
import 'package:topup2p_nodejs/utilities/sharedpreference.dart';
import 'package:topup2p_nodejs/widgets/custom_divider.dart';
import 'package:topup2p_nodejs/widgets/google_signin.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  UserProvider? userProvider;
  String? _errorText;
  String? _errorText2;
  bool _isLoading = false;

//temporary
  @override
  void initState() {
    super.initState();
    _email.text = 'johnsmith@johnsmith.com';
    _pass.text = 'johnsmith6969';
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
    // Get the user's email and password from the text fields
    String email = _email.text;
    String password = _pass.text;

    final response =
        await AuthAPIService.login(email: email, password: password);

    if (response.statusCode == 200) {
      // User logged in successfully
      print('login 200');
      final responseJson = jsonDecode(response.body);
      //index - value
      //0 - uid
      //1 - jwt token
      List<String> authStrings = List<String>.from(
          responseJson.values.map((value) => value.toString()));
      final prefsService = SharedPreferencesService();

      await prefsService.saveStringList('jwt', authStrings);
      final user = await UserAPIService.getUser(userId: authStrings[0]);
      if (user != null) {
        userProvider!.setUser(user);
      } else {
        print('something went wrong setting user to UserModel');
      }
    } else {
      final message = json.decode(response.body)['message'];
      print('error message: $message');
      if (message == 'Wrong password') {
        _errorText2 = message;
      } else if (message == 'There is no account registered for this email') {
        _errorText = message;
      } else {
        _errorText2 = 'Something went wrong';
        _errorText = 'Something went wrong';
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget loginSection = Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            //email
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _errorText,
              ),
              onChanged: (textt) {
                //if there was an error and the user changed the text
                //remove the errortext
                setState(() {
                  _errorText = null;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter an email";
                } else {
                  return null;
                }
              },
            ),
            //password
            TextFormField(
              controller: _pass,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorText2,
              ),
              onChanged: (textt) {
                //if there was an error and the user changed the text
                //remove the errortext
                setState(() {
                  _errorText2 = null;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a password";
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
                              _loginUser();
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
                                'Sign in',
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

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 15),
                children: [
                  TextSpan(
                    text: 'Forgot password?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => const ForgotPasswordScreen(),
              //     transitionsBuilder: (_, a, __, c) =>
              //         FadeTransition(opacity: a, child: c),
              //   ),
              // );
            },
          ),
        ],
      ),
    );

    //don't have an account? sign up
    Widget signupSection = Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 15),
                text: "Don't have an account?",
                children: [
                  TextSpan(
                    text: ' Sign up ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const RegisterScreen(),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ),
              );
              //MaterialPageRoute(builder: (context) => const SecondRoute()),
            },
          ),
        ],
      ),
    );
    //skip to main page -- to show games list
    Widget skipButton = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Colors.transparent),
          ),
          onPressed: () {
            //todo
            // Navigator.pushReplacement(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (_, __, ___) => const MainPage(),
            //     transitionsBuilder: (_, a, __, c) =>
            //         FadeTransition(opacity: a, child: c),
            //   ),
            // );
          },
          child: Row(
            children: const <Widget>[
              Text(
                'Skip',
              ),
              Icon(Icons.arrow_forward_ios_outlined)
            ],
          ),
        )
      ],
    );
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                skipButton,
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 300
                      : 700,
                ),
                loginSection,
                forgotPassword,
                const CustomDivider(),
                //const SignIn_Google(),
                signupSection,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
