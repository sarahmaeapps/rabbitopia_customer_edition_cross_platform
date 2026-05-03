import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDX_TSGRZIfY2EaiXW_DEDIulnEcmhKzmk',
    appId: '1:8749398516:android:c9b631a8346b628642a1a1',
    messagingSenderId: '8749398516',
    projectId: 'rabbitopia-834e8',
    storageBucket: 'rabbitopia-834e8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDX_TSGRZIfY2EaiXW_DEDIulnEcmhKzmk',
    appId: '1:8749398516:ios:qjub2dg9bdt21so3682c9r0nlkg88t5b',
    messagingSenderId: '8749398516',
    projectId: 'rabbitopia-834e8',
    storageBucket: 'rabbitopia-834e8.firebasestorage.app',
    iosBundleId: 'com.sarahmaeapps.rabbitopia-ios-customer-edition',
  );
}
