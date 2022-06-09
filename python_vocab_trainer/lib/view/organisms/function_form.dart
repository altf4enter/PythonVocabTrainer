import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/func.dart';
import 'package:python_vocab_trainer/view/organisms/parameter_forms.dart';

class FunctionForm extends StatefulWidget {
  Func f;
  FunctionForm(this.f);
  @override
  State<StatefulWidget> createState() {
    return FunctionFormState();
  }
}

class FunctionFormState extends State<FunctionForm> {
  bool guessed_correctly = false;
  bool display_parameter_forms = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(widget.f.description,
              style: Theme.of(context).textTheme.headline5),
          TextFormField(
            validator: (String? value) {
              return widget.f.equals(value.toString())
                  ? 'That is not the correct function name.'
                  : null;
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
          guessed_correctly
              ? 
              Column(children: widget.f.parameters.map((param){
                return ParameterForm(param);
              }).toList(),)
              : Container(),
        ],
      ),
    );
  }
}
