import 'dart:async';
import 'dart:io';
import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:chefstation_multivendor/features/language/controllers/localization_controller.dart';
import 'package:chefstation_multivendor/features/notification/domain/models/notification_body_model.dart';
import 'package:chefstation_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:chefstation_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:chefstation_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:chefstation_multivendor/features/splash/domain/models/deep_link_body.dart';
import 'package:chefstation_multivendor/helper/notification_helper.dart';
import 'package:chefstation_multivendor/helper/responsive_helper.dart';
import 'package:chefstation_multivendor/helper/route_helper.dart';
import 'package:chefstation_multivendor/theme/dark_theme.dart';
import 'package:chefstation_multivendor/theme/light_theme.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';
import 'package:chefstation_multivendor/util/messages.dart';
import 'package:chefstation_multivendor/util/logger.dart';
import 'package:chefstation_multivendor/util/security_utils.dart';
import 'package:chefstation_multivendor/util/performance_monitor.dart';
import 'package:chefstation_multivendor/util/error_handler.dart';
import 'package:chefstation_multivendor/common/widgets/cookies_view_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize professional systems
  await _initializeProfessionalSystems();
  
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();

  DeepLinkBody? linkBody;

  // Initialize Firebase
  await _initializeFirebase();

  Map<String, Map<String, String>> languages = await di.init();

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (error) {
    AppLogger.error('Failed to initialize notifications', error);
  }

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "452131619626499",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }

  AppLogger.info('Application initialized successfully');
  runApp(MyApp(languages: languages, body: body, linkBody: linkBody));
}

/// Initialize professional systems
Future<void> _initializeProfessionalSystems() async {
  try {
    // Initialize security system
    SecurityUtils.initialize();
    AppLogger.info('Security system initialized');
    
    // Initialize performance monitoring
    PerformanceMonitor.startMemoryTracking();
    AppLogger.info('Performance monitoring started');
    
    // Set up error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      ErrorHandler.handleError(
        details.exception,
        context: 'Flutter Error',
        showSnackBar: false,
      );
    };
    
    AppLogger.info('Professional systems initialized successfully');
  } catch (error) {
    // Fallback error handling if professional systems fail
    debugPrint('Failed to initialize professional systems: $error');
  }
}

/// Initialize Firebase with error handling
Future<void> _initializeFirebase() async {
  try {
    if (GetPlatform.isWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDlwSbKu5fKthK0ks9aNHLaLSyehhfteto",
          appId: "1:436182947803:android:c52a9a7f8a42131c3439fe",
          messagingSenderId: "436182947803",
          projectId: "bayti-cd6e7",
          storageBucket: "bayti-cd6e7.firebasestorage.app",
        ),
      );
      MetaSEO().config();
    } else if (GetPlatform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDlwSbKu5fKthK0ks9aNHLaLSyehhfteto",
          appId: "1:436182947803:android:c52a9a7f8a42131c3439fe",
          messagingSenderId: "436182947803",
          projectId: "bayti-cd6e7",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    AppLogger.info('Firebase initialized successfully');
  } catch (error) {
    AppLogger.error('Failed to initialize Firebase', error);
    // Continue without Firebase if initialization fails
  }
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  final DeepLinkBody? linkBody;
  const MyApp({
    super.key,
    required this.languages,
    required this.body,
    required this.linkBody,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    try {
      PerformanceMonitor.startTimer('App Initialization');
      
      if (GetPlatform.isWeb) {
        Get.find<SplashController>().initSharedData();
        if (!Get.find<AuthController>().isLoggedIn() &&
            !Get.find<AuthController>().isGuestLoggedIn()) {
          await Get.find<AuthController>().guestLogin();
        }
        if (Get.find<AuthController>().isLoggedIn() ||
            Get.find<AuthController>().isGuestLoggedIn()) {
          Get.find<CartController>().getCartDataOnline();
        }
        Get.find<SplashController>().getConfigData(fromMainFunction: true);
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          await Get.find<FavouriteController>().getFavouriteList();
        }
      }
      
      PerformanceMonitor.endTimer('App Initialization');
      AppLogger.info('App routing completed');
    } catch (error) {
      ErrorHandler.handleError(error, context: 'App Initialization');
    }
  }

  @override
  void dispose() {
    // Clean up performance monitoring
    PerformanceMonitor.stopMemoryTracking();
    PerformanceMonitor.logReport();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetBuilder<SplashController>(
              builder: (splashController) {
                return (GetPlatform.isWeb &&
                        splashController.configModel == null)
                    ? const SizedBox()
                    : GetMaterialApp(
                        title: AppConstants.appName,
                        debugShowCheckedModeBanner: false,
                        navigatorKey: Get.key,
                        scrollBehavior: const MaterialScrollBehavior().copyWith(
                          dragDevices: {
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.touch,
                          },
                        ),
                        theme: themeController.darkTheme ? dark : light,
                        locale: localizeController.locale,
                        translations: Messages(languages: widget.languages),
                        fallbackLocale: Locale(
                          AppConstants.languages[0].languageCode!,
                          AppConstants.languages[0].countryCode,
                        ),
                        initialRoute: GetPlatform.isWeb
                            ? RouteHelper.getInitialRoute()
                            : RouteHelper.getSplashRoute(
                                widget.body,
                                widget.linkBody,
                              ),
                        getPages: RouteHelper.routes,
                        defaultTransition: Transition.topLevel,
                        transitionDuration: const Duration(milliseconds: 500),
                        builder: (BuildContext context, widget) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(textScaler: const TextScaler.linear(1)),
                            child: Material(
                              child: SafeArea(
                                top: false,
                                bottom: GetPlatform.isAndroid,
                                child: Stack(
                                  children: [
                                    widget!,
                                    GetBuilder<SplashController>(
                                      builder: (splashController) {
                                        if (!splashController
                                                .savedCookiesData ||
                                            !splashController
                                                .getAcceptCookiesStatus(
                                                  splashController
                                                          .configModel
                                                          ?.cookiesText ??
                                                      "",
                                                )) {
                                          return ResponsiveHelper.isWeb()
                                              ? const Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: CookiesViewWidget(),
                                                )
                                              : const SizedBox();
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            );
          },
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
