import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';

import '../widgets/custom_text.dart';

class SetDisplayName extends StatefulWidget {
  const SetDisplayName({Key? key}) : super(key: key);

  @override
  _SetDisplayNameState createState() => _SetDisplayNameState();
}

class _SetDisplayNameState extends State<SetDisplayName> {
  var nameValid = false.obs;
  var buttonPressed = false.obs;
  var done = false.obs;
  final nameController = TextEditingController();
  static final validCharacters = RegExp(r'^[a-zA-Z0-9- ]+$');

  @override
  Widget build(BuildContext context) {
    return Obx(() => Dialog(
        backgroundColor: card,
        // shape:
        //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Container(
          height: 320,
          width: 400,
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
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          constraints: const BoxConstraints(),
                          color: secondary,
                        )
                      ],
                    ),
                    Container(
                      height: 30,
                      width: 175,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            text: 'DISPLAY NAME',
                            size: 20,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomText(
                      text: 'Display Name is used to identify you through our platform.',
                      size: 13,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomText(
                text: 'Please enter your desired display name...',
                size: 13,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                width: 330,
                child: TextFormField(
                  onFieldSubmitted: nameValid.value == true && done.value == false
                      ? (_) async {
                          buttonPressed.value = true;
                          await userController.updateDisplayName(nameController.value.text.trim()) ? [done.value = true, Navigator.of(context).pop()] : null;
                        }
                      : null,
                  keyboardType: TextInputType.name,
                  //textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.always,
                  readOnly: done.value ? true : false,
                  validator: (value) {
                    if (GetUtils.isLengthGreaterOrEqual(nameController.value.text, 3) && validCharacters.hasMatch(nameController.value.text)) {
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
                    labelText: "DISPLAY NAME",
                    hintText: "MUST BE 3 CHARACTERS AT LEAST (a-z, A-Z, 0-9)",
                    hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 10)),
                    labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 12)),
                    enabledBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                    borderSide: BorderSide(color: primary)),
                    focusedBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                    borderSide: BorderSide(color: primary)),
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
                    colors: <Color>[Colors.blue.shade600, Colors.purple],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: nameValid.value == true && done.value == false
                      ? () async {
                          buttonPressed.value = true;
                          await userController.updateDisplayName(nameController.value.text.trim()) ? [done.value = true, Navigator.of(context).pop()] : null;
                        }
                      : null,
                  child: buttonPressed.value == true && done.value == false
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : done.value == true
                          ? CustomText(
                              text: "SUCCESS",
                              color: done.value == true ? Colors.greenAccent : secondary,
                              size: 15,
                              weight: FontWeight.bold,
                            )
                          : CustomText(
                              text: "SET DISPLAY NAME",
                              color: nameValid.value == true ? primary : secondary,
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
            ],
          ),
        )));
  }
}
