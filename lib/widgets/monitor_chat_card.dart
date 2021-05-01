import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/widgets/user_avatar_with_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonitorCard extends StatelessWidget {
  MonitorCard({
    this.title,
    this.fotos = const [],
    this.monitorTypes = const [],
    this.photoTags = const [],
    this.onTap,
    this.semUsuariosText = 'Sem fotos',
  });

  final String title;
  final List<ImageProvider> fotos;
  final List<MonitorType> monitorTypes;
  final List<String> photoTags;
  final Function onTap;
  final String semUsuariosText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        onPressed: onTap,
        child: Column(
          children: <Widget>[
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: Builder(
                      builder: (context) {
                        List<Widget> photoGrid;

                        List<ImageProvider> fotosCopy = List.from(fotos);
                        List<MonitorType> showCheckCopy =
                            List.from(monitorTypes ?? []);
                        List<String> photoTagsCopy = List.from(photoTags);

                        int originalPhotosLength = fotosCopy.length;

                        double smallImagesSize = 15.0;

                        while (photoTagsCopy.length < 4) {
                          photoTagsCopy.add(null);
                        }

                        while (photoTagsCopy.length > 4) {
                          photoTagsCopy.removeLast();
                        }

                        while (showCheckCopy.length < 4) {
                          showCheckCopy.add(null);
                        }

                        while (showCheckCopy.length > 4) {
                          showCheckCopy.removeLast();
                        }

                        while (fotosCopy.length < 4) {
                          fotosCopy.add(null);
                        }

                        while (fotosCopy.length > 4) {
                          fotosCopy.removeLast();
                        }

                        if (originalPhotosLength == 0) {
                          photoGrid = [
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 30.0,
                              child: AutoSizeText(
                                semUsuariosText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14.0),
                                maxLines: 2,
                              ),
                            ),
                          ];
                        } else if (originalPhotosLength == 1) {
                          photoGrid = [
                            UserAvatarWithMonitorType(
                              fotoSize: 30.0,
                              foto: fotosCopy[0],
                              monitorType: showCheckCopy[0],
                              photoTag: photoTagsCopy[0],
                            ),
                          ];
                        } else if (originalPhotosLength == 2) {
                          photoGrid = <Widget>[
                            UserAvatarWithMonitorType(
                              fotoSize: smallImagesSize,
                              foto: fotosCopy[0],
                              monitorType: showCheckCopy[0],
                              photoTag: photoTagsCopy[0],
                            ),
                            UserAvatarWithMonitorType(
                              fotoSize: smallImagesSize,
                              foto: fotosCopy[1],
                              monitorType: showCheckCopy[1],
                              photoTag: photoTagsCopy[1],
                            ),
                          ];
                        } else if (originalPhotosLength == 3) {
                          photoGrid = <Widget>[
                            Row(
                              children: <Widget>[
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[0],
                                  monitorType: showCheckCopy[0],
                                  photoTag: photoTagsCopy[0],
                                ),
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[1],
                                  monitorType: showCheckCopy[1],
                                  photoTag: photoTagsCopy[1],
                                ),
                              ],
                            ),
                            UserAvatarWithMonitorType(
                              fotoSize: smallImagesSize,
                              foto: fotosCopy[2],
                              monitorType: showCheckCopy[2],
                              photoTag: photoTagsCopy[2],
                            ),
                          ];
                        } else if (originalPhotosLength == 4) {
                          photoGrid = <Widget>[
                            Row(
                              children: <Widget>[
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[0],
                                  monitorType: showCheckCopy[0],
                                  photoTag: photoTagsCopy[0],
                                ),
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[1],
                                  monitorType: showCheckCopy[1],
                                  photoTag: photoTagsCopy[1],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[2],
                                  monitorType: showCheckCopy[2],
                                  photoTag: photoTagsCopy[2],
                                ),
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[3],
                                  monitorType: showCheckCopy[3],
                                  photoTag: photoTagsCopy[3],
                                ),
                              ],
                            ),
                          ];
                        } else {
                          photoGrid = <Widget>[
                            Row(
                              children: <Widget>[
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[0],
                                  monitorType: showCheckCopy[0],
                                  photoTag: photoTagsCopy[0],
                                ),
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[1],
                                  monitorType: showCheckCopy[1],
                                  photoTag: photoTagsCopy[1],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                UserAvatarWithMonitorType(
                                  fotoSize: smallImagesSize,
                                  foto: fotosCopy[2],
                                  monitorType: showCheckCopy[2],
                                  photoTag: photoTagsCopy[2],
                                ),
                                CircleAvatar(
                                  radius: smallImagesSize,
                                  child: Text(
                                    '+${originalPhotosLength - 3}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.grey[600],
                                ),
                              ],
                            ),
                          ];
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: photoGrid,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 60.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title ?? '',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Visibility(
                            visible: fotos.length == 0,
                            child: Text(
                              'Sem monitores',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.grey[700],
                    size: 31.0,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
