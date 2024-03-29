// signin_page.dart

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Custom_classes/auth_service.dart';

import 'pages/home_page.dart';

class AuthenticateSolo1Widget extends StatefulWidget {
  const AuthenticateSolo1Widget({Key? key}) : super(key: key);

  @override
  _AuthenticateSolo1WidgetState createState() =>
      _AuthenticateSolo1WidgetState();
}

class _AuthenticateSolo1WidgetState extends State<AuthenticateSolo1Widget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final emailAddressLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();
  bool passwordLoginVisibility = true;
  bool isLoading = false;

  Future<void> handleLogin() async {
    // Retrieve user inputs
    final email = emailAddressLoginController.text;
    final password = passwordLoginController.text;

    setState(() {
      isLoading = true;
    });

    final success = await AuthService().login(email, password);

    setState(() {
      isLoading = false;
    });
    FocusScope.of(context).unfocus();

    if (success) {
      
      // Navigate to homepage with access token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            accessToken: AuthService().accessToken,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed. Please check your credentials.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/homepageimg.jpg'),
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 300,
                    height: 450,
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bookmie.com",
                                style: TextStyle(
                                  fontSize: 29,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF59B15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: emailAddressLoginController,
                            obscureText: false,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                color: Color(0xffdedddb),
                                fontSize: 18,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFF59B15),
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xffdedddb),
                              fontSize: 18,
                            ),
                            maxLines: null,
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: passwordLoginController,
                            obscureText: passwordLoginVisibility,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Color(0xffdedddb),
                                fontSize: 18,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordLoginVisibility =
                                        !passwordLoginVisibility;
                                  });
                                },
                                child: Icon(
                                  passwordLoginVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: const Color(0xffdedddb),
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFF59B15),
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xffdedddb),
                              fontSize: 18,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: () async {
                              handleLogin();
                              
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(230, 30),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextButton(
                            onPressed: () {
                              // Navigate to the forgot password screen
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (isLoading)
                            Container(
                              height: 50.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFF59B15),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
