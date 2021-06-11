import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_sample/repository/authentication_repository.dart';
import 'package:twilio_sample/repository/services/network_service.dart';
import 'package:twilio_sample/repository/user_repository.dart';
import 'package:twilio_sample/screens/login/login_bloc.dart';
import 'package:twilio_sample/screens/login/login_event.dart';
import 'package:twilio_sample/screens/login/login_state.dart';
import 'dart:developer' as developer;
const String TAG = "loginPage";
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textController;
  Bloc _loginbloc;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loginbloc = LoginBloc(UnknownState(),
        AuthenticationRepoImpl(NetworkServiceImpl(), UserRepoImpl()));
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 2),
                child: TextFormField(
                  onChanged: (_) => setState(() {}),
                  controller: textController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter you username',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9E9E9E),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9E9E9E),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
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
                ),
              ),
              BlocConsumer(
                  bloc: _loginbloc,
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      developer.log("login success" ,name: TAG);
                    }
                  },
                  builder: (context, event) {
                    return MaterialButton(
                      child: Text("Login"),
                      color: Color(0xFF5BA2DF),
                      onPressed: () {
                        _loginbloc.add(LoginSubmitted(textController.text));
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
