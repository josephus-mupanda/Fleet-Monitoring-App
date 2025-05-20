import 'package:flutter/material.dart';

import '../config/constants.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: Constants.kDefaultPadding),
            Text("Loading..."),
          ],
        ),
      );
    },
  );
}