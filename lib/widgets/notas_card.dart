import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'imageless_card.dart';

class NotasCard extends ImagelessButton {
  NotasCard({
    @required this.title,
    this.backgroundColor,
    @required this.media,
    this.pesoMedia = '',
    this.mainChild = const SizedBox(
      height: 15.0,
    ),
    this.textColor = kImagelessTextColor,
    this.redText,
    this.mediaText = '',
    this.sliderlessColors = false,
    this.mediaDiferenteMauaNet,
    this.showMedia = true,
  });

  final String title;
  final Color backgroundColor;
  final double media;
  final String pesoMedia;
  final Widget mainChild;
  final Color textColor;
  final Color redText;
  final String mediaText;
  final bool sliderlessColors;
  final bool mediaDiferenteMauaNet;
  final bool showMedia;

  final double titleSize = 19.0;

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
        color: sliderlessColors
            ? ((media ?? 6.0) >= 6.0
                ? ((media ?? 6.0) >= 9.0 ? Colors.green[600] : Colors.grey)
                : Colors.redAccent[100])
            : backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        elevation: 8.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        pesoMedia,
                        style:
                            TextStyle(color: Colors.grey[100], fontSize: 15.0),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showMedia,
                    child: Row(
                      children: <Widget>[
                        Text(
                          mediaText,
                          style: TextStyle(
                            color: textColor,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          (media == null
                              ? '---'
                              : '${(media * 10).round() / 10}'
                                  .replaceAll('.', ',')),
                          style: TextStyle(
                            color: ((media ?? 6.0) >= 6.0
                                ? ((media ?? 6.0) >= 9.0
                                    ? Colors.greenAccent[400]
                                    : Colors.white)
                                : redText ?? Colors.redAccent[200]),
                            fontSize: titleSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ((mediaDiferenteMauaNet ?? false) ? '*' : ''),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            mainChild,
          ],
        ),
      ),
    );
  }
}
