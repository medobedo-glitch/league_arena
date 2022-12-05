import 'dart:async';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/controllers/event_controller.dart';
import 'package:league_arena/env/env.dart';
import 'package:league_arena/pages/auth/screens/auth_sign_out.dart';
import 'package:league_arena/pages/error_404.dart';
import 'package:league_arena/pages/home/event_brackets.dart';
import 'package:league_arena/pages/home/event_info.dart';
import 'package:league_arena/pages/home/event_overview.dart';
import 'package:league_arena/pages/home/event_participants.dart';
import 'package:league_arena/pages/home/event_rules.dart';
import 'package:league_arena/pages/home/home_tournaments_screen.dart';
import 'package:league_arena/pages/main/main_screen.dart';
import 'package:league_arena/pages/sponsors/sponsors_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:get/get.dart';
import 'package:league_arena/controllers/auth_controller.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routemaster.setPathUrlStrategy();
  
  await Firebase.initializeApp(
      options: FirebaseOptions(
          appId: Env.FIREBASE_APP_ID,
          apiKey: Env.FIREBASE_API_KEY,
          projectId: Env.FIREBASE_PROJECT_ID,
          messagingSenderId: Env.FIREBASE_MESSAGING_SENDER_ID,
          databaseURL: Env.FIREBASE_DATABASE_URL));

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: Env.FIREBASE_APPCHECK_KEY,
  );

  await FirebaseAnalytics.instance.logEvent(
    name: 'app_start',
  );

  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => EventController());

  await userController.doInit(true);

  runApp(const MyApp());
}

String generateR() {
  var r = Random();
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  return List.generate(9, (index) => chars[r.nextInt(chars.length)]).join();
}

// const String link = "https://$host/leaguearena/TfVv7sEnygNuPS.php?apicall=";

// Future<void> initData() async {
//   final List<dynamic> data2 = await postRequest('$link${generateP1()}Sk${generateP2()}Kv', {});
//   final Map<String, dynamic> data = data2[0];

//   data.forEach((k, v) => vars.add(v));
// }

Size calcTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
  )..layout();
  return textPainter.size;
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(route, context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child);
}

String pageTitle = 'League Arena';

class MyObserver extends RoutemasterObserver {
  @override
  void didChangeRoute(RouteData routeData, Page page) {
    changeTitle(routeData.path);
  }
}

void changeTitle(String? route) {
  switch (route) {
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

FirebaseDatabase database = FirebaseDatabase.instance;

final routemaster = RoutemasterDelegate(
  observers: [MyObserver()],
  routesBuilder: (context) => RouteMap(onUnknownRoute: (_) => const Redirect(notFoundRoute), routes: {
    rootRoute: (route) => const TabPage(
          backBehavior: TabBackBehavior.history,
          child: MainScreen(),
          paths: ['home', 'community'],
        ),
    homeScreenRoute: (route) => const MaterialPage(child: TournamentsScreen()),
    eventInfoScreenRoute: (info) => TabPage(
          backBehavior: TabBackBehavior.history,
          child: EventInfo(id: info.pathParameters['id']),
          paths: const ['overview', 'rules', 'participants', 'brackets'],
        ),
    //eventInfScreenRoute: (info) => MaterialPage(child: EventInfo(id: info.pathParameters['id'],)),
    sponsorsScreenRoute: (route) => const MaterialPage(child: SponsorsScreen()),
    eventOverviewScreenRoute: (info) => const MaterialPage(child: EventOverview()),
    eventRulesScreenRoute: (info) => const MaterialPage(child: EventRules()),
    eventParticipantsScreenRoute: (route) => const MaterialPage(child: EventParticipants()),
    eventBracketsScreenRoute: (route) => const MaterialPage(child: EventBrackets()),
    notFoundRoute: (route) => const MaterialPage(child: PageNotFound()),
    // authPageLoginRoute: (route) =>
    //     const MaterialPage(child: AuthLoginScreen()),
    signOutScreenRoute: (route) => const MaterialPage(child: AuthSignOutScreen()),
  }),
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    super.initState();
  }

  String? changes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: routemaster,
      routeInformationParser: const RoutemasterParser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
        fontFamily: 'Ubuntu',
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
