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
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width,
        // maxHeight: min(
        //   MediaQuery.of(context).size.height * 2 / 3,
        //   1124,
        // ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: 0.1,
          // scale: 10,
          // repeat: ImageRepeat.repeat,
          image: AssetImage(
            AhlAssets.requestMotif,
          ),
        ),
        color: theme.AhlTheme
            .blueNight, //Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: EdgeInsets.symmetric(
          vertical: Paddings.medium,
          horizontal: // (MediaQuery.of(context).size.width > ScreenSizes.extraLarge)
              //?
              Paddings.big
          // : Paddings.big,
          ),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Paddings.huge),
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
            // maxHeight: min(
            //   MediaQuery.of(context).size.height * 2 / 3,
            //   1124,
            // ),
          ),
          child: child,
        ),
      ),

      // switch (constraints.maxWidth) {
      //   case > ScreenSizes.extraLarge:
      //     return Align(
      //       alignment: Alignment.center,
      //       child: Container(
      //         constraints: BoxConstraints.loose(
      //           Size(
      //             ContentSize.maxWidth(MediaQuery.of(context).size.width),
      //             min(
      //               MediaQuery.of(context).size.height - 200,
      //               1124,
      //             ),
      //           ),
      //         ),
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(38),
      //         ),
      //         clipBehavior: Clip.antiAlias,
      //         child: container,
      //       ),
      //     );
      //   default:
      //     return Container(
      //       constraints: BoxConstraints.loose(
      //         Size(
      //           ContentSize.maxWidth(MediaQuery.of(context).size.width),
      //           min(
      //             MediaQuery.of(context).size.height - 200,
      //             1124,
      //           ),
      //         ),
      //       ),
      //       child: container,
      //     );
      // }
    );
  }
}
