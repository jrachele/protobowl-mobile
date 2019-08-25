import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RateSlider extends StatefulWidget {
  @override
  _RateSliderState createState() => _RateSliderState();
}

class _RateSliderState extends State<RateSlider> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, double>(converter: (Store<AppState> store) {
      return store.state.room.rate.toDouble();
    }, builder: (BuildContext context, double rate) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Icon(FontAwesomeIcons.fastForward),
            margin: EdgeInsets.fromLTRB(8, 0, 32, 0),
          ),
          Container(
            child: Text("Rate: $rate")
          ),
          Expanded(
              child: Slider(
            min: 10,
            max: 110,
            value: rate,
//                    label: "Rate",
            onChanged: (speed) {
              setState(() {
                server.setSpeed(speed);
              });
            },
          )),
        ],
      );
    });
  }
}
