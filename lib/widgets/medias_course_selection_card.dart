import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediasCourseSelectionCard extends StatelessWidget {
  MediasCourseSelectionCard({
    @required this.courseName,
    this.onTap,
    this.mediaMateria,
    this.mediaDiferenteMauaNet,
    this.planoDeEnsinoState,
  });

  final String courseName;
  final String mediaMateria;
  final Function onTap;
  final bool mediaDiferenteMauaNet;
  final PlanoDeEnsinoState planoDeEnsinoState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.grey[100],
        elevation: 5.0,
        child: MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: onTap,
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.0, top: 1.0),
                    child: double.parse((mediaMateria ?? '-1,0')
                                .replaceAll(',', '.')) >=
                            8.0
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                            size: 20.0,
                          )
                        : double.parse((mediaMateria ?? '-1,0')
                                    .replaceAll(',', '.')) >=
                                6.0
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.yellow[700],
                                size: 20.0,
                              )
                            : double.parse((mediaMateria ?? '-1,0')
                                        .replaceAll(',', '.')) !=
                                    -1.0
                                ? Icon(
                                    Icons.remove_circle,
                                    color: Colors.red[600],
                                    size: 20.0,
                                  )
                                : Icon(
                                    Icons.remove_circle,
                                    color: Colors.grey[600],
                                    size: 20.0,
                                  ),

//                    {
//                      PlanoDeEnsinoState.verificado: Icon(
//                        Icons.check_circle,
//                        color: Colors.green[700],
//                        size: 20.0,
//                      ),
//                      PlanoDeEnsinoState.naoVerificado: Icon(
//                        Icons.check_circle,
//                        color: Colors.yellow[700],
//                        size: 20.0,
//                      ),
//                      PlanoDeEnsinoState.vazio: Icon(
//                        Icons.remove_circle,
//                        color: Colors.red[600],
//                        size: 20.0,
//                      ),
//                    }[planoDeEnsinoState],
                  ),
                ),
                Text(
                  (mediaMateria ?? ''),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  ((mediaDiferenteMauaNet ?? false) ? '*' : ''),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.grey[700],
                  size: 31.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
