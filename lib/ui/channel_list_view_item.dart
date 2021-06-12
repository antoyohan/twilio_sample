import 'package:flutter/material.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

class ChannelListViewWidget extends StatefulWidget {
  ChannelListViewWidget({Key key, @required this.channelDescriptor})
      : super(key: key);
  final ChannelDescriptor channelDescriptor;

  @override
  _ChannelListViewWidgetState createState() => _ChannelListViewWidgetState();
}

class _ChannelListViewWidgetState extends State<ChannelListViewWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFF5F5F5),
      elevation: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
            child: Container(
              width: 60,
              height: 60,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                'https://picsum.photos/seed/291/600',
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.channelDescriptor.friendlyName,
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              Container(
                constraints: BoxConstraints( maxWidth: 100),
                child: Text(
                  widget.channelDescriptor.sid,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFF9F9F9F),
                  ),
                ),
              ),
              Text(
                'Hello World',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF9F9F9F),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
