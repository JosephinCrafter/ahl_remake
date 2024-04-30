import "package:flutter/material.dart";

class PartnersView extends StatefulWidget {
  const PartnersView({super.key});

  @override
  State<PartnersView> createState() => _PartnersViewState();
}

class _PartnersViewState extends State<PartnersView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 210),
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 1080,
          maxHeight: 210,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Nos Partenaires",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints.tight(const Size.square(100)),
                  child: const Placeholder(), // implement partner logo
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
