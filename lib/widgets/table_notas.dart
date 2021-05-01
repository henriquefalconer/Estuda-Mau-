import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/statistics_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

class TableNotas extends StatefulWidget {
  @override
  _TableNotasState createState() => _TableNotasState();
}

class _TableNotasState extends State<TableNotas> {
  @override
  Widget build(BuildContext context) {
    StatisticsBrain statisticsBrain = Provider.of<StatisticsBrain>(context);

    return Builder(
      builder: (context) {
        Widget _generateFirstColumnRow(BuildContext context, int index) {
          return Container(
            color: Colors.grey,
            child: Text(
              statisticsBrain.usersStatistics[index].position.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          );
        }

        Widget _generateRightHandSideColumnRow(
            BuildContext context, int index) {
          return Row(
            children: <Widget>[
              Container(
                child: Text(
                  statisticsBrain.usersStatistics[index].userRA,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    statisticsBrain.usersStatistics[index].mediaGeral >= 8.0
                        ? Icon(
                            Icons.grade,
                            color: Colors.amber,
                          )
                        : SizedBox(),
                    Text(
                      GeneralFunctionsBrain.roundNumber(
                              statisticsBrain.usersStatistics[index].mediaGeral,
                              3)
                          .toString()
                          .replaceAll('.', ','),
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
            ],
          );
        }

        Widget _getTitleItemWidget(String label, {double width}) {
          return Container(
            color: Colors.grey,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            width: width,
            height: 56,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          );
        }

        List<Widget> _getTitleWidget() {
          return [
            FlatButton(
              padding: EdgeInsets.all(0),
              child: _getTitleItemWidget(
                'Posição${statisticsBrain.sortArrow(SortType.position)}',
                width: 100,
              ),
              onPressed: statisticsBrain.onPositionPressed,
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              child: _getTitleItemWidget(
                'RA${statisticsBrain.sortArrow(SortType.RA)}',
                width: 100,
              ),
              onPressed: statisticsBrain.onRAPressed,
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              child: _getTitleItemWidget(
                'Nota${statisticsBrain.sortArrow(SortType.nota)}',
                width: 100,
              ),
              onPressed: statisticsBrain.onNotaPressed,
            )
          ];
        }

        return HorizontalDataTable(
          leftHandSideColumnWidth: 100,
          rightHandSideColumnWidth: 200,
          isFixedHeader: true,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: statisticsBrain.usersStatistics.length,
          rowSeparatorWidget: const Divider(
            color: Colors.white,
            height: 1.0,
            thickness: 1.0,
          ),
        );
      },
    );
  }
}
