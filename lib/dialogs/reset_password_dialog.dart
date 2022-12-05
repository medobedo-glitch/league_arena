import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String email;
  const ResetPasswordDialog({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  var resetSent = false.obs;
  var buttonPressed = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Dialog(
          backgroundColor: card,
          // shape:
          //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          child: Container(
            height: resetSent.value == true ? 370 : 310,
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
                      text: 'RESET PASSWORD',
                      size: 25,
                      weight: FontWeight.bold,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: CustomText(
                        text: "Reset your League Arena account password",
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
                SizedBox(
                  height: resetSent.value == true ? 20 : 10,
                ),
                resetSent.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            EvaIcons.checkmarkCircle,
                            size: 60,
                            color: Colors.green,
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: resetSent.value == false
                                ? "Do you want to recieve password reset email to ${widget.email}?"
                                : "Password reset email has been successfully sent to ${widget.email}.",
                            style: TextStyle(color: primary, fontSize: 18, fontFamily: 'Ubuntu')),
                      ],
                    ),
                  ),
                ),
                //
                const SizedBox(
                  height: 25,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: <Color>[Colors.blue.shade600, Colors.purple],
                    ),
                  ),
                  child: OutlinedButton(
                    onPressed: () async {
                      buttonPressed.value = true;
                      resetSent.value == true
                          ? Navigator.of(context).pop()
                          : await authController.passwordReset(widget.email, context)
                              ? [resetSent.value = true, buttonPressed.value = false]
                              : [resetSent.value = false, buttonPressed.value = false];
                    },
                    style: OutlinedButton.styleFrom(
                        //primary: Colors.purple,
                        //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        foregroundColor: background,
                        elevation: 0,
                        //primary: Colors.transparent,
                        fixedSize: const Size(250, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                    child: buttonPressed.value == true
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : CustomText(
                            text: resetSent.value == true ? "CONFIRM" : 'RESET PASSWORD',
                            color: primary,
                            size: 20,
                            weight: FontWeight.bold,
                          ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
