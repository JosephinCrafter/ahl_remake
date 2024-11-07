import 'package:flutter/material.dart';
import 'package:flutter_seo/flutter_seo.dart';

void setupSeo(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((timestamp) {
    CreateHtml.makeWidgetTree(context);
  });
}
