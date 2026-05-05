import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Conditional imports for web/mobile
import 'web_safe_image_internal.dart' if (dart.library.io) 'web_safe_image_mobile.dart' as loader;

class WebSafeImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget placeholder;

  const WebSafeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = const Icon(Icons.pets, color: Colors.white70),
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return placeholder;
    
    return loader.loadImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
    );
  }
}
