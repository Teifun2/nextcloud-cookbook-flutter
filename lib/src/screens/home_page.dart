import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/authentication_bloc.dart';
import '../services/authentication_events.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookbook App'),
          actions: <Widget>[
      // action button
           IconButton(
              icon: Icon(Icons.delete, semanticLabel: 'Logoff',),
             onPressed: () {
               BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
           ),
          ]
      ),
      body: Container(
        child: Center(
            child: RaisedButton(
              child: Text('logout'),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            )),
      ),
    );
  }
}
