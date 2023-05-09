import 'package:flutter/material.dart';

class ExitDialog extends StatefulWidget {
  @override
  State<ExitDialog> createState() => _ExitDialogState();
}

class _ExitDialogState extends State<ExitDialog> {
  @override
Widget build(BuildContext context) {
 return Scaffold(
    body: WillPopScope(
      onWillPop: showExitDialog,
     child: Center(
       child: const Text("Hello People"),
      ),
          ),
  );
  }
  Future<bool> showExitDialog() async {
  return await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text("Exit app"),
      content: const Text("Do you want to exit this app?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("No")),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text ("Yes"))
      ],
    )
  );
}
}