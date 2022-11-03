import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class SignUpDialogue extends StatefulWidget {
  const SignUpDialogue({Key? key}) : super(key: key);

  @override
  State<SignUpDialogue> createState() => _SignUpDialogueState();
}

class _SignUpDialogueState extends State<SignUpDialogue> {
  var emailValid = false.obs;
  var passwordValid = false.obs;
  var repeatPasswordValid = false.obs;
  var buttonPressed = false.obs;

  var passwordVisible = false.obs;
  var passwordVisible2 = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  FocusNode focusNode1 = FocusNode();

  ScrollController sc1 = ScrollController();

  bool checkPasswordMatching() {
    if (repeatPasswordController.value.text == passwordController.value.text) {
      return true;
    }
    return false;
  }

  int giveExtraHeight() {
    var extra = 0.obs;

    if (!(checkPasswordMatching() == true || repeatPasswordController.value.text == '')) {
      extra.value += 20;
    }

    if (!(emailValid.value == true || emailController.value.text == '')) {
      extra.value += 20;
    }

    if (!(passwordValid.value == true || passwordController.value.text == '')) {
      extra.value += 20;
    }

    return extra.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Dialog(
        backgroundColor: card,
        // shape:
        //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: SizedBox(
          height: giveExtraHeight() + 430,
          width: 360,
          child: Container(
            decoration: BoxDecoration(
              border: /*Border(
                  top: BorderSide(color: primary),
                  bottom: BorderSide(color: primary)),*/
                  Border.all(color: hover, width: 0.5),
              //borderRadius: BorderRadius.circular(30.0),
              color: card,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3), color: background.withOpacity(0.8), border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close_outlined),
                          padding: const EdgeInsets.all(5),
                          constraints: const BoxConstraints(),
                          color: primary,
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'SIGN UP',
                      size: 25,
                      weight: FontWeight.bold,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: CustomText(
                        text: "Sign Up a new League Arena account",
                        size: 14,
                      ),
                    ),
                    Container(
                      width: 320,
                      height: 0.5,
                      color: secondary,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: const [
                      CustomText(
                        text: 'Use valid information for your account',
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      //Expanded(child: Container()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                //
                SizedBox(
                  height: (emailValid.value == true || emailController.value.text == '') ? 40 : 64,
                  width: 330,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (GetUtils.isEmail(emailController.value.text)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            emailValid.value = true;
                          });
                        });
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            emailValid.value = false;
                          });
                        });
                      }
                      return null;
                    },
                    controller: emailController,
                    style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary)),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      fillColor: hover,
                      filled: true,
                      hintText: "EMAIL",
                      errorText: (emailValid.value == true || emailController.value.text == '') ? null : 'MUST BE A VALID EMAIL ADDRESS!',
                      //errorStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      //hintText: "MUST BE A VALID EMAIL ADDRESS",
                      hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold)),
                      labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: passwordValid.value == true || passwordController.value.text == '' ? 40 : 64,
                  width: 330,
                  child: TextFormField(
                    onEditingComplete: () {
                      // Move the focus to the next node explicitly.
                      FocusScope.of(context).requestFocus(focusNode1);
                    },
                    // onFieldSubmitted: emailValid.value == true && passwordValid.value == true
                    //     ? (_) async {
                    //         WidgetsBinding.instance.addPostFrameCallback((_) {
                    //           setState(() {
                    //             buttonPressed.value = true;
                    //             //_isgoingtoverify = true;
                    //           });
                    //         });
                    //         await authController.createUser(emailController.value.text, passwordController.value.text, context)
                    //             ? null
                    //             : WidgetsBinding.instance.addPostFrameCallback((_) {
                    //                 setState(() {
                    //                   buttonPressed.value = false;
                    //                 });
                    //               });
                    //       }
                    //     : null,
                    autovalidateMode: AutovalidateMode.always,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (GetUtils.isLengthGreaterOrEqual(passwordController.value.text, 6)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            checkPasswordMatching();
                            passwordValid.value = true;
                          });
                        });
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            checkPasswordMatching();
                            passwordValid.value = false;
                          });
                        });
                      }
                      return null;
                    },
                    controller: passwordController,
                    style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary)),
                    obscureText: passwordVisible.value == true ? false : true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      fillColor: hover,
                      filled: true,
                      hintText: "PASSWORD",
                      //hintText: "MUST BE 6 CHARACTERS AT LEAST",
                      errorText: passwordValid.value == true || passwordController.value.text == '' ? null : 'PASSWORD HAS TO BE 6 CHARACTERS AT LEAST!',
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
                      hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold)),
                      labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                SizedBox(
                  height: (checkPasswordMatching() == true || repeatPasswordController.value.text == '') ? 40 : 64,
                  width: 330,
                  child: TextFormField(
                    onFieldSubmitted: emailValid.value == true && passwordValid.value == true && checkPasswordMatching() == true
                        ? (_) async {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                buttonPressed.value = true;
                                //_isgoingtoverify = true;
                              });
                            });
                            await authController.createUser(emailController.value.text, passwordController.value.text, context)
                                ? Navigator.of(context).pop()
                                : WidgetsBinding.instance.addPostFrameCallback((_) {
                                    setState(() {
                                      buttonPressed.value = false;
                                    });
                                  });
                          }
                        : null,
                    autovalidateMode: AutovalidateMode.always,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (checkPasswordMatching() == true) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            repeatPasswordValid.value = true;
                          });
                        });
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            repeatPasswordValid.value = false;
                          });
                        });
                      }
                      return null;
                    },
                    controller: repeatPasswordController,
                    focusNode: focusNode1,
                    style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary)),
                    obscureText: passwordVisible2.value == true ? false : true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      fillColor: hover,
                      filled: true,
                      hintText: "REPEAT PASSWORD",
                      errorText: (checkPasswordMatching() == true || repeatPasswordController.value.text == '') ? null : 'PASSWORDS DOES NOT MATCH!',
                      //hintText: "MUST BE 6 CHARACTERS AT LEAST",
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.only(right: 10),
                        icon: passwordVisible2.value == true
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
                          passwordVisible2.value == true ? passwordVisible2.value = false : passwordVisible2.value = true;
                        },
                        splashRadius: 1,
                      ),
                      //errorStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold)),
                      labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    ),
                  ),
                ),
                SizedBox(
                  height: (checkPasswordMatching() == true || repeatPasswordController.value.text == '') ? 40 : 30,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: emailValid.value == true && passwordValid.value == true && checkPasswordMatching() == true ? 
                      <Color>[Colors.blue.shade600, Colors.purple] : 
                      <Color>[Colors.grey, Colors.grey],
                    ),
                  ),
                  child: OutlinedButton(
                    onPressed: emailValid.value == true && passwordValid.value == true && checkPasswordMatching() == true
                        ? () async {
                            // final Map<String, dynamic> data = await postHelper(loginUrl, {"email" : emailController.value.text, "password" : passwordController.value.text});
                            // if (data["user"] != null){
                            //   print(data["user"]["id"]);
                            //   print(data["user"]["email"]);
                            // }
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                buttonPressed.value = true;
                                //_isgoingtoverify = true;
                              });
                            });
                            await authController.createUser(emailController.value.text, passwordController.value.text, context)
                                ? null
                                : WidgetsBinding.instance.addPostFrameCallback((_) {
                                    setState(() {
                                      buttonPressed.value = false;
                                    });
                                  });
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                        //primary: Colors.purple,
                        //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        foregroundColor: background,
                        elevation: 0,
                        //primary: Colors.transparent,
                        fixedSize: const Size(250, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    child: buttonPressed.value
                        ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                        )
                        : CustomText(
                            text: "SIGN UP",
                            color: emailValid.value == true && passwordValid.value == true && checkPasswordMatching() == true ? primary : background,
                            size: 20,
                            weight: FontWeight.bold,
                          ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
