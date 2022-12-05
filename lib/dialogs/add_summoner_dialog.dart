import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/snack_bar/custom_snack_bar.dart';
import 'package:league_arena/widgets/snack_bar/top_snack_bar.dart';

import '../widgets/custom_text.dart';

class AddSummoner extends StatefulWidget {
  const AddSummoner({Key? key}) : super(key: key);

  @override
  State<AddSummoner> createState() => _AddSummonerState();
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
          const CustomSnackBar.info(
            message: "This summoner has been linked to another League Arena account!",
          ),
          displayDuration: const Duration(milliseconds: 1500),
        );
        break;
      case 1:
        valid.value = true;
        await userController.getThirdParty(userController.summonerId.value, dropdownValue, userController.iconPicked.value, true) == false ? shuffleIcon() : null;
        break;
      case 2:
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "The name you have entered does't exist in this server!",
          ),
          displayDuration: const Duration(milliseconds: 1500),
        );
        break;
      case 3:
        showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "Something went wrong, Please try again later.",
          ),
          displayDuration: const Duration(milliseconds: 1500),
        );
        break;
    }
    buttonPressed.value = false;
    buttonDisabled.value = false;
  }

  Future<void> checkThirdPartyCode() async {
    await userController.getThirdParty(userController.summonerId.value, dropdownValue, userController.iconPicked.value) == false
        ? showTopSnackBar(
            context,
            const CustomSnackBar.info(
              message: "Please complete the verification step in your League of Legends account to preceed!",
            ),
            displayDuration: const Duration(milliseconds: 1500),
          )
        : await userController.saveSummonerInfo(nameController.value.text, userController.summonerId.value, dropdownValue) == true
            ? [done.value = true, /*userController.updateSummoners(),*/ Navigator.of(context).pop()]
            : showTopSnackBar(
                context,
                const CustomSnackBar.error(
                  message: "Couldn't link Summoner to your account, please try again.",
                ),
                displayDuration: const Duration(milliseconds: 1500),
              );

    buttonPressed.value = false;
    buttonDisabled.value = false;
  }

  void shuffleIcon() {
    userController.iconPicked.value = (userController.iconList..shuffle()).first;
  }

  @override
  void initState() {
    shuffleIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Dialog(
        elevation: 0,
        backgroundColor: hover,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: valid.value == true ? 410 : 300,
          width: 360,
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
                color: card,
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
                          text: 'ADD SUMMONER',
                          size: 25,
                          weight: FontWeight.bold,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: CustomText(
                            text: valid.value == false ? "Enter your League of Legends summoner name" : 'Verify you are the owner of this account',
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
                  ],
                ),
              ),
              SizedBox(
                height: valid.value == false ? 20 : 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    CustomText(
                      text: valid.value == false ? 'Enter your League of Legends summoner name' : '',
                      size: 13,
                      weight: FontWeight.bold,
                    ),
                    //Expanded(child: Container()),
                  ],
                ),
              ),
              SizedBox(
                height: valid.value == false ? 10 : 0,
              ),
              valid.value == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 42,
                          width: 230,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: TextField(
                              onSubmitted: (_) {
                                buttonPressed.value = true;
                                addSummoner();
                              },
                              keyboardType: TextInputType.name,
                              //textInputAction: TextInputAction.done,
                              //autovalidateMode: AutovalidateMode.always,
                              readOnly: done.value ? true : false,
                              onChanged: (value) {
                                if (GetUtils.isLengthGreaterOrEqual(
                                        nameController.value.text, 3) /*&&
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
                              },
                              controller: nameController,
                              style: TextStyle(color: primary, fontFamily: 'Ubuntu'),
                              decoration: InputDecoration(
                                fillColor: hover,
                                filled: true,
                                contentPadding: const EdgeInsets.all(15),
                                hintText: "SUMMONER NAME",
                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                //hintText: "ENTER SUMMONER NAME",
                                hintStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                                labelStyle: TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                                focusedErrorBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent), gapPadding: 0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 42,
                          width: 90,
                          decoration: BoxDecoration(color: hover, borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                underline: Container(color: Colors.transparent),
                                alignment: AlignmentDirectional.topCenter,
                                iconSize: 20,
                                dropdownColor: hover,
                                iconEnabledColor: primary,
                                isDense: true,
                                isExpanded: true,
                                style: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
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
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
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
                                height: 25,
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
                                  height: 84,
                                  width: 84,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: secondary, width: 0.5),
                                  ),
                                  child: Image(
                                    image: AssetImage('assets/image/${userController.iconPicked.value}.png'),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Change your profile icon to the icon above in your League of Legends client",
                                      style: TextStyle(color: primary, fontSize: 15, fontFamily: 'Ubuntu')),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 250,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: done.value == false
                          ? nameValid.value == true
                              ? <Color>[Colors.blue.shade600, Colors.purple]
                              : <Color>[Colors.grey, Colors.grey]
                          : <Color>[Colors.grey, Colors.grey],
                    ),
                  ),
                  child: OutlinedButton(
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
                    style: OutlinedButton.styleFrom(
                        foregroundColor: background,
                        elevation: 0,
                        //primary: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        fixedSize: const Size(250, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
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
                                    text: "ADD SUMMONER",
                                    color: nameValid.value == true ? primary : background,
                                    size: 15,
                                    weight: FontWeight.bold,
                                  )
                            : CustomText(
                                text: "SUCCESS",
                                color: done.value == true ? Colors.greenAccent : secondary,
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
