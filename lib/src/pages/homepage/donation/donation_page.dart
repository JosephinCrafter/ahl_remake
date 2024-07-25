import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  static const String routeName = "helpUs";

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AhlAppBar(),
      body: Center(
        child: Text(
          "Donation Page",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
