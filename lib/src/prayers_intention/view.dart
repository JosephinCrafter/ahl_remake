part of 'prayers_intention.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class PrayersIntentionRequestView extends StatefulWidget {
  const PrayersIntentionRequestView({super.key});

  /// The callback being called when prayer is submitted.
  ///
  /// It should interact with bloc
  void _submitPrayer() {
    // sent prayer to prayer service
  }

  @override
  State<PrayersIntentionRequestView> createState() =>
      _PrayersIntentionRequestViewState();
}

class _PrayersIntentionRequestViewState
    extends State<PrayersIntentionRequestView> {
  late List<Widget> views;

  @override
  void initState() {
    views = [
      PrayerCollectView(
        key: const ValueKey(1),
        callback: nextView,
      ),
      PrayerDateCollectionView(
        key: const ValueKey(2),
        //todo: change to new widget index
        callback: nextView,
        backCallback: previousView,
      ),
    ];
    super.initState();
  }

  //todo: change to 0 after building dateView view
  int _index = 1;

  void nextView() => setState(() {
        if (_index < views.length) {
          _index = (_index + 1) % views.length;
          _isGoingForward = true;
        }
      });

  void previousView() => setState(() {
        if (_index < views.length) {
          _index = (_index - 1) % views.length;
          _isGoingForward = false;
        }
      });

  // test to setup animation
  bool _isGoingForward = true;

  @override
  Widget build(BuildContext context) {
    const duration = Durations.subtle;
    const curvesIn = Curves.easeIn;
    const curvesOut = Curves.easeOut;

    return AnimatedSwitcher(
      switchInCurve: curvesIn,
      switchOutCurve: curvesOut,
      transitionBuilder: (child, animation) {
        return (_isGoingForward)
            ? child
                .animate(
                  autoPlay: false,
                  target: 1,
                )
                .slideX(begin: 1, end: 0, duration: duration, curve: curvesIn)
            : child.animate(autoPlay: false, target: 1).slideX(
                begin: -1, end: 0, duration: duration, curve: curvesOut);
      },
      duration: duration,
      child: views[_index],
    );
  }
}

class PrayerDateCollectionView extends StatefulWidget {
  const PrayerDateCollectionView({
    super.key,
    void Function()? callback,
    void Function()? backCallback,
  })  : _callback = callback,
        _backCallback = backCallback;

  final void Function()? _callback;
  final void Function()? _backCallback;

  @override
  State<PrayerDateCollectionView> createState() =>
      _PrayerDateCollectionViewState();
}

class _PrayerDateCollectionViewState extends State<PrayerDateCollectionView> {
  final DateTime firstDate = DateTime.now();

  final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

  final option = [
    "Messe",
    "office",
    "chapelet",
  ];

  late Set<String> selected;

  void _onSelectionChange(Set<String> p0) {
    setState(
      () => selected = p0,
    );
  }

  @override
  void initState() {
    super.initState();
    selected = {option[2]};
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          title,
          Container(
            margin: (constraints.maxWidth > ScreenSizes.mobile)
                ? const EdgeInsets.all(Margins.mobileMedium)
                : const EdgeInsets.all(Margins.mobileSmall),
            padding: (constraints.maxWidth > ScreenSizes.mobile)
                ? const EdgeInsets.all(Margins.mobileMedium)
                : const EdgeInsets.all(Margins.mobileSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(BorderSizes.big),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    bottom: Paddings.listSeparator,
                  ),
                  child: Text("Quand pronnoncer votre prière?"),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Paddings.listSeparator,
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SegmentedButton<String>(
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.comfortable,
                      ),
                      onSelectionChanged: _onSelectionChange,
                      showSelectedIcon: true,
                      selected: selected,
                      multiSelectionEnabled: false,
                      selectedIcon: Icon(Icons.done)
                          .animate()
                          .scale(
                            duration: Durations.subtle,
                            alignment: Alignment.center,
                            curve: Curves.easeOut,
                            begin: const Offset(0.7, 0.7),
                            end: const Offset(1.0, 1.0),
                          )
                          .rotate(begin: 1.1, end: 1),
                      segments: List.generate(
                        option.length,
                        (index) => ButtonSegment(
                          label: Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(option[index]),
                          ),
                          value: option[index],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    bottom: Paddings.listSeparator,
                  ),
                  child: Text("Choisir la date:"),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: Paddings.listSeparator,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7EFD4),
                    borderRadius: BorderRadius.circular(BorderSizes.medium),
                  ),
                  child: CalendarDatePicker(
                    currentDate: DateTime.now(),
                    onDateChanged: (value) {
                      // do date change here
                    },
                    initialDate: firstDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: widget._backCallback,
                  icon: const Icon(Icons.arrow_back)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // execute callback or nothing
                    Function fun = widget._callback ?? () {};
                    fun();
                  }
                },
                child: const Text("Suivant"),
              ),
            ],
          )
        ],
      ),
    );
    return FormsLayoutBase(child: child);
  }
}

class PrayerCollectView extends StatelessWidget {
  const PrayerCollectView({super.key, Function? callback})
      : _callback = callback;

  final Function? _callback;

  @override
  Widget build(BuildContext context) {
    final Widget child = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // constraints: const BoxConstraints.expand(
            //   // maxWidth: 215,
            //   height: 250,
            // ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AhlAssets.praying,
                ),
              ),
            ),
          ),
          title,
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
                top: Paddings.big, bottom: Paddings.listSeparator),
            child: Text(
              AppLocalizations.of(context)!.proverb,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.priersInvitation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: Paddings.big),
            padding: const EdgeInsets.all(Paddings.medium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //name and First name
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: Paddings.listSeparator),
                  child: TextFormField(
                    decoration: InputDecoration(
                      helperText: AppLocalizations.of(context)!.optional,
                      label:
                          Text(AppLocalizations.of(context)!.nameAndFirstName),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: Paddings.listSeparator),
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
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    // constraints: const BoxConstraints(minHeight: 250),
                    label: Text("${AppLocalizations.of(context)!.priers}*"),
                    hintText: AppLocalizations.of(context)!.yourPrayer,
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return AppLocalizations.of(context)!.cantBeEmpty;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(bottom: Paddings.listSeparator),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // execute callback or nothing
                  Function fun = _callback ?? () {};
                  fun();
                }
              },
              child: Text(AppLocalizations.of(context)!.sendPray),
            ),
          ),
        ],
      ),
    );

    return FormsLayoutBase(
      child: child,
    );
  }
}

final Widget title = Builder(
  builder: (context) => Text(
    AppLocalizations.of(context)!.shareYourPriers,
    style: Theme.of(context).textTheme.displaySmall,
  ),
);
