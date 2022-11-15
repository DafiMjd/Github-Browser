import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function(String) submit;
  final Function(String) onChanged;
  final Widget trailing;
  final TextEditingController ctrl;
  final bool enabled;
  const SearchBox(
      {Key? key,
      required this.submit,
      required this.onChanged,
      required this.trailing,
      required this.ctrl,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 5,
        child: ListTile(
            leading: const Icon(Icons.search),
            title: TextFormField(
              enabled: enabled,
              controller: ctrl,
              onFieldSubmitted: submit,
              onChanged: onChanged,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Search repos/users/issues'),
            ),
            trailing: trailing),
      ),
    );
  }
}
