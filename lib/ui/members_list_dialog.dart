import 'package:flutter/material.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart' as twilio;
import 'dart:developer' as developer;

const String TAG = "MemberList Dialog";
class MembersListDialog extends StatefulWidget {
  twilio.ChannelDescriptor channelDescriptor;

  MembersListDialog(this.channelDescriptor);

  @override
  State<StatefulWidget> createState() => _MembersListDialogState();
}

class _MembersListDialogState extends State<MembersListDialog> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<twilio.Member>> _getMembersList() async {
    twilio.Channel channel = await widget.channelDescriptor.getChannel();
    return await channel.members.getMembersList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<twilio.Member>>(
          future: _getMembersList(),
          initialData: null,
          builder: (context, snapshot) {
            if ( snapshot.connectionState == ConnectionState.done && snapshot != null ) {
              developer.log("connected ${snapshot.data.length}", name: TAG);
              return Container(
                height: 300,
                child: ListView.builder(itemBuilder: (context, index) {
                  List<twilio.Member> memberList = snapshot.data;
                  twilio.Member s = memberList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(s.identity, style: TextStyle(fontSize: 18),),
                  );
                },
                shrinkWrap: true,
                itemCount: snapshot.data.length,),
              );
            } else {
              return Center(child: Text("Something went wrong :("));
            }
          },
        ),
      ),
    );
  }
}
