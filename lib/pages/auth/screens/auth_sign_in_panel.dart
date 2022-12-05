import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/dialogs/reset_password_dialog.dart';
import 'package:league_arena/dialogs/sign_up_dialog.dart';
import 'package:league_arena/widgets/custom_text.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({Key? key}) : super(key: key);

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final _emailValid = false.obs;
  final _passwordValid = false.obs;
  final _buttonPressed = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var passwordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    if (userController.uID.value != '') {
      emailController.clear();
      passwordController.clear();
      _buttonPressed.value = false;
    }

    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                //textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(text: "SIGN IN", style: TextStyle(color: primary, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            //textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(text: "Sign In to your League Arena account", style:TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 42,
                width: 260,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (GetUtils.isEmail(emailController.value.text)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _emailValid.value = true;
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _emailValid.value = false;
                      });
                    }
                  },
                  controller: emailController,
                  style: TextStyle(color: primary, fontSize: 15, fontFamily: 'Ubuntu'),
                  decoration: InputDecoration(
                    fillColor: hover,
                    filled: true,
                    hintText: "EMAIL",
                    contentPadding: const EdgeInsets.all(15),
                    //floatingLabelBehavior: FloatingLabelBehavior.never,
                    //hintText: "MUST BE A VALID EMAIL ADDRESS",
                    hintStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                    labelStyle: TextStyle(color: secondary, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 42,
                width: 260,
                child: TextField(
                  onSubmitted: _emailValid.value == true && _passwordValid.value == true
                      ? (_) async {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _buttonPressed.value = true;
                            });
                          });
                          await authController.login(emailController.value.text, passwordController.value.text, context)
                              ? null
                              : WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    _buttonPressed.value = false;
                                  });
                                });
                        }
                      : null,
                  onChanged: (value) {
                    if (GetUtils.isLengthGreaterOrEqual(passwordController.value.text, 6)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _passwordValid.value = true;
                        });
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _passwordValid.value = false;
                        });
                      });
                    }
                  },
                  controller: passwordController,
                  style: TextStyle(color: primary, fontSize: 15, fontFamily: 'Ubuntu'),
                  obscureText: passwordVisible.value == true ? false : true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    filled: true,
                    fillColor: hover,
                    hintText: "PASSWORD",
                    //floatingLabelBehavior: FloatingLabelBehavior.never,
                    //hintText: "MUST BE 6 CHARACTERS AT LEAST",
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(right: 10),
                      icon: passwordVisible.value == true
                          ? Icon(
                              Icons.visibility_outlined,
                              size: 20,
                              color: primary,
                            )
                          : Icon(
                              Icons.visibility_off_outlined,
                              size: 20,
                              color: primary,
                            ),
                      onPressed: () {
                        passwordVisible.value == true ? passwordVisible.value = false : passwordVisible.value = true;
                      },
                      splashRadius: 1,
                    ),
                    hintStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                    labelStyle: TextStyle(color: secondary, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Tooltip(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                  waitDuration: const Duration(milliseconds: 200),
                  textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
                  message: 'Signed In users are saved and remembered automatically,\nYou will need to sign out manually.',
                  child: Row(
                    children: [
                      Icon(
                        EvaIcons.alertCircle,
                        color: secondary,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const CustomText(
                        text: "YOU WILL STAY SIGNED IN",
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: _emailValid.value == true && _passwordValid.value == true ? <Color>[Colors.blue.shade600, Colors.purple] : <Color>[Colors.grey, Colors.grey],
                  ),
                ),
                width: 260,
                height: 40,
                child: OutlinedButton(
                  onPressed: _emailValid.value == true && _passwordValid.value == true
                      ? () async {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _buttonPressed.value = true;
                            });
                          });
                          await authController.login(emailController.value.text, passwordController.value.text, context)
                              ? null
                              : WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    _buttonPressed.value = false;
                                  });
                                });
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: background,
                      elevation: 0,
                      //primary: Colors.transparent,
                      //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      textStyle:const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                  child: _buttonPressed.value == true
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : CustomText(
                          text: "SIGN IN",
                          color: _emailValid.value == true && _passwordValid.value == true ? primary : background,
                          size: 17,
                          weight: FontWeight.bold,
                        ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: _emailValid.value == true
                    ? () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => ResetPasswordDialog(
                                  email: emailController.value.text,
                                ));
                        //await authController.passwordReset(emailController.value.text, context);
                      }
                    : null,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "FORGOT PASSWORD?",
                        style: TextStyle(color: _emailValid.value == true ? Colors.blue : secondary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontFamily: 'Ubuntu'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const CustomText(
                text: '- OR -',
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: <Color>[Colors.blue.shade600, Colors.purple],
                  ),
                ),
                width: 260,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const SignUpDialog());
                      });
                    });
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: background,
                      elevation: 0,
                      fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                  child: CustomText(
                    text: "CREATE ACCOUNT",
                    color: primary,
                    size: 15,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
