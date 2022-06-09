import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/package.dart';
import 'package:collection/collection.dart';
import 'package:python_vocab_trainer/model/class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageListing extends StatefulWidget {
  Package package;
  List<bool> expandedClasses = [];

  PackageListing(this.package) {
    expandedClasses =
        List.filled(package.getClasses(recursive: true).length, false);
  }

  @override
  State<StatefulWidget> createState() {
    return PackageListingState();
  }
}

class PackageListingState extends State<PackageListing> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _hide_private_methods = true;

  Future<void> _set_hide_private_methods(bool bol) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _hide_private_methods = bol;
      prefs.setBool('hide_private_methods', _hide_private_methods);
    });
  }

  void load_hide_private_methods() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _hide_private_methods = (prefs.getBool('hide_private_methods') ?? true);
    });
  }

  @override
  void initState() {
    super.initState();
    load_hide_private_methods();
  }

  @override
  Widget build(BuildContext context) {
    List<Class> _classes = widget.package.getClasses(recursive: true);
    return Scaffold(
        appBar: AppBar(
          title: Text('Package ${widget.package.name}'),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: CheckboxListTile(
                        onChanged: (bol) {
                          setState(() {
                            _set_hide_private_methods(bol == true);
                          });
                        },
                        value: _hide_private_methods,
                        title: Text("Hide private methods")))
              ];
            }),
          ],
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Functions",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.left,
              ),
              Column(
                children: widget.package
                    .getFunctions(
                  recursive: true,
                  hide_internal_functions: _hide_private_methods,
                )
                    .map((f) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${f.moduleName}.",
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                        ListTile(
                            title: Text(
                                "${f.name} (${f.parameters.map((param) => param.name).join(", ")})"),
                            subtitle: Text(f.description)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Text("Classes", style: Theme.of(context).textTheme.headline5),
              ExpansionPanelList(
                children: _classes.mapIndexed((i, c) {
                  return ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.moduleName,
                            style: TextStyle(color: Colors.grey[300]),
                          ),
                          ListTile(
                            title: Text(
                                "${c.name} (${c.constructors.map((param) => param.name).join(", ")} )"),
                            subtitle: Text(c.description),
                          ),
                        ],
                      );
                    },
                    body: Container(
                      color: Colors.grey[100],
                      child: Column(
                        children: c.getFunctions(skip_internal_funcs: _hide_private_methods).map((f) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.moduleName,
                                  style: TextStyle(color: Colors.grey[300])),
                              ListTile(
                                title: Text(
                                    "${f.name} (${f.parameters.map((param) => param.name).join(", ")})"),
                                subtitle: Text(f.description),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    isExpanded: widget.expandedClasses[i],
                    canTapOnHeader: true,
                  );
                }).toList(),
                expansionCallback: (panelIndex, isExpanded) {
                  widget.expandedClasses = List.filled(
                      widget.package.getClasses(recursive: true).length, false);
                  widget.expandedClasses[panelIndex] = !isExpanded;
                  setState(() {});
                },
              ),
            ],
          ),
        )));
  }
}
