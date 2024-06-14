part of 'rosary.dart';

class RosaryPrompt extends StatelessWidget {
  const RosaryPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    // todo: make it dynamic image with storage
    // final Reference imageRef =
    //     storage.child('/static/sj.jpg');
    // final imageUrl = imageRef.getDownloadURL();

    // var image = imageRef.getData();

    return PromptCard(
      callback: () => Navigator.of(context).pushNamed(RosaryPage.routeName),
      backgroundImage: AssetImage(
        AhlAssets.rosaryHeroHeader,
      ),
      title: Text(
        AppLocalizations.of(context)!.todaysRosary,
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.rosarySlogan,
      ),
    );
  }
}
