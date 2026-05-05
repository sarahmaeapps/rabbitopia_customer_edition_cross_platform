import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCcGn9j4yf5EZewH-yRYCepx-fw4bvEdHw',
    appId: '1:8749398516:ios:1d29b8e809afd61142a1a1',
    messagingSenderId: '8749398516',
    projectId: 'rabbitopia-834e8',
    storageBucket: 'rabbitopia-834e8.firebasestorage.app',
    iosClientId: '8749398516-sb3hphud47fefamsnhsgopnb8n6h9vgo.apps.googleusercontent.com',
    iosBundleId: 'com.sarahmaeapps.rabbitopiaCustomerEditionCrossPlatform',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvhZvM27GEMbJ99btGw7CLzVvcOpm6GmI',
    appId: '1:8749398516:web:2fb146679ac82abd42a1a1',
    messagingSenderId: '8749398516',
    projectId: 'rabbitopia-834e8',
    authDomain: 'rabbitopia-834e8.firebaseapp.com',
    storageBucket: 'rabbitopia-834e8.firebasestorage.app',
    measurementId: 'G-MGTPFF6LXR',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcGn9j4yf5EZewH-yRYCepx-fw4bvEdHw',
    appId: '1:8749398516:ios:1d29b8e809afd61142a1a1',
    messagingSenderId: '8749398516',
    projectId: 'rabbitopia-834e8',
    storageBucket: 'rabbitopia-834e8.firebasestorage.app',
    iosClientId: '8749398516-sb3hphud47fefamsnhsgopnb8n6h9vgo.apps.googleusercontent.com',
    iosBundleId: 'com.sarahmaeapps.rabbitopiaCustomerEditionCrossPlatform',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCvhZvM27GEMbJ99btGw7CLzVvcOpm6GmI',
    appId: '1:8749398516:web:ec2f395f2fb73c0242a1a1',
    messagingSenderId: '8749398516',
    projectId: 'rabbitopia-834e8',
    authDomain: 'rabbitopia-834e8.firebaseapp.com',
    storageBucket: 'rabbitopia-834e8.firebasestorage.app',
    measurementId: 'G-VZVGRJZ5YF',
  );

}