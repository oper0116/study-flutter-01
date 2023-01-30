import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          print('Back');
          Navigator.pop(context);
        },
        child: Text('Back'),
      )),
    );
  }
}
