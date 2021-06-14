import 'package:flutter/material.dart';
import 'package:twilio_programmable_chat/src/parts.dart';


class ProfileDialog extends StatefulWidget {
  User myUser;

  ProfileDialog(this.myUser);

  @override
  State<StatefulWidget> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Friendly Name: ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.myUser.friendlyName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey),
            ),
            Text(
              'Identity: ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
            ),
            Text(
              widget.myUser.identity,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
