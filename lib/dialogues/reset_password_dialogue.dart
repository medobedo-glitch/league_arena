import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class ResetPasswordDialogue extends StatefulWidget {
  final String email;
  const ResetPasswordDialogue({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordDialogue> createState() => _ResetPasswordDialogueState();
}

class _ResetPasswordDialogueState extends State<ResetPasswordDialogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: card,
        // shape:
        //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Container(
          height: 350,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    EvaIcons.checkmarkCircle,
                    size: 60,
                    color: Colors.green,
                  )
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
                      TextSpan(text: "Password reset email has been sent to ${widget.email}.", style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 15))),
                    ],
                  ),
                ),
              ),
              //
              const SizedBox(height: 25,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: <Color>[Colors.blue.shade600, Colors.purple],
                  ),
                ),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                      //primary: Colors.purple,
                      //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      foregroundColor: background,
                      elevation: 0,
                      //primary: Colors.transparent,
                      fixedSize: const Size(250, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  child: CustomText(
                          text: "CONFIRM",
                          color: primary,
                          size: 20,
                          weight: FontWeight.bold,
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
