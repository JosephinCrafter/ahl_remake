part of 'prayers_intention.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class PrayersIntentionRequestView extends StatelessWidget {
  const PrayersIntentionRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget child = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      constraints: const BoxConstraints(maxWidth: 1129),
      padding: const EdgeInsets.symmetric(
        vertical: Paddings.huge,
        horizontal: Paddings.big,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.shareYourPriers,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: Paddings.big, bottom: Paddings.listSeparator),
              child: Text(
                AppLocalizations.of(context)!.proverb,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.priersInvitation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            //name and First name
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: Paddings.listSeparator),
              child: TextFormField(
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.nameAndFirstName),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Paddings.listSeparator),
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("Email*"),
                ),
                validator: (value) {
                  if (!isValidEmail(value ?? "")) {
                    return AppLocalizations.of(context)!.invalidEmail;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Paddings.listSeparator),
              child: TextFormField(
                maxLines: 10,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(minHeight: 250),
                  label: Text("${AppLocalizations.of(context)!.priers}*"),
                ),
                validator: (value) {
                  if (value == null || value == "") {
                    return AppLocalizations.of(context)!.cantBeEmpty;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Paddings.listSeparator),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // do something
                    }
                  },
                  child: Text("Soumettre mon intention"),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      switch (constraints.maxWidth) {
        case > 1000:
          return Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints.loose(
                const Size(1129, 784),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          );
        default:
          return child;
      }
    });
  }
}
