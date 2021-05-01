import 'package:estuda_maua/utilities/monitoria_brain.dart';
//import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class MediaViewerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);

    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
//            imageProvider: FirebaseStorageImage(
//              monitoriaBrain.currentChatGalleryPaths[index],
//            ),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(
              tag: monitoriaBrain.currentChatGalleryPaths[index],
            ),
          );
        },
        itemCount: monitoriaBrain.currentChatGalleryPaths.length,
        loadingChild: Center(
          child: CircularProgressIndicator(),
        ),
        backgroundDecoration: BoxDecoration(),
        pageController: monitoriaBrain.mediaViewPageController,
        onPageChanged: (int newPage) {
          monitoriaBrain.changeMediaViewerPage(newPage);
        },
      ),
    );
  }
}
