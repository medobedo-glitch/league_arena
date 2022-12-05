import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
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
          height: 440,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomText(
                    text: 'Choose a characteristic profile picture',
                    size: 13,
                    weight: FontWeight.bold,
                  ),
                  //Expanded(child: Container()),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userController.profilePic.value != ''
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                          child: Container(
                            height: 77,
                            width: 77,
                            decoration: BoxDecoration(
                                //border: Border.all(color: secondary, width: 0),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AdvancedNetworkImage(
                                    userController.profilePic.value,
                                    useDiskCache: true,
                                    cacheRule: const CacheRule(maxAge: Duration(days: 30)),
                                  ),
                                  filterQuality: FilterQuality.medium,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                        child: Container(
                                            alignment: Alignment.center,
                                            height: 77,
                                            width: 77,
                                            decoration: BoxDecoration(
                                                //border: Border.all(color: secondary, width: 0),
                                                shape: BoxShape.circle,
                                                color: hover),
                                            child: CustomText(
                                              text: userController.displayname.value != '' ? userController.displayname.value[0].toUpperCase() : 'S',
                                              weight: FontWeight.bold,
                                              size: 50,
                                            ),
                                          ),
                      ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        colors: userController.uploadingPic.value == false ? <Color>[Colors.blue.shade600, Colors.purple] : <Color>[Colors.grey, Colors.grey],
                      ),
                    ),
                    child: OutlinedButton(
                      onPressed: userController.uploadingPic.value == false
                          ? () async {
                              await userController.updateProfilePic(await userController.uplaodPic(context));
                            }
                          : null,
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.transparent,
                          elevation: 0,
                          //primary: Colors.transparent,
                          //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          fixedSize: const Size(100, 30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                      child: userController.uploadingPic.value == true
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : CustomText(
                              text: "CHANGE",
                              color: primary,
                              size: 13,
                              weight: FontWeight.bold,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomText(
                    text: 'Define your name across our platform',
                    size: 13,
                    weight: FontWeight.bold,
                  ),
                  //Expanded(child: Container()),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 42,
                width: 300,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*')),
                  ],
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
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
                  onFieldSubmitted: (_) async {
                    buttonPressed.value = true;
                    await userController.updateDisplayName(nameController.value.text.trim())
                        ? [buttonPressed.value = false, Navigator.of(context).pop()]
                        : [
                            showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message: "An Error has occured, Couldn't update display name please try again later.",
                                )),
                            buttonPressed.value = false
                          ];
                  },
                  controller: nameController,
                  maxLength: 16,
                  style: TextStyle(color: primary, fontFamily: 'Ubuntu'),
                  decoration: InputDecoration(
                    fillColor: hover,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    counterText: '',
                    hintText: "DISPLAY NAME",
                    //hintText: "MUST BE 3 CHARACTERS AT LEAST (a-z, A-Z, 0-9)",
                    hintStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                    labelStyle: TextStyle(color: secondary, fontSize: 12, fontFamily: 'Ubuntu'),
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

              const SizedBox(
                height: 15,
              ),
              //
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: nameValid.value == true ? <Color>[Colors.blue.shade600, Colors.purple] : <Color>[Colors.grey, Colors.grey],
                  ),
                ),
                child: OutlinedButton(
                  onPressed: nameValid.value == true
                      ? () async {
                          buttonPressed.value = true;
                          await userController.updateDisplayName(nameController.value.text.trim())
                              ? [buttonPressed.value = false, Navigator.of(context).pop()]
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
                      fixedSize: const Size(150, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                  child: buttonPressed.value == true
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : CustomText(
                          text: "CONFIRM",
                          color: nameValid.value == true ? primary : background,
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
