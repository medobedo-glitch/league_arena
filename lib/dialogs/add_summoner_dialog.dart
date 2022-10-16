import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/snack_bar/custom_snack_bar.dart';
import 'package:league_arena/widgets/snack_bar/top_snack_bar.dart';

import '../widgets/custom_text.dart';

class AddSummoner extends StatefulWidget {
  const AddSummoner({Key? key}) : super(key: key);

  @override
  _AddSummonerState createState() => _AddSummonerState();
}

class _AddSummonerState extends State<AddSummoner> {
  var nameValid = false.obs;
  var buttonPressed = false.obs;
  var done = false.obs;
  var valid = false.obs;
  var buttonDisabled = false.obs;
  final nameController = TextEditingController();
  //static final validCharacters = RegExp(r'^[a-zA-Z0-9- ]+$');
  String dropdownValue = 'EUNE';

  Future<void> addSummoner() async {
    switch (await userController.getSummonerId(nameController.value.text, dropdownValue)) {
      case 0:
        showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "Summoner has been linked to another League Arena account!",
          ),
          displayDuration: const Duration(milliseconds: 1500),
        );
        break;
      case 1:
        valid.value = true;
        break;
      case 2:
        showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "Summoner name could not be found!",
          ),
          displayDuration: const Duration(milliseconds: 1500),
        );
        break;
    }
    buttonPressed.value = false;
    buttonDisabled.value = false;
  }

  Future<void> checkThirdPartyCode() async {
    switch (await userController.getThirdParty(userController.summonerId.value, dropdownValue)) {
      case 0:
        showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "Please complete the verification step in your League of Legends account settings to preceed!",
          ),
          displayDuration: const Duration(milliseconds: 1500),
        );
        break;
      case 1:
        if (userController.thirdPartyCodeIn.value == userController.thirdPartyCodeOut.value) {
          await userController.saveSummonerInfo(nameController.value.text, userController.summonerId.value, dropdownValue) == true
              ? [done.value = true, userController.updateSummoners(), Navigator.of(context).pop()]
              : showTopSnackBar(
                  context,
                  const CustomSnackBar.error(
                    message: "Couldn't link Summoner to your account, please try again.",
                  ),
                  displayDuration: const Duration(milliseconds: 1500),
                );
        } else {
          showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: "Verification Code isn't correct or Verfication hasn't been completed!",
            ),
            displayDuration: const Duration(milliseconds: 1500),
          );
        }
        break;
    }
    buttonPressed.value = false;
    buttonDisabled.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Dialog(
        elevation: 2,
        backgroundColor: hover,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: valid.value == true ? 370 : 320,
          width: 380,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(10.0),
            border: /*Border(
                top: BorderSide(color: primary),
                bottom: BorderSide(color: primary)),*/
                Border.all(color: hover, width: 0.5),
            color: card,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: background),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close_sharp),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          color: secondary,
                          splashRadius: 1,
                        )
                      ],
                    ),
                    //Container(width: 280, color: secondary, height: 1,),
                    Container(
                      height: 30,
                      width: 190,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            text: 'ADD SUMMONER',
                            size: 20,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: valid.value == true ? 'Please complete the verification step...' : 'You will have to verify account ownership!',
                      size: 13,
                      weight: FontWeight.bold,
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   height: 1,
                    //   width: 350,
                    //   color: secondary,
                    // ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(
                height: valid.value == false ? 20 : 0,
              ),
              CustomText(
                text: valid.value == false ? 'Please enter a valid summoner name...' : '',
                size: 13,
                weight: FontWeight.bold,
              ),
              SizedBox(
                height: valid.value == false ? 10: 5,
              ),
              valid.value == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 220,
                          child: TextFormField(
                            onFieldSubmitted: (_) {
                              buttonPressed.value = true;
                              addSummoner();
                            },
                            keyboardType: TextInputType.name,
                            //textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.always,
                            readOnly: done.value ? true : false,
                            validator: (value) {
                              if (GetUtils.isLengthGreaterOrEqual(nameController.value.text, 3) /*&&
                        validCharacters.hasMatch(nameController.value.text)*/
                                  ) {
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
                            style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary)),
                            decoration: InputDecoration(
                              counterStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary)),
                              labelText: "Summoner Name",
                              hintText: "Valid Summoner Name...",
                              hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14)),
                              labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 14)),
                              enabledBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                              borderSide: BorderSide(color: primary)),
                              focusedBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                              borderSide: BorderSide(color: primary)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: DropdownButtonFormField(
                              alignment: AlignmentDirectional.topCenter,
                              iconSize: 20,
                              dropdownColor: card,
                              style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 15)),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                                borderSide: BorderSide(color: primary)),
                                enabledBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                                borderSide: BorderSide(color: primary)),
                              ),
                              value: dropdownValue,
                              items: <String>['EUNE', 'EUW'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: nameController.value.text,
                              size: 25,
                              weight: FontWeight.bold,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(color: hover, borderRadius: BorderRadius.circular(4)),
                              child: CustomText(
                                text: dropdownValue,
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 180,
                              decoration: BoxDecoration(
                                color: hover,
                              ),
                              child: CustomText(
                                text: userController.thirdPartyCodeIn.value,
                                size: 35,
                                weight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: primary),
                                color: hover,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "COPY",
                                        style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 20, fontWeight: FontWeight.bold)),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Clipboard.setData(ClipboardData(text: userController.thirdPartyCodeIn.value));
                                          }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Copy the Verification Code above, go to League of Legends CLIENT > SETTINGS > VERIFICATION then paste the verification code and save.",
                                    style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 15))),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

              const SizedBox(
                height: 15,
              ),
              //
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: <Color>[Colors.blue.shade600, Colors.purple],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: done.value == false
                      ? buttonDisabled.value == false
                          ? nameValid.value == true && valid.value == true
                              ? () async {
                                  buttonPressed.value = true;
                                  buttonDisabled.value = true;
                                  checkThirdPartyCode();
                                }
                              : nameValid.value == true
                                  ? () async {
                                      buttonDisabled.value = true;
                                      buttonPressed.value = true;
                                      addSummoner();
                                    }
                                  : null
                          : null
                      : null,
                  child: buttonPressed.value == true && done.value == false
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : done.value == false
                          ? valid.value == true
                              ? CustomText(
                                  text: "CONFIRM VERIFICATION",
                                  color: primary,
                                  size: 15,
                                  weight: FontWeight.bold,
                                )
                              : CustomText(
                                  text: "CHECK SUMMONER",
                                  color: nameValid.value == true ? primary : secondary,
                                  size: 15,
                                  weight: FontWeight.bold,
                                )
                          : CustomText(
                              text: "SUCCESS",
                              color: done.value == true ? Colors.greenAccent : secondary,
                              size: 15,
                              weight: FontWeight.bold,
                            ),
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      primary: Colors.transparent,
                      //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      fixedSize: const Size(250, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      textStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                ),
              ),
              //
              // const SizedBox(
              //   height: 20,
              // ),

              // Container(
              //   alignment: Alignment.center,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //           EvaIcons.alertCircle,
              //           color: secondary,
              //           size: 15,
              //         ),
              //         const SizedBox(width: 3,),
              //       const CustomText(
              //         text: 'Tap anywhere outside this dialog to dismiss',
              //         size: 10,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        )));
  }
}
