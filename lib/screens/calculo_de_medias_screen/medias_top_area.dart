import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/screens/plano_de_ensino_viewer_screen/plano_de_ensino_viewer_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediasTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xEEEEEEEE),
      height: 100.0,
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: Colors.grey[700],
                      )),
                ),
                Expanded(
                  child: Text(
                    Provider.of<MediasBrain>(context)
                        .selectedCourseWithoutCourseCode(),
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, PlanoDeEnsinoViewerScreen.id);
                      },
                      icon: Icon(
                        Icons.description,
                        size: 30.0,
                        color: Colors.grey[700],
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 30.0,
                  child: Switch(
                    activeColor: Colors.green[700],
                    inactiveThumbColor: Colors.grey[200],
                    inactiveTrackColor: Colors.grey,
                    value: Provider.of<MediasBrain>(context)
                            .tipoDeMediaSelecionado ==
                        TiposDeCalculoMedia.parcial,
                    onChanged: (value) {
                      Provider.of<MediasBrain>(context).changeTipoMedia();
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<MediasBrain>(context).changeTipoMedia();
                  },
                  child: AutoSizeText(
                    'Médias Parciais',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  width: 10.0,
                  height: 32.0,
                  alignment: AlignmentDirectional.centerEnd,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Colors.grey[400],
                  ),
                ),
                Container(
                  width: 60.0,
                  height: 30.0,
                  child: Switch(
                    activeColor: Colors.blue[800],
                    inactiveThumbColor: Colors.grey[200],
                    inactiveTrackColor: Colors.grey,
                    value: Provider.of<MediasBrain>(context).mostrarDescricoes,
                    onChanged: (value) {
                      Provider.of<MediasBrain>(context)
                          .changeMostrarDescricoes();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<MediasBrain>(context)
                          .changeMostrarDescricoes();
                    },
                    child: AutoSizeText(
                      'Mostrar Descrições',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
