import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/class.dart';
import 'package:python_vocab_trainer/model/func.dart';
import 'package:python_vocab_trainer/view/organisms/function_form.dart';
import 'package:python_vocab_trainer/view/organisms/parameter_forms.dart';

class ClassForm extends StatefulWidget {
  Class c;
  ClassForm(this.c);
  @override
  State<StatefulWidget> createState() {
    return ClassFormState();
  }
}

class ClassFormState extends State<ClassForm> {
  bool guessed_correctly = false;
  bool display_parameter_forms = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(widget.c.description,
              style: Theme.of(context).textTheme.headline5),
          TextFormField(
            validator: (String? value) {
              return widget.c.equals(value.toString())
                  ? 'That is not the correct classname.'
                  : null;
            },
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(
                      () {
                        guessed_correctly = true;
                      },
                    );
                  }
                },
                child: Row(
                  children: [
                    guessed_correctly
                        ? const Icon(Icons.check)
                        : const Text('Submit')
                  ],
                ),
              ),
              guessed_correctly
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() => display_parameter_forms = true);
                      },
                      child: Text("Learn Classmethods"))
                  : Container()
            ],
          ),
          display_parameter_forms
              ? Column(
                  children: widget.c.functions.map((f) {
                    return FunctionForm(f);
                  }).toList(),
                )
              : Container()
        ],
      ),
    );
  }
}
