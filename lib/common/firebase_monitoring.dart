import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseMonitoring {
  static bool _isInitialized = false;
  static FirebaseAnalyticsObserver? _analyticsObserver;

  static bool get isInitialized => _isInitialized;
  static FirebaseAnalyticsObserver? get analyticsObserver => _analyticsObserver;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      _analyticsObserver = FirebaseAnalyticsObserver(
        analytics: FirebaseAnalytics.instance,
      );

      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      PlatformDispatcher.instance.onError = (error, stackTrace) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
        return true;
      };
    } catch (error, stackTrace) {
      _isInitialized = false;
      _analyticsObserver = null;
      debugPrint('Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) async {
    if (!_isInitialized) {
      debugPrint('Unhandled error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return;
    }

    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: fatal,
    );
  }
}
