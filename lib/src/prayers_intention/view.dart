part of 'prayer_request.dart';

/// The route view to collect, setup date and confirm prayers
/// request.
///
/// This widget is an AnimatedSwitcher with 4 children.
///
/// This class should be used under the bloc of managing it's state.
///
/// [email],[dateTime],[prayer] and [prayerType] should be not null.
// // todo: Change variable to a PrayerRequests model.
class PrayersIntentionRequestView extends StatefulWidget {
  const PrayersIntentionRequestView({super.key});

  @override
  State<PrayersIntentionRequestView> createState() =>
      _PrayersIntentionRequestViewState();
}

class _PrayersIntentionRequestViewState
    extends State<PrayersIntentionRequestView>
    with SingleTickerProviderStateMixin {
  late List<Widget> views;

  late String? name;
  late String email;
  late DateTime dateTime;
  late String prayer;
  late PrayerType prayerType;
  late PageController _controller;
  late AnimationController lottieController;

  @override
  void initState() {
    views = [
      PrayerCollectView(
        key: const ValueKey(1),
        callback: nextView,
      ),
      PrayerDateCollectionView(
        key: const ValueKey(2),
        callback: nextView,
        backCallback: previousView,
      ),
      ReviewPrayerView(
        backCallback: previousView,
        callback: nextView,
      ),
      FormsLayoutBase(
        child: Container(
          alignment: Alignment.center,
          child: DotLottieLoader.fromAsset(
            "animations/done.lottie",
            frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
              if (dotlottie != null) {
                return Lottie.memory(
                  dotlottie.animations.values.single,
                  controller: lottieController,
                  onLoaded: (p0) => lottieController.forward(),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    ];

    _controller = PageController(
      keepPage: true,
    );
    lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            if (lottieController.status == AnimationStatus.completed) {
              _controller.animateToPage(0,
                  duration: duration, curve: Curves.easeIn);
            }
          });

    super.initState();
  }

  // // todo: change to 0 after building dateView view
  final duration = Durations.medium2;
  final curvesIn = Curves.easeIn;
  final curvesOut = Curves.easeOut;

  void _submitPrayer() => setState(
        () {
          _controller.animateToPage(
            0,
            duration: duration,
            curve: curvesIn,
          );
        },
      );

  void nextView() => setState(
        () {
          _controller.nextPage(
            duration: duration,
            curve: curvesIn,
          );
        },
      );

  void previousView() => setState(() {
        _controller.previousPage(
          duration: duration,
          curve: curvesIn,
        );
      });

  // test to setup animation
  final bool _isGoingForward = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrayerRequestBloc>(
      create: (context) => PrayerRequestBloc(
        PrayerRequestRepo(
          db: firestore,
        ),
      ),
      lazy: true,
      // child: AnimatedSwitcher(
      //   switchInCurve: curvesIn,
      //   switchOutCurve: curvesOut,
      //   layoutBuilder: (currentChild, previousChildren) => Stack(
      //     alignment: Alignment.topCenter,
      //     children: [
      //       ...previousChildren,
      //       if (currentChild != null) currentChild,
      //     ],
      //   ),
      //   transitionBuilder: (child, animation) {
      //     return (_isGoingForward)
      //         ? child
      //             .animate(
      //               autoPlay: false,
      //               target: 1,
      //             )
      //             .slideX(begin: 1, end: 0, duration: duration, curve: curvesIn)
      //         : child.animate(autoPlay: false, target: 1).slideX(
      //             begin: -1, end: 0, duration: duration, curve: curvesOut);
      //   },
      //   duration: duration,
      //   child: views[_index],

      // ),
      child: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            // Size.fromHeight(
            //   min(
            //     MediaQuery.of(context).size.height * 5 / 6,
            //     1124,
            //   ),
            // ),
            maxWidth: MediaQuery.sizeOf(context).width,
            maxHeight:
                (MediaQuery.of(context).size.width < ScreenSizes.extraLarge)
                    ? 900
                    : 657,
          ),
          child: PageView(
            controller: _controller,
            allowImplicitScrolling: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: views,
          ),
        ),
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
    Axis direction =
        (MediaQuery.of(context).size.width > ScreenSizes.extraLarge)
            ? Axis.horizontal
            : Axis.vertical;
    final Widget child = LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints,
        child: Flex(
          direction: direction,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: prayerDecorationImage,
                  ),
                  Flexible(
                    flex: 1,
                    child: title,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 350,
                      child: Text(
                        "${context.read<PrayerRequestBloc>().state.request?.prayer}",
                        style: resolveBodyTextThemeForBreakPoints(
                            MediaQuery.of(context).size.width, context),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.labelLarge!,
                      child: (context
                                  .read<PrayerRequestBloc>()
                                  .state
                                  .request!
                                  .name !=
                              null)
                          ? Text(
                              AppLocalizations.of(context)!.priersOf(
                                context
                                    .read<PrayerRequestBloc>()
                                    .state
                                    .request!
                                    .name!,
                                context
                                    .read<PrayerRequestBloc>()
                                    .state
                                    .request!
                                    .email,
                              ),
                            )
                          : Text(context
                              .read<PrayerRequestBloc>()
                              .state
                              .request!
                              .email),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(Paddings.big),
            Flexible(
              flex: (direction == Axis.vertical) ? 3 : 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: Paddings.listSeparator),
                    padding: //(constraints.maxWidth > ScreenSizes.mobile)
                        // ?

                        const EdgeInsets.all(Margins.medium),
                    //: const EdgeInsets.all(Margins.mobileSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
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
                              selectedIcon: const Icon(Icons.done)
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
                          child: const Text("Choisir la date:"),
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
                            initialCalendarMode: DatePickerMode.day,
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
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
            ),
          ],
        ),
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

  late final GlobalKey<FormState> _formKey;

  PrayerRequest? _request;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>(debugLabel: toString());
    super.initState();

    try {
      _request = context.read<PrayerRequestBloc>().state.request;
    } catch (e) {
      _request = PrayerRequest(
        name: "Unknown",
        email: "",
        prayer: "(vide)",
        dateTime: DateTime.now(),
        prayerType: PrayerType.rosary,
      );
    }
    _name.text = _request?.name ?? "";
    _email.text = _request?.email ?? "";
    _prayer.text = _request?.prayer ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Axis direction =
        (MediaQuery.of(context).size.width > ScreenSizes.extraLarge)
            ? Axis.horizontal
            : Axis.vertical;
    final Widget child = Form(
      key: _formKey,
      child: Flex(
        direction: direction,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: prayerDecorationImage,
                ),
                Flexible(
                  flex: 1,
                  child: title,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      top: Paddings.big, bottom: Paddings.listSeparator),
                  child: Text(AppLocalizations.of(context)!.proverb,
                      style: Theme.of(context).textTheme.labelMedium),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppLocalizations.of(context)!.priersInvitation,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(Paddings.big),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: Paddings.big),
                    padding: const EdgeInsets.all(Paddings.medium),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.prayerRequestInvitation,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        //name and First name
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Paddings.listSeparator),

                          /// Name
                          child: TextFormField(
                            controller: _name,
                            decoration: InputDecoration(
                              helperText:
                                  AppLocalizations.of(context)!.optional,
                              label: Text(AppLocalizations.of(context)!
                                  .nameAndFirstName),
                            ),
                          ),
                        ),

                        /// Email
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: Paddings.listSeparator),
                          child: TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              label: Text("Email*"),
                            ),
                            validator: (value) {
                              if (!isValidEmail(value ?? "")) {
                                return AppLocalizations.of(context)!
                                    .invalidEmail;
                              }

                              return null;
                            },
                          ),
                        ),

                        /// Prayer
                        Flexible(
                          child: TextFormField(
                            // minLines: 5,
                            maxLines: 10,
                            controller: _prayer,
                            // maxLines: 3,
                            decoration: InputDecoration(
                              // constraints: const BoxConstraints(minHeight: 250),
                              label: Text(
                                  "${AppLocalizations.of(context)!.priers}*"),
                              hintText:
                                  AppLocalizations.of(context)!.yourPrayer,
                            ),
                            validator: (value) {
                              if (value == null || value == "") {
                                return AppLocalizations.of(context)!
                                    .cantBeEmpty;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Buttons
                Container(
                  alignment: Alignment.centerRight,
                  // padding: const EdgeInsets.only(bottom: Paddings.listSeparator),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        trySnack(() {
                          // execute callback or nothing
                          if (widget._callback != null) widget._callback!();
                          context.read<PrayerRequestBloc>().add(
                                PrayerRequestFilledFormEvent(
                                  name: _name.value.text,
                                  email: _email.value.text,
                                  prayer: _prayer.value.text,
                                ),
                              );
                        }, context);
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.sendPray),
                  ),
                ),
              ],
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
class ReviewPrayerView extends StatefulWidget {
  const ReviewPrayerView({
    super.key,
    VoidCallback? callback,
    VoidCallback? backCallback,
  })  : _callback = callback,
        _backCallback = backCallback;

  /// callback
  final VoidCallback? _callback;

  /// back callback
  final VoidCallback? _backCallback;

  @override
  State<ReviewPrayerView> createState() => _ReviewPrayerState();
}

class _ReviewPrayerState extends State<ReviewPrayerView> {
  @override
  Widget build(BuildContext context) {
    PrayerRequest? request = context.watch<PrayerRequestBloc>().state.request;

    Widget contentView = Container(
      padding: const EdgeInsets.all(Margins.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(38),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (request?.name != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "${request?.name},",
                style: const TextStyle(
                  fontFamily: 'Aileron',
                  fontWeight: FontWeight.w600,
                  fontSize: 36,
                ),
              ),
            ),
          Text(AppLocalizations.of(context)!.wePrayOn),
          InkWell(
            splashFactory: InkRipple.splashFactory,
            canRequestFocus: true,
            enableFeedback: true,
            onTap: widget._backCallback,
            child: request != null
                ? Text(
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
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Paddings.listSeparator),
            child: Text(
              "\"${request?.prayer}\"",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "-${request?.email}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: widget._backCallback,
                  label: const Text("Modifier"),
                  icon: const Icon(Icons.arrow_back),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: (request != null)
                      ? () {
                          context.read<PrayerRequestBloc>().add(
                                PrayerRequestCompletedEvent(
                                  name: request.name,
                                  email: request.email,
                                  prayer: request.prayer,
                                  date: request.dateTime,
                                  prayerType: request.prayerType,
                                ),
                              );
                          context
                              .read<PrayerRequestBloc>()
                              .add(PrayerRequestInitializeEvent());

                          if (widget._callback != null) widget._callback!();
                        }
                      : null,
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
        Flexible(
          flex: 2,
          child: prayerDecorationImage,
        ),
        contentView,
      ],
    );

    return FormsLayoutBase(child: child);
  }
}

/// Title of the prayer request prompt.
final Widget title = Builder(
  builder: (context) => Text(
    AppLocalizations.of(context)!.priesIntention,
    style: resolveHeadlineTextThemeForBreakPoints(
      MediaQuery.of(context).size.width,
      context,
    ),
  ),
);

Widget prayerDecorationImage = Container(
  // width: 215,
  // height: 141,
  decoration: BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.contain,
      image: AssetImage(
        AhlAssets.praying,
      ),
    ),
  ),
);

void trySnack(
  Function fun,
  BuildContext context, {
  String message = "Erreur Server. Recharger la page!",
}) {
  try {
    fun();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ),
    );
  }
}
