import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:routemaster/routemaster.dart';

Size calcTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
  )..layout();
  return textPainter.size;
}

AppBar topNavigationBar(BuildContext context, TabPageState controller,
        List<ContentView> contentViews) =>
    AppBar(
      iconTheme: IconThemeData(color: card),
      backgroundColor: card,
      automaticallyImplyLeading: false,
      elevation: 1,
      shadowColor: secondary,
      //shape: Border(bottom: BorderSide(color: secondary, width: 0.5)),
      title: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 110,
              padding: const EdgeInsets.only(bottom: 3),
              child: Image.asset(
                "assets/icon/logo2.png",
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            CustomTabBarPrimary(
                controller: controller,
                tabs: contentViews.map((e) => e.tab).toList(), indiColor: Colors.purple,),
            Expanded(child: SizedBox(
              height: kToolbarHeight,
              child: WindowTitleBarBox(child: MoveWindow(),))),
            userController.uID.value == ''
                ? Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // children: [
                    //   Padding(
                    //     padding: const EdgeInsets.only(bottom: 8),
                    //     child: RichText(
                    //       text: TextSpan(
                    //         children: [
                    //           TextSpan(
                    //               text: "SIGN IN",
                    //               style: GoogleFonts.ubuntu(
                    //                   textStyle: TextStyle(
                    //                       color: primary,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 17)),
                    //               recognizer: TapGestureRecognizer()
                    //                 ..onTap = () {
                    //                   //Get.offAllNamed(authPageLoginRoute);
                    //                   Routemaster.of(context)
                    //                       .push(authPageLoginRoute);
                    //                 }),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(
                    //     width: 10,
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.only(bottom: 8),
                    //     child: Container(
                    //       width: 2,
                    //       height: 22,
                    //       color: secondary,
                    //     ),
                    //   ),
                    //   const SizedBox(
                    //     width: 15,
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.only(bottom: 8),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         Routemaster.of(context).push(authPageRegisterRoute);
                    //       },
                    //       child: CustomText(
                    //         text: "SIGN UP",
                    //         color: primary,
                    //         size: 17,
                    //         weight: FontWeight.bold,
                    //       ),
                    //       style: ElevatedButton.styleFrom(
                    //         //primary: Colors.purple,
                    //         //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    //         fixedSize: const Size(110, 35),
                    //         // shape: RoundedRectangleBorder(
                    //         //     borderRadius: BorderRadius.circular(30)),
                    //         // textStyle: const TextStyle(
                    //         //     fontSize: 20, fontWeight: FontWeight.bold)
                    //       ),
                    //     ),
                    //   ),
                    // ],
                    )
                : Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            gradient: LinearGradient(
                                              colors: <Color>[Colors.blue.shade600, Colors.purple],
                                            ),
                                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Routemaster.of(context).replace(signOutScreenRoute);
                            },
                            child: CustomText(
                              text: "SIGN OUT",
                              color: primary,
                              size: 17,
                              weight: FontWeight.bold,
                            ),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                                      elevation: 0,
                                      primary: Colors.transparent,
                              //primary: Colors.purple,
                              //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              fixedSize: const Size(115, 35),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(30)),
                              // textStyle: const TextStyle(
                              //     fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),

      // elevation: 0,
      // title: Row(
      //   children: [
      //     //Visibility(child: CustomText(text: "Home",color: primary, size: 20, weight: FontWeight.bold,)),
      //     Expanded(child: Container()),
      //     IconButton(icon: Icon(Icons.settings, color: card.withOpacity(0.7),), onPressed: (){},),
      //     Stack(
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.notifications, color: card.withOpacity(0.7)), onPressed: (){},),
      //           Positioned(
      //             top: 7,
      //             right: 7,
      //             child: Container(
      //               width: 12,
      //               height: 12,
      //               padding: const EdgeInsets.all(4),
      //               decoration: BoxDecoration(
      //                 color: Colors.blue,
      //                 borderRadius: BorderRadius.circular(30),
      //                 border: Border.all(color: primary, width: 2,)),
      //             ))
      //       ],
      //     ),

      //     Container(
      //       width: 1,
      //       height: 22,
      //       color: card,
      //     ),

      //     const SizedBox(
      //       width: 24,
      //     ),

      //     CustomText(text: "Mohamed Khaled", size: 14, color: card, weight: FontWeight.bold),

      //     const SizedBox(
      //        width: 16,
      //     ),

      //     Container(
      //       decoration: BoxDecoration(color: primary,
      //       borderRadius: BorderRadius.circular(30)),
      //       child: Container(
      //         padding: const EdgeInsets.all(2),
      //         // margin: const EdgeInsets.all(3),
      //         child: CircleAvatar(
      //           backgroundColor: primary,
      //           child: Icon(Icons.person_outline,color: card,),),
      //       ),
      //     ),
      //   ],
      // ),
    );
