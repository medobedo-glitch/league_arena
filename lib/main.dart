import 'dart:async';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/controllers/event_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:get/get.dart';
import 'package:league_arena/controllers/auth_controller.dart';
import 'package:league_arena/pages/main/app_portal.dart';
import 'package:window_manager/window_manager.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAuth.initialize('AIzaSyCVKdHoa3xfvhSrHG8C1Ft_YbWaDG0bXNU', VolatileStore());
  //await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: '6LeuohwdAAAAAGxsghZYrY4yY5PaLVtWdarEyZH2');
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => EventController());

  configureApp();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setPreventClose(true);
    await windowManager.setHasShadow(true);
    await windowManager.show();
    await windowManager.focus();
  });

  generateThirdPartyCode();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
  doWhenWindowReady(() async {
    final win = appWindow;
    const initialSize = Size(1280, 720);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "League Arena v0.1.0 beta";
    //win.show();
  });
}

void generateThirdPartyCode() {
  final random = Random();
  const availableChars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  final randomString = List.generate(7, (index) => availableChars[random.nextInt(availableChars.length)]).join();

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

Size calcTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
  )..layout();
  return textPainter.size;
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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const AppPortal();
    });
  }
}
