import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function(String) submit;
  final Function(String) onChanged;
  final Widget trailing;
  final TextEditingController ctrl;
  const SearchBox(
      {Key? key,
      required this.submit,
      required this.onChanged,
      required this.trailing,
      required this.ctrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 5,
        child: ListTile(
            leading: Icon(Icons.search),
            title: TextFormField(
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
