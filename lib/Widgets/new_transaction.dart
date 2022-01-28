import 'package:flutter/material.dart';

// We are using stateful widget because the input fields were dissappearing as soon as we go onto next thing to enter, because sateless widget reloads as soon as it detects a change
class NewTransaction extends StatefulWidget {
  // Taking the add new trnsaction function from main.dart
  // Passed to the State using widget.addNewTranaction
  final Function addNewTranaction;

  NewTransaction({@required this.addNewTranaction});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

  // These take care of the input flelds
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void submitData() {
    // Ckecks some basic things before submitting
    // This is for submitting before completing the form
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    // Logic for addNewTransaction lies in main.dart as it is taking care of the state of the app
    widget.addNewTranaction(
      enteredTitle,
      enteredAmount,
    );

    // This takes out the modal bottom sheet as soon as we click submit on soft keyboard or press button
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    // The input card in the modal bottom sheet
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              // controller ensures that the inputed data goes to titleController
              controller: titleController,

              // if the input is complete and the user uses submit button on keyboard then the function gets triggeterd and checks come background checks and thereby rejects or accepts the values
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // Ensures the input data goes to right field
              controller: amountController,
              // Gives the number keypad so that only double values can be typed
              keyboardType: TextInputType.number,

              // if the input is complete and the user uses submit button on keyboard then the function gets triggeterd and checks come background checks and thereby rejects or accepts the values
              onSubmitted: (_) => submitData(),
            ),
            FlatButton(

              // The buttons just in case the user wants to tap on some button and not keypad button
              textColor: Colors.purple,
              onPressed: submitData,
              child: Text("Add Transaction"),
            )
          ],
        ),
      ),
    );
  }
}
