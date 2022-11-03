import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/snack_bar/custom_snack_bar.dart';
import 'package:league_arena/widgets/snack_bar/top_snack_bar.dart';

import '../widgets/custom_text.dart';

class SetDisplayName extends StatefulWidget {
  const SetDisplayName({Key? key}) : super(key: key);

  @override
  State<SetDisplayName> createState() => _SetDisplayNameState();
}

class _SetDisplayNameState extends State<SetDisplayName> {
  var nameValid = false.obs;
  var urlValid = false.obs;
  var buttonPressed = false.obs;

  final nameController = TextEditingController(text: userController.displayname.value);
  final profilePicController = TextEditingController(text: userController.profilePic.value);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Dialog(
        backgroundColor: card,
        // shape:
        //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Container(
          height: 400,
          width: 360,
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
                    text: 'ACCOUNT INFO',
                    size: 25,
                    weight: FontWeight.bold,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: CustomText(
                      text: "Your League Arena account information",
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
                      text: 'Define your name across our platform',
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
              SizedBox(
                height: 42,
                width: 330,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*')),
                  ],
                  keyboardType: TextInputType.name,
                  //textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (GetUtils.isLengthGreaterOrEqual(nameController.value.text, 3)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        nameValid.value = true;
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        nameValid.value = false;
                      });
                    }
                    return null;
                  },
                  controller: nameController,
                  maxLength: 16,
                  style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                    color: primary,
                  )),
                  decoration: InputDecoration(
                    fillColor: hover,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    counterText: '',
                    hintText: "DISPLAY NAME",
                    //hintText: "MUST BE 3 CHARACTERS AT LEAST (a-z, A-Z, 0-9)",
                    hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold)),
                    labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: const [
                    CustomText(
                      text: 'Choose a characteristic profile picture',
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
              SizedBox(
                height: 64,
                width: 330,
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  //textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (GetUtils.isURL(profilePicController.value.text) || profilePicController.value.text == '') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        urlValid.value = true;
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        urlValid.value = false;
                      });
                    }
                    return null;
                  },
                  controller: profilePicController,
                  style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary)),
                  decoration: InputDecoration(
                    fillColor: hover,
                    filled: true,
                    errorText: urlValid.value == false && profilePicController.value.text != '' ? 'Must be a valid URL' : '',
                    errorStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    counterText: '',
                    hintText: "PROFILE PICTURE LINK",
                    //hintText: "MUST BE 3 CHARACTERS AT LEAST (a-z, A-Z, 0-9)",
                    hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold)),
                    labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 12)),
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
              //
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: nameValid.value == true && urlValid.value == true ? <Color>[Colors.blue.shade600, Colors.purple] : <Color>[Colors.grey, Colors.grey],
                  ),
                ),
                child: OutlinedButton(
                  onPressed: nameValid.value == true && urlValid.value == true
                      ? () async {
                          buttonPressed.value = true;
                          await userController.updateDisplayName(nameController.value.text.trim())
                              ? await userController.updateProfilePic(profilePicController.value.text.trim())
                                  ? [Navigator.of(context).pop()]
                                  : [
                                      showTopSnackBar(
                                        context,
                                        const CustomSnackBar.error(
                                          message: "An Error has occured, Couldn't update profile picture please try again later.",
                                        ),
                                      ),
                                      buttonPressed.value = false
                                    ]
                              : [
                                  showTopSnackBar(
                                      context,
                                      const CustomSnackBar.error(
                                        message: "An Error has occured, Couldn't update display name please try again later.",
                                      )),
                                  buttonPressed.value = false
                                ];
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.transparent,
                      elevation: 0,
                      //primary: Colors.transparent,
                      //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      fixedSize: const Size(250, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      textStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                  child: buttonPressed.value == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : CustomText(
                          text: "CONFIRM INFORMATION",
                          color: nameValid.value == true && urlValid.value == true ? primary : background,
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                ),
              ),
              //
            ],
          ),
        )));
  }
}
