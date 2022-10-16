import 'dart:async';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/controllers/event_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:get/get.dart';
import 'package:league_arena/controllers/auth_controller.dart';
import 'package:league_arena/pages/main/app_portal.dart';
import 'package:window_manager/window_manager.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => EventController());
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAuth.initialize('AIzaSyCVKdHoa3xfvhSrHG8C1Ft_YbWaDG0bXNU', VolatileStore());
   //await Firebase.initializeApp();
   //await FirebaseAppCheck.instance.activate(
   //webRecaptchaSiteKey: '6LeuohwdAAAAAGxsghZYrY4yY5PaLVtWdarEyZH2');
  configureApp();
  await windowManager.ensureInitialized();

  generateThirdPartyCode();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
   doWhenWindowReady(() async {
     await windowManager.setPreventClose(true);
    await windowManager.setSkipTaskbar(false);
    const initialSize = Size(1280, 720);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "League Arena v0.1.0 beta";
    appWindow.show();
  });
}

void generateThirdPartyCode() {
  final _random = Random();
  const _availableChars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  final randomString = List.generate(7, (index) => _availableChars[_random.nextInt(_availableChars.length)]).join();

  userController.thirdPartyCodeIn.value = randomString;
}

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}

void configureApp() {
  Routemaster.setPathUrlStrategy();
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(route, context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return WindowBorder(color: background, child: const AppPortal());
    });
  }
}
