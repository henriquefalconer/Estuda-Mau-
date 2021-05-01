import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/screens/photos_viewer_screen/gallery_viewer_screen.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/widgets/date_bubble.dart';
import 'package:estuda_maua/widgets/photos_grid.dart';
//import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoGridViewScreen extends StatelessWidget {
  static String id = 'media_grid_view_Screen';

  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: 'Fotos da conversa',
            ),
            Expanded(
              child: StreamBuilder(
                stream: monitoriaBrain.getMessagesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Widget> gridList = [];
                  List<Widget> photoSquaresList = [];
                  int photoIndex = 0;

                  String previousMessageTime =
                      DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String();

                  for (DocumentSnapshot message in snapshot.data.documents) {
                    if (message.data['photo'] != null) {
                      if (GeneralFunctionsBrain.getDayStartingHourFromString(
                              message.data['time'])
                          .isAfter(DateTime.parse(previousMessageTime))) {
                        if (photoSquaresList.length != 0) {
                          final List<Widget> photoSquaresListCopy =
                              List.from(photoSquaresList);
                          gridList.add(
                            PhotosGrid(photosList: photoSquaresListCopy),
                          );
                          photoSquaresList.clear();
                        }
                        gridList.add(
                          SizedBox(
                            height: 15.0,
                          ),
                        );
                        gridList.add(
                          DateBubble(
                            nextMessagesTime: message.data['time'],
                          ),
                        );
                      }

                      final int photoPosition = photoIndex;

                      photoSquaresList.add(
                        Material(
                          elevation: 5.0,
                          child: InkWell(
                            onTap: () {
                              monitoriaBrain.selectedPhotoPage = photoPosition;
                              Navigator.pushNamed(
                                  context, PhotosViewerScreen.id);
                            },
                            child: message.data['photo_uploading']
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Image(
//                                    image: FirebaseStorageImage(
//                                        message.data['photo']),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      );
                      previousMessageTime = message.data['time'];

                      photoIndex++;
                    }
                  }

                  if (photoSquaresList.length != 0) {
                    final List<Widget> photoSquaresListCopy =
                        List.from(photoSquaresList);
                    gridList.add(
                      PhotosGrid(photosList: photoSquaresListCopy),
                    );
                    photoSquaresList.clear();
                  }

                  if (gridList.length == 0) {
                    return Center(
                      child: Text(
                        'Não há fotos nesta conversa.',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 20.0),
                      ),
                    );
                  }

                  return ListView(
                    children: gridList,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
