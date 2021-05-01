import 'dart:async';
import 'dart:math';

import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingFullScreen extends StatefulWidget {
  LoadingFullScreen({
    this.cancelButtonOnTap,
    this.loadTime,
  });

  final Function cancelButtonOnTap;
  final int loadTime;

  @override
  _LoadingFullScreenState createState() => _LoadingFullScreenState();
}

class _LoadingFullScreenState extends State<LoadingFullScreen> {
  int secondsLeftForLoad;
  Timer timer;

  @override
  void initState() {
    super.initState();
    secondsLeftForLoad = widget.loadTime ?? 30;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        secondsLeftForLoad--;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 35.0,
                width: double.infinity,
              ),
              Text(
                'Baixando informações\ndo MAUAnet...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '(${secondsLeftForLoad < 1 ? 1 / (pow(2, 1 - secondsLeftForLoad)) : secondsLeftForLoad} s)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 70.0),
            child: RoundedButton(
              roundedButtonHeight: 20.0,
              buttonText: 'Cancelar',
              backgroundColor: Colors.red,
              onTap: widget.cancelButtonOnTap,
            ),
          ),
        ],
      ),
    );
  }
}
