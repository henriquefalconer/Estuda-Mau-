import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'gallery_viewer_bottom_area.dart';
import 'gallery_viewer_content.dart';
import 'gallery_viewer_top_area.dart';

class PhotosViewerScreen extends StatelessWidget {
  static String id = 'media_viewer_screen';

  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);
    monitoriaBrain.mediaViewPageController =
        PageController(initialPage: monitoriaBrain.selectedPhotoPage);
    return Scaffold(
      backgroundColor: monitoriaBrain.uiVisibleOnImageViewer
          ? Colors.grey[100]
          : Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                monitoriaBrain.changeUIVisibility;
              },
              child: MediaViewerContent(),
            ),
            Visibility(
              visible: monitoriaBrain.uiVisibleOnImageViewer,
              child: FutureBuilder(
                future: monitoriaBrain.getMessageInfoGalleryTopArea(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      monitoriaBrain.selectedPhotoPage == null) {
                    return MediaViewerTopArea(
                      sender: 'Carregando...',
                      time: 'Carregando...',
                    );
                  }
                  return MediaViewerTopArea(
                    sender: snapshot.data['sender'],
                    time: snapshot.data['time'],
                  );
                },
              ),
            ),
            Visibility(
              visible: monitoriaBrain.uiVisibleOnImageViewer,
              child: FutureBuilder(
                future: monitoriaBrain.messageTextForGalleryInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      monitoriaBrain.selectedPhotoPage == null) {
                    return MediaViewerBottomArea();
                  }
                  print(snapshot.data);
                  return MediaViewerBottomArea(
                    messageText: snapshot.data,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
