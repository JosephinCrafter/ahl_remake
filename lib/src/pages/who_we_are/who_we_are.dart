import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhoWeArePage extends StatefulWidget {
  const WhoWeArePage({super.key});

  static const String routeName = '/whoWeAre';

  @override
  State<WhoWeArePage> createState() => _WhoWeArePageState();
}

class _WhoWeArePageState extends State<WhoWeArePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.domSisters,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
