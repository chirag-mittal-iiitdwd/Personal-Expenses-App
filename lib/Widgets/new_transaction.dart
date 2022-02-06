import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  // Not a finall property because initially this value will not have anything but as soon as user picks date this will contain a value
  DateTime _selectedDate;

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    // Ckecks some basic things before submitting
    // This is for submitting before completing the form
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    // Logic for addNewTransaction lies in main.dart as it is taking care of the state of the app
    widget.addNewTranaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    // This takes out the modal bottom sheet as soon as we click submit on soft keyboard or press button
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // The input card in the modal bottom sheet
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            // MediaQuery.of(context).viewInsets this gives us the information about anything that is lapping in the view
            // bottom property will tell us how much space is occupied by our soft keyboard
          ),
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
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "No Date Choosen!"
                            : "Picked Date : ${DateFormat.yMd().format(_selectedDate)}",
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _presentDatePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                // The buttons just in case the user wants to tap on some button and not keypad button
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Theme.of(context).textTheme.button.color),
                  ),
                ),
                onPressed: submitData,
                child: Text("Add Transaction"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
