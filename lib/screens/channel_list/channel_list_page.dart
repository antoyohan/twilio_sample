import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilio_sample/models/channel_model.dart';
import 'package:twilio_sample/repository/user_repository.dart';
import 'package:twilio_sample/screens/channel_list/channel_list_bloc.dart';
import 'package:twilio_sample/screens/channel_list/channel_list_state.dart';
import 'package:twilio_sample/ui/add_channel_dialog.dart';
import 'package:twilio_sample/ui/profile_dialog.dart';
import 'package:twilio_sample/ui/channel_list_view_item.dart';
import 'package:twilio_sample/utils/string_contants.dart';

const String TAG = "Channel listPage";

class ChannelListPage extends StatefulWidget {
  ChannelListPage({Key key}) : super(key: key);

  @override
  _ChannelListPageState createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  TextEditingController textController;
  ChannelListBloc _channelListBloc;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _channelListBloc = ChannelListBloc(ChannelLoading(), UserRepoImpl());
    _channelListBloc.loadChatClient();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => _channelListBloc,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xFF5BA2DF),
            automaticallyImplyLeading: true,
            title: Text(
              Strings.MESSAGE_TITLE,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xFFF7F3F3),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showProfileDialog(_channelListBloc.chatClient.users.myUser);
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://picsum.photos/seed/423/600',
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
            centerTitle: true,
            elevation: 4,
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder(
                  bloc: _channelListBloc,
                  builder: (context, state) {
                    developer.log("state : $state ", name: TAG);
                    if (state is ChannelLoading) {
                      return Expanded(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    } else if (state is ChannelsModel) {
                      var channels = getChannels(state);
                      return getListView(channels);
                    } else {
                      return Expanded(
                          child: Center(
                        child: Text(
                          "Something went Wrong",
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _showAddChannelDialog,
          ),
        ),
      ),
    );
  }

  List<ChannelDescriptor> getChannels(ChannelsModel state) {
    var channelModel = state.channelModel;
    var publicChannels = channelModel.publicChannels.where((publicChannel) => !channelModel.userChannels.any((userChannel) => userChannel.sid == publicChannel.sid)).toList();
    var channels = [...channelModel.userChannels, ...publicChannels];
    return channels;
  }

  Widget getListView(List<ChannelDescriptor> channels) {
    var count = channels.length;
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return getItemWidget(channels[index]);
          },
          itemCount: count),
    );
  }

  Widget getItemWidget(ChannelDescriptor channelDescriptor) {
    return ChannelListViewWidget(channelDescriptor: channelDescriptor);
  }

  Future _showAddChannelDialog() async {
    var result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) {
          return AddChannelDialog();
        });
    if (result != null && result['name'] != null && result['name'].isNotEmpty) {
      await _channelListBloc.addChannel(result['name'], result['type']);
    }
  }

  Future _showProfileDialog(User myUser) async {
    var result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) {
          return ProfileDialog(myUser);
        });

  }

  @override
  void dispose() {
    _channelListBloc.dispose();
    super.dispose();
  }
}
