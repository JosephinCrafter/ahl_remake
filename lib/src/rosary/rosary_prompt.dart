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
      backgroundImage: AssetImage(
        AhlAssets.rosaryHeroHeader,
      ),
      title: Text(
        "Chapelet du jour",
      ),
      subtitle: Text(
        "Mediter la vie de Jesus avec Marie",
      ),
    );
  }
}
