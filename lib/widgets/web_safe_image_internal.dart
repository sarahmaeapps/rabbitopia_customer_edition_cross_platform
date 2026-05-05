import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

Widget loadImage({
  required String imageUrl,
  double? width,
  double? height,
  required BoxFit fit,
  required Widget placeholder,
}) {
  // Create a unique ID for the platform view
  final String viewId = 'img-${imageUrl.hashCode}';

  // Register the view factory
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
    final html.ImageElement element = html.ImageElement()
      ..src = imageUrl
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = _getObjectName(fit);
    return element;
  });

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewId),
  );
}

String _getObjectName(BoxFit fit) {
  switch (fit) {
    case BoxFit.cover: return 'cover';
    case BoxFit.contain: return 'contain';
    case BoxFit.fill: return 'fill';
    case BoxFit.fitWidth: return 'scale-down';
    case BoxFit.fitHeight: return 'scale-down';
    case BoxFit.none: return 'none';
    case BoxFit.scaleDown: return 'scale-down';
  }
}
