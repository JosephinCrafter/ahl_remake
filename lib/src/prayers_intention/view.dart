part of 'prayer_request.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

/// The route view to collect, setup date and confirm prayers
/// request.
///
/// This widget is an AnimatedSwitcher with 4 children.
///
/// This class should be used under the bloc of managing it's state.
///
/// [email],[dateTime],[prayer] and [prayerType] should be not null.
// todo: Change variable to a PrayerRequests model.
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

  late String? name;
  late String email;
  late DateTime dateTime;
  late String prayer;
  late PrayerType prayerType;

  @override
  void initState() {
    name = "Andry";
    email = "razafindrakotojosephin@gmail.com";
    dateTime = DateTime.now();
    prayer =
        "Je remets entre vos mains Seigneur, les examens de mes étudiantes. Qu'elles soient éclairer par ta lumière.";
    prayerType = PrayerType.rosary;

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
      ReviewPrayerView(
        name: name,
        email: email,
        dateTime: dateTime,
        prayer: prayer,
        prayerType: prayerType,
        backCallback: previousView,
        callback: widget._submitPrayer,
      ),
    ];
    super.initState();
  }

  // // todo: change to 0 after building dateView view
  int _index = 0;

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
    const duration = AhlDurations.subtle;
    const curvesIn = Curves.easeIn;
    const curvesOut = Curves.easeOut;

    return BlocProvider<PrayerRequestBloc>(
      create: (context) => PrayerRequestBloc(),
      lazy: true,
      child: AnimatedSwitcher(
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
      ),
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

  late DateTime _date;

  final _option = PrayerType.values;

  late Set<PrayerType> selected;

  void _onSelectionChange(Set<PrayerType> p0) {
    setState(
      () => selected = p0,
    );
  }

  late PrayerRequest? _request;

  @override
  void initState() {
    super.initState();

    /// get the PrayerRequest object from the bloc
    _request = context.read<PrayerRequestBloc>().state.request;

    selected = {_request?.prayerType ?? _option[2]};
    _date = _request?.dateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          title,
          Container(
            margin: const EdgeInsets.only(top: Paddings.listSeparator),
            padding: //(constraints.maxWidth > ScreenSizes.mobile)
                // ?

                const EdgeInsets.all(Margins.mobileMedium),
            //: const EdgeInsets.all(Margins.mobileSmall),
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
                  child: Text(
                    AppLocalizations.of(context)!.whenWePray,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Paddings.listSeparator,
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SegmentedButton<PrayerType>(
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
                            duration: AhlDurations.subtle,
                            alignment: Alignment.center,
                            curve: Curves.easeOut,
                            begin: const Offset(0.7, 0.7),
                            end: const Offset(1.0, 1.0),
                          )
                          .rotate(begin: 1.1, end: 1),
                      segments: List.generate(
                        _option.length,
                        (index) => ButtonSegment(
                          label: Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              _option[index].localizedToString(context),
                            ),
                          ),
                          value: _option[index],
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
                    borderRadius: BorderRadius.circular(
                        BorderSizes.big - Paddings.listSeparator),
                  ),
                  child: CalendarDatePicker(
                    currentDate: DateTime.now(),
                    onDateChanged: (value) {
                      _date = value;
                    },
                    initialDate: _date,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            child: Row(
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
                    context.read<PrayerRequestBloc>().add(
                          PrayerRequestFilledDateEvent(
                            date: _date.copyWith(
                              hour: selected.first.time.hour,
                              minute: selected.first.time.minute,
                            ),
                            prayerType: selected.first,
                          ),
                        );
                    // execute callback or nothing
                    Function fun = widget._callback ?? () {};
                    fun();
                  },
                  child: const Text("Suivant"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return FormsLayoutBase(child: child);
  }
}

class PrayerCollectView extends StatefulWidget {
  const PrayerCollectView({super.key, Function? callback})
      : _callback = callback;

  final Function? _callback;

  @override
  State<PrayerCollectView> createState() => _PrayerCollectViewState();
}

class _PrayerCollectViewState extends State<PrayerCollectView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _prayer = TextEditingController();

  @override
  void initState() {
    _name.addListener(() {
      print(_name.value.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PrayerRequest? request = context.read<PrayerRequestBloc>().state.request;

    _name.text = request?.name ?? "";
    _email.text = request?.email ?? "";
    _prayer.text = request?.prayer ?? "";

    final Widget child = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          prayerDecorationImage,
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

                  /// Name
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      helperText: AppLocalizations.of(context)!.optional,
                      label:
                          Text(AppLocalizations.of(context)!.nameAndFirstName),
                    ),
                  ),
                ),

                /// Email
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: Paddings.listSeparator),
                  child: TextFormField(
                    controller: _email,
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

                /// Prayer
                TextFormField(
                  controller: _prayer,
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

          /// Buttons
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
                  context.read<PrayerRequestBloc>().add(
                        PrayerRequestFilledFormEvent(
                          name: _name.value.text,
                          email: _email.value.text,
                          prayer: _prayer.value.text,
                        ),
                      );
                  // execute callback or nothing
                  Function fun = widget._callback ?? () {};
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

/// Prayer request confirmation page.
class ReviewPrayerView extends StatelessWidget {
  const ReviewPrayerView({
    super.key,
    this.name,
    required this.dateTime,
    this.prayer,
    required this.email,
    required this.prayerType,
    VoidCallback? callback,
    VoidCallback? backCallback,
  })  : _callback = callback,
        _backCallback = backCallback;

  /// Name of the requester.
  final String? name;

  /// The requested prayer.
  final String? prayer;

  /// The email of the requester.
  final String email;

  /// Date when we pray.
  final DateTime dateTime;

  /// Kind of the prayer when to pronounce the intention.
  final PrayerType prayerType;

  /// callback
  final VoidCallback? _callback;

  /// back callback
  final VoidCallback? _backCallback;

  @override
  Widget build(BuildContext context) {
    PrayerRequest request = context.read<PrayerRequestBloc>().state.request!;

    Widget _contentView = Container(
      padding: const EdgeInsets.all(Margins.mobileMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(38),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (request.name != null)
            Text("${request.name},",
                style: const TextStyle(
                  fontFamily: 'Aileron',
                  fontWeight: FontWeight.w600,
                  fontSize: 36,
                )),
          const Text("On prie pour vous pendant:"),
          InkWell(
            onTap: _backCallback,
            child: Text(
              AppLocalizations.of(context)!.prayingDate(
                request.prayerType.localizedToStringWithArticle(context),
                request.dateTime,
                request.dateTime,
              ),
              style: TextStyle(
                fontFamily: 'Aileron',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 26,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Paddings.listSeparator),
            child: Text(
              "\"${request.prayer}\"",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text("Intention de prière de ${request.name}, \n ${request.email}"),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _backCallback,
                  label: const Text("Modifier"),
                  icon: const Icon(Icons.arrow_back),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (_callback != null) _callback!();
                    context.read<PrayerRequestBloc>().add(
                        PrayerRequestCompletedEvent(
                            email: request.email,
                            prayer: request.prayer,
                            date: request.dateTime,
                            prayerType: request.prayerType));
                  },
                  child: const Text("Confirmer"),
                ),
              ],
            ),
          )
        ],
      ),
    );

    Widget child = Column(
      children: [
        prayerDecorationImage,
        _contentView,
      ],
    );

    return FormsLayoutBase(child: child);
  }
}

/// Title of the prayer request prompt.
final Widget title = Builder(
  builder: (context) => Text(
    AppLocalizations.of(context)!.shareYourPriers,
    style: Theme.of(context).textTheme.displaySmall,
  ),
);

Widget prayerDecorationImage = Container(
  constraints: const BoxConstraints(
    //   // maxWidth: 215,
    maxHeight: 250,
  ),
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage(
        AhlAssets.praying,
      ),
    ),
  ),
);
