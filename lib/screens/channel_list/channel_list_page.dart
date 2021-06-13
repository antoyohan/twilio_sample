import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilio_sample/models/channel_model.dart';
import 'package:twilio_sample/repository/user_repository.dart';
import 'package:twilio_sample/screens/channel_list/channel_list_bloc.dart';
import 'package:twilio_sample/screens/channel_list/channel_list_state.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
          key: scaffoldKey,
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
                    Container(
                      width: 70,
                      height: 70,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://picsum.photos/seed/423/600',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: TextFormField(
                    onChanged: (_) => setState(() {}),
                    controller: textController,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF9F9F9F),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF9F9F9F),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      suffixIcon: textController.text.isNotEmpty
                          ? InkWell(
                              onTap: () => setState(
                                () => textController.clear(),
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF757575),
                                size: 22,
                              ),
                            )
                          : null,
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF5E5E5E),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
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
                      return getListView(state.chatModel);
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
        ),
      ),
    );
  }

  Widget getListView(ChannelModel chatModel) {
    var count = chatModel.publicChannels.length + chatModel.userChannels.length;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getItemWidget(chatModel, index);
        },
        itemCount: count);
  }

  Widget getItemWidget(ChannelModel chatModel, int index) {
    ChannelDescriptor channelDescriptor;
    if (index < chatModel.publicChannels.length) {
      channelDescriptor = chatModel.publicChannels[index];
    } else {
      channelDescriptor =
          chatModel.userChannels[index - chatModel.publicChannels.length];
    }
    return ChannelListViewWidget(channelDescriptor: channelDescriptor);
  }

  @override
  void dispose() {
    _channelListBloc.dispose();
    super.dispose();
  }
}
