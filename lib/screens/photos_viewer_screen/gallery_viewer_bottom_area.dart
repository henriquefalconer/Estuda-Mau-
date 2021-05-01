import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
//import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gallery_viewer_screen.dart';

class MediaViewerBottomArea extends StatelessWidget {
  MediaViewerBottomArea({
    this.messageText,
  });

  final String messageText;

  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 1,
          thickness: 1,
        ),
        Container(
          width: double.infinity,
          color: Colors.grey[100],
          child: messageText == null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    messageText ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                    ),
                  ),
                ),
        ),
        Container(
          color: Colors.grey[100],
          height: 50.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: monitoriaBrain.currentChatGalleryPaths.length,
            itemBuilder: (BuildContext context, int index) {
              Widget photo = GestureDetector(
                onTap: () {
                  monitoriaBrain.changeMediaViewerPage(index);
                  Navigator.pushReplacementNamed(
                      context, PhotosViewerScreen.id);
                },
                child: Container(
                  height: 50.0,
                  width:
                      index == monitoriaBrain.selectedPhotoPage ? null : 30.0,
                  child: Image(
//                    image: FirebaseStorageImage(
//                      monitoriaBrain.currentChatGalleryPaths[index],
//                    ),
                    fit: index == monitoriaBrain.selectedPhotoPage
                        ? BoxFit.contain
                        : BoxFit.fitHeight,
                  ),
                ),
              );
              return Row(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                    width: index == monitoriaBrain.selectedPhotoPage ||
                            index == monitoriaBrain.selectedPhotoPage + 1
                        ? 10
                        : 2,
                  ),
                  photo
                ],
              );
            },
          ),
        ),
        Container(
          color: Colors.grey[100],
          child: Center(
            child: IconButton(
              padding: EdgeInsets.all(5.0),
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {},
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text(
                              'Salvar foto na galeria',
                              style: TextStyle(),
                            ),
                            onPressed: () async {
//                              String mediaPath =
//                                  monitoriaBrain.currentChatGalleryPaths[
//                                      monitoriaBrain.selectedPhotoPage];
//                              await GeneralFunctionsBrain.saveMediaToUserDevice(
//                                  mediaPath);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add_to_photos, size: 30.0),
            ),
          ),
        ),
      ],
    );
  }
}
