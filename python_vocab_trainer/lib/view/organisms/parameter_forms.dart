import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/parameter.dart';

class ParameterForm extends StatefulWidget {
  Parameter parameter;

  ParameterForm(this.parameter);
  @override
  State<StatefulWidget> createState() {
    return ParameterFormState();
  }

}

class ParameterFormState extends State<ParameterForm> {
  final _formKey = GlobalKey<FormState>();
  bool guessed_correctly = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(widget.parameter.description,
              style: Theme.of(context).textTheme.headline5),
          TextFormField(
            validator: (String? value) {
              return widget.parameter.equals(value.toString())
                  ? null: null; //TODO - 'That is not the correct parameter name.';
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  guessed_correctly = true;
                });
              }
            },
            child: guessed_correctly
                ? const Icon(Icons.check)
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }
  
}