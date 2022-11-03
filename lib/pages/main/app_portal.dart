import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/dialogues/app_close_dialogue.dart';
import 'package:league_arena/pages/auth/screens/auth_sign_out.dart';
import 'package:league_arena/pages/home/upcoming/event_participants.dart';
import 'package:league_arena/pages/home/upcoming/event_rules.dart';
import 'package:league_arena/pages/home/upcoming/event_overview.dart';
import 'package:league_arena/pages/home/upcoming/home_upcoming_screen.dart';
import 'package:league_arena/pages/home/home_screen.dart';
import 'package:league_arena/pages/home/home_ongoing_screen.dart';
import 'package:league_arena/pages/home/upcoming/event_info.dart';
import 'package:league_arena/pages/main/main_screen.dart';
import 'package:league_arena/pages/sponsors/sponsors_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:window_manager/window_manager.dart';

import '../error_404.dart';

class AppPortal extends StatefulWidget {
  const AppPortal({Key? key}) : super(key: key);

  @override
  State<AppPortal> createState() => _AppPortalState();
}

String pageTitle = 'League Arena';

class MyObserver extends RoutemasterObserver {
  // RoutemasterObserver extends NavigatorObserver and
  // receives all nested Navigator events

  // Routemaster-specific observer method
  @override
  void didChangeRoute(RouteData routeData, Page page) {
    changeTitle(routeData.path);
  }
}

void changeTitle(String? route) {
  switch (route) {
    case authPageLoginRoute:
      pageTitle = authPageLoginDisplyName;
      break;
    case authPageRegisterRoute:
      pageTitle = authPageRegisterDisplyName;
      break;
    case notFoundRoute:
      pageTitle = notFoundDisplyName;
      break;
    case authForgotPasswordRoute:
      pageTitle = authForgotPasswordDisplyName;
      break;
    case homeScreenRoute:
      pageTitle = homeScreenDisplyName;
      break;
    case sponsorsScreenRoute:
      pageTitle = sponsorsScreenDisplyName;
      break;
    case signOutScreenRoute:
      pageTitle = signOutScreenDisplyName;
      break;
  }
}

final routemaster = RoutemasterDelegate(
  observers: [MyObserver()],
  routesBuilder: (context) => RouteMap(onUnknownRoute: (_) => const Redirect(notFoundRoute), routes: {
    rootRoute: (route) => const TabPage(
          backBehavior: TabBackBehavior.history,
          child: MainScreen(),
          paths: [homeScreenRoute, sponsorsScreenRoute],
        ),
    homeScreenRoute: (route) => const TabPage(
          backBehavior: TabBackBehavior.history,
          child: HomeScreen(),
          paths: [upcomingScreenRoute, ongoingScreenRoute],
        ),
    eventInfoScreenRoute: (info) => TabPage(
          backBehavior: TabBackBehavior.history,
          child: EventInfo(id: info.pathParameters['id']),
          paths: const [eventOverviewScreenRoute, eventRulesScreenRoute, eventParticipantsScreenRoute],
        ),
    //eventInfScreenRoute: (info) => MaterialPage(child: EventInfo(id: info.pathParameters['id'],)),
    sponsorsScreenRoute: (route) => const MaterialPage(child: SponsorsScreen()),
    upcomingScreenRoute: (route) => const MaterialPage(child: UpcomingScreen()),
    ongoingScreenRoute: (route) => const MaterialPage(child: OngoingScreen()),
    eventOverviewScreenRoute: (route) => const MaterialPage(child: EventOverview()),
    eventRulesScreenRoute: (route) => const MaterialPage(child: EventRules()),
    eventParticipantsScreenRoute: (route) => const MaterialPage(child: EventParticipants()),
    notFoundRoute: (route) => const MaterialPage(child: PageNotFound()),
    // authPageLoginRoute: (route) =>
    //     const MaterialPage(child: AuthLoginScreen()),
    signOutScreenRoute: (route) => const MaterialPage(child: AuthSignOutScreen()),
  }),
);

class _AppPortalState extends State<AppPortal> with WindowListener {
  Timer? timer;
  String title = 'League Arena';

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (pageTitle != title) {
        setState(() {
          title = pageTitle;
        });
      }
    });
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      userController.uID.value != '' ? showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const AppCloseDialogue()) : exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    //   try {
    //     var path = RouteData.fromRouterResult(result, uri);
    //     print(path);
    //   } catch (e) {
    //     print(e);
    //   }
    // });
    //var path = RouteData.of(context).fullPath;
    //print(path);
    return MaterialApp.router(
      routerDelegate: routemaster,
      routeInformationParser: const RoutemasterParser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        primaryColor: background,
        highlightColor: secondary,
        scrollbarTheme: ScrollbarThemeData(
            interactive: true,
            thumbVisibility: MaterialStateProperty.all(true),
            radius: const Radius.circular(10.0),
            thumbColor: MaterialStateProperty.all(secondary.withOpacity(0.4)),
            thickness: MaterialStateProperty.all(5.0),
            //minThumbLength: 150,
            mainAxisMargin: 10),
      ),
      title: title,
    );
  }
}
