import 'package:estuda_maua/screens/profile_photo_full_screen/profile_photo_full_screen.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/profile_photo_full_screen_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonitoriaChatTopArea extends StatelessWidget {
  MonitoriaChatTopArea({
    @required this.infoOnTap,
    @required this.returnOnTap,
    this.nome,
    this.descricao,
    this.isOtherUserOnline,
    this.foto,
  });

  final Function returnOnTap;
  final Function infoOnTap;
  final String nome;
  final String descricao;
  final bool isOtherUserOnline;
  final maxLengthDescription = 25;
  final ImageProvider foto;

  @override
  Widget build(BuildContext context) {
    MonitoriaBrain monitoriaBrain = Provider.of<MonitoriaBrain>(context);

    return Column(
      children: <Widget>[
        Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: returnOnTap,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Colors.grey[700],
                    )),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        nome ?? '',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        '$descricao',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
//                      Stack(
//                        alignment: AlignmentDirectional.centerEnd,
//                        children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.only(
//                                right:
//                                    isOtherUserOnline ?? false ? 43.0 : 45.0),
//                            child: Text(
//                              '$descricao - ',
//                              style: TextStyle(
//                                fontSize: 15.0,
//                                color: Colors.grey[500],
//                              ),
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
//                            ),
//                          ),
//                          Text(
//                            isOtherUserOnline ?? false ? 'Online' : 'Offline',
//                            style: TextStyle(
//                              fontSize: 15.0,
//                              color:
//                                  isOtherUserOnline ? Colors.green : Colors.red,
//                            ),
//                          ),
//                        ],
//                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: InkWell(
                  onTap: () {
                    Provider.of<ProfilePhotoFullScreenBrain>(context).nome =
                        nome;
                    Provider.of<ProfilePhotoFullScreenBrain>(context).image =
                        foto;
                    Navigator.pushNamed(context, ProfilePhotoFullScreen.id);
                  },
                  child: Hero(
                    tag:
                        '${monitoriaBrain.selectedMonitoriaData.monitoria}: ${monitoriaBrain.receiverRA}',
                    child: CircleAvatar(
                      backgroundImage: foto,
                      radius: 25.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
