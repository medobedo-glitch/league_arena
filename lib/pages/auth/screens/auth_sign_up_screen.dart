import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:routemaster/routemaster.dart';

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({Key? key}) : super(key: key);

  @override
  _AuthRegisterScreenState createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _buttonPressed = false;
  //bool _isgoingtoverify = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //String? email;

  // @override
  // void initState() {
  //   // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   // _prefs.then((SharedPreferences prefs) {
  //   //   email = prefs.getString('userEmail');
  //   // });
  //   userController.doInit();
  //   super.initState();
  // }

  // void checkUser() {
  //   if (authController.user != null) {
  //     if (!_isgoingtoverify) {
  //       WidgetsBinding.instance!.addPostFrameCallback((_) {
  //         Routemaster.of(context).push(rootRoute);
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //checkUser();
    double _height = MediaQuery.of(context).size.height;
    //setPageTitle(authPageRegisterDisplyName, context);
    return Obx(() => userController.uID.value != ''
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text:
                                "Invalid Request!\n A user is already Signed In to the website.",
                            style: GoogleFonts.ubuntu(
                                textStyle:
                                    TextStyle(color: primary, fontSize: 20))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "RETURN TO HOME SCREEN",
                            style: GoogleFonts.ubuntu(
                                textStyle: const TextStyle(color: Colors.blue)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Routemaster.of(context).pop(rootRoute);
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/image/bg3.jpg",
                      ),
                      fit: BoxFit.cover)),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(15),
                            color: card,
                          ),
                          constraints: const BoxConstraints(maxWidth: 400),
                          padding: const EdgeInsets.all(24),
                          margin: EdgeInsets.only(top: _height / 27),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: _height / 30),
                                    child: Image.asset(
                                      "assets/icon/logo2.png",
                                      scale: 6,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "SIGN UP",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: primary)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    text: "Sign Up a new League Arena account.",
                                    color: secondary,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (value) {
                                  if (GetUtils.isEmail(
                                      emailController.value.text)) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        _emailValid = true;
                                      });
                                    });
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        _emailValid = false;
                                      });
                                    });
                                  }
                                  return null;
                                },
                                controller: emailController,
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(color: primary)),
                                decoration: InputDecoration(
                                  labelText: "EMAIL",
                                  hintText: "MUST BE A VALID EMAIL ADDRESS",
                                  hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          color: secondary, fontSize: 10)),
                                  labelStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(color: secondary)),
                                  enabledBorder: OutlineInputBorder(
                                      //borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: primary)),
                                  focusedBorder: OutlineInputBorder(
                                      //borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: primary)),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              
                              TextFormField(
                                onFieldSubmitted: _emailValid == true &&
                                        _passwordValid == true
                                    ? (_) async {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            _buttonPressed = true;
                                            //_isgoingtoverify = true;
                                          });
                                        });
                                        await authController.createUser(
                                                emailController.value.text,
                                                passwordController.value.text,
                                                context)
                                            ? null
                                            : WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                setState(() {
                                                  _buttonPressed = false;
                                                });
                                              });
                                      }
                                    : null,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (value) {
                                  if (GetUtils.isLengthGreaterOrEqual(
                                      passwordController.value.text, 6)) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        _passwordValid = true;
                                      });
                                    });
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        _passwordValid = false;
                                      });
                                    });
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(color: primary)),
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "PASSWORD",
                                  hintText: "MUST BE 6 CHARACTERS AT LEAST",
                                  hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          color: secondary, fontSize: 10)),
                                  labelStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(color: secondary)),
                                  enabledBorder: OutlineInputBorder(
                                    //borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      //borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: primary)),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // children: [
                                //   Row(
                                //     children: [
                                //       Checkbox(
                                //         side: const BorderSide(color: Colors.grey, width: 1.5,),
                                //         value: false, onChanged: (value) {}),
                                //       const CustomText(text: "Remember Me"),
                                //     ],
                                //   ),
                                //   const CustomText(
                                //     text: "FORGOT PASSWORD?",
                                //     color: Colors.blue,
                                //     size: 12,
                                //   ),
                                // ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              Container(
                                decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            gradient: LinearGradient(
                                              colors: <Color>[Colors.blue.shade600, Colors.purple],
                                            ),
                                          ),
                                child: ElevatedButton(
                                  onPressed: _emailValid == true &&
                                          _passwordValid == true
                                      ? () async {
                                          // final Map<String, dynamic> data = await postHelper(loginUrl, {"email" : emailController.value.text, "password" : passwordController.value.text});
                                          // if (data["user"] != null){
                                          //   print(data["user"]["id"]);
                                          //   print(data["user"]["email"]);
                                          // }
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              _buttonPressed = true;
                                              //_isgoingtoverify = true;
                                            });
                                          });
                                          await authController.createUser(
                                                  emailController.value.text,
                                                  passwordController.value.text,
                                                  context)
                                              ? null
                                              : WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                  setState(() {
                                                    _buttonPressed = false;
                                                  });
                                                });
                                        }
                                      : null,
                                  child: _buttonPressed
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : CustomText(
                                          text: "SIGN UP",
                                          color: _emailValid == true &&
                                                  _passwordValid == true
                                              ? primary
                                              : secondary,
                                          size: 20,
                                          weight: FontWeight.bold,
                                        ),
                                  style: ElevatedButton.styleFrom(
                                      //primary: Colors.purple,
                                      //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      primary: Colors.transparent,
                                      fixedSize: const Size(350, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      textStyle: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),

                              // InkWell(
                              //   onTap: () {
                              //   },
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         color: Colors.blue,
                              //         borderRadius: BorderRadius.circular(30)),
                              //     alignment: Alignment.center,
                              //     width: double.maxFinite,
                              //     padding: const EdgeInsets.symmetric(vertical: 16),
                              //     child: const CustomText(
                              //       text: "Login",
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),

                              const SizedBox(
                                height: 15,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "- OR -",
                                        style: GoogleFonts.ubuntu(
                                            textStyle:
                                                TextStyle(color: primary, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "RETURN TO HOME SCREEN",
                                        style: GoogleFonts.ubuntu(
                                            textStyle: const TextStyle(
                                                color: Colors.blue)),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Routemaster.of(context)
                                                .push(homeScreenRoute);
                                          }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            "League Arena was created under Riot Games ''Legal Jibber Jabber'' policy using assets owned by Riot Games.\nRiot Games does not endorse or sponsor this project.",
                                        style: GoogleFonts.ubuntu(
                                            textStyle:
                                                TextStyle(color: secondary))),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "© 2021 League Arena.",
                                        style: GoogleFonts.ubuntu(
                                            textStyle:
                                                TextStyle(color: primary))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}
