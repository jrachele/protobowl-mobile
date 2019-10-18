import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RateSlider extends StatefulWidget {
  @override
  _RateSliderState createState() => _RateSliderState();
}

class _RateSliderState extends State<RateSlider> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RateViewModel>(converter: (Store<AppState> store) {
      return RateViewModel(
        rate: store.state.room.rate,
        lock: store.state.player.lock
      );
    }, builder: (BuildContext context, RateViewModel viewModel) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Icon(FontAwesomeIcons.fastForward),
            margin: EdgeInsets.fromLTRB(8, 0, 32, 0),
          ),
          Container(
            child: Text("Rate: ${viewModel.rate}")
          ),
          Expanded(
              child: Slider(
            min: 10,
            max: 110,
            value: viewModel.rate.toDouble(),
//                    label: "Rate",
            onChanged: viewModel.lock ? null : (speed) {
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

class RateViewModel {
  final int rate;
  final bool lock;
  RateViewModel({this.rate, this.lock});
}
