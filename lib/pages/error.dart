import 'package:flutter/material.dart';
import 'package:flutterbowl/server/server.dart';

import 'protobowl.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.redAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Unable to connect to Protobowl",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24
              ),
            ),
            FlatButton.icon(onPressed: () async {
              bool refresh = await server.refreshServer();
              if (refresh) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProtobowlPage()),);
              }
            },
                icon: Icon(Icons.refresh,
                  color: Colors.white,),
                label: Text("Try Again",
                    style: TextStyle(color: Colors.white))
            )
          ],
        ),
      ),
    );
  }

}
