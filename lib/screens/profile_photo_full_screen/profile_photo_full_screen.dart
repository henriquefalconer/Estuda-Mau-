import 'package:estuda_maua/utilities/profile_photo_full_screen_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ProfilePhotoFullScreen extends StatelessWidget {
  static String id = 'profile_photo_full_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: Provider.of<ProfilePhotoFullScreenBrain>(context).nome,
              onReturn: () {
                Navigator.pop(context);
                Provider.of<ProfilePhotoFullScreenBrain>(context).heroTag =
                    null;
              },
            ),
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        Provider.of<ProfilePhotoFullScreenBrain>(context).image,
                    initialScale: PhotoViewComputedScale.contained * 0.4,
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: Provider.of<ProfilePhotoFullScreenBrain>(context)
                              .heroTag ??
                          'user_picture',
                    ),
                  );
                },
                itemCount: 1,
                loadingChild: Center(
                  child: CircularProgressIndicator(),
                ),
                backgroundDecoration: BoxDecoration(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
