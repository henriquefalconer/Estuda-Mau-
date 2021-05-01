import 'package:flutter/cupertino.dart';

class PhotosGrid extends StatelessWidget {
  const PhotosGrid({
    @required this.photosList,
  });

  final List<Widget> photosList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (photosList.length / 4).ceil() * 100.0,
      child: GridView.count(
        padding: EdgeInsets.all(5.0),
        primary: false,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        crossAxisCount: 4,
        reverse: false,
        children: photosList,
      ),
    );
  }
}
