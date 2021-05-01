import 'package:charts_flutter/flutter.dart' as charts;
import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/material.dart';

class GraficoNotas extends StatelessWidget {
  GraficoNotas({
    @required this.data,
  });

  final List<InfoGraphBar> data;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<InfoGraphBar, String>> series = [
      charts.Series(
          data: data,
          seriesColor: charts.ColorUtil.fromDartColor(Colors.white),
          domainFn: (InfoGraphBar series, _) => series.getBarName,
          measureFn: (InfoGraphBar series, _) => series.quantidadeDeAlunos,
          colorFn: (InfoGraphBar series, _) => series.getBarColor),
    ];

    return Column(
      children: <Widget>[
        Container(
          height: 300.0,
          child: Row(
            children: <Widget>[
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                  'Alunos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Notas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
