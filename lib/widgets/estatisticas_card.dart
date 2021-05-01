import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/statistics_brain.dart';
import 'package:estuda_maua/widgets/grafico_notas.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/widgets/selection_button.dart';
import 'package:estuda_maua/widgets/table_notas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstatisticasCard extends StatefulWidget {
  const EstatisticasCard({
    this.title,
    this.value,
  });

  final String title;
  final String value;

  @override
  _EstatisticasCardState createState() => _EstatisticasCardState();
}

class _EstatisticasCardState extends State<EstatisticasCard> {
  TiposDeCalculoMedia tiposMedia = TiposDeCalculoMedia.parcial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        right: 15.0,
        left: 15.0,
        bottom: 10.0,
      ),
      child: Material(
        color: Colors.red[200],
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        elevation: 8.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: AutoSizeText(
                              widget.title,
                              maxLines: 3,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            widget.value ?? '---',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: SelectionButton(
                                  onTap: () {
                                    tiposMedia = TiposDeCalculoMedia.parcial;
                                    setState(() {});
                                  },
                                  buttonText: 'Parcial',
                                  value: TiposDeCalculoMedia.parcial,
                                  groupValue: tiposMedia,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: SelectionButton(
                                  onTap: () {
                                    tiposMedia = TiposDeCalculoMedia.final_;
                                    setState(() {});
                                  },
                                  buttonText: 'Final',
                                  value: TiposDeCalculoMedia.final_,
                                  groupValue: tiposMedia,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          FutureBuilder(
                              future: Provider.of<StatisticsBrain>(context)
                                  .getUsersGraphInfo(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return GraficoNotas(
                                  data: snapshot.data,
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
