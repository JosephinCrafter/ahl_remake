part of 'widgets.dart';

final GlobalKey<FormState> _formKey =
    GlobalKey<FormState>(debugLabel: "prayer_request_key");

class FormsLayoutBase extends StatelessWidget {
  const FormsLayoutBase({
    super.key,
    Function? callback,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final Widget container = Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        constraints: BoxConstraints.loose(
          const Size.fromWidth(1129),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Paddings.huge,
          horizontal: (constraints.maxWidth > ScreenSizes.mobile)
              ? Paddings.big
              : Paddings.medium,
        ),
        child: child,
      );
      switch (constraints.maxWidth) {
        case > 1000:
          return Align(
            alignment: Alignment.center,
            child: Container(
              // constraints: BoxConstraints.loose(
              //   const Size(1129, 784),
              // ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
              ),
              clipBehavior: Clip.antiAlias,
              child: container,
            ),
          );
        default:
          return container;
      }
    });
  }
}
