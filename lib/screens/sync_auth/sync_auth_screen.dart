import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SyncAuthScreen extends StatefulWidget {
  final bool register;

  SyncAuthScreen({this.register = false});

  @override
  _SyncAuthScreenState createState() => _SyncAuthScreenState();
}

class _SyncAuthScreenState extends State<SyncAuthScreen> {
  bool isUrlValid = false;
  bool isSecretValid = false;
  bool isUsernameValid = false;
  bool isPasswordValid = false;

  TextEditingController urlController = TextEditingController();
  TextEditingController secretController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final urlRegex = RegExp(
      '((http|https)://)[a-zA-Z0-9@:%._\\+~#?&//=]{1,256}',
      caseSensitive: true,
      dotAll: true,
    );

    urlController.addListener(() {
      setState(() {
        try {
          isUrlValid = urlRegex.hasMatch(urlController.text);
        } catch (e) {
          isUrlValid = false;
        }
      });
    });

    secretController.addListener(() {
      setState(() {
        isSecretValid = secretController.text.isNotEmpty;
      });
    });

    usernameController.addListener(() {
      setState(() {
        isUsernameValid = usernameController.text.length > 3;
      });
    });

    passwordController.addListener(() {
      setState(() {
        isPasswordValid = passwordController.text.length > 7;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          !widget.register ? 'Login' : 'Register', // TODO: localize
          style: TextStyle(
            letterSpacing: 1.25,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: context.getString('back_tooltip'),
          icon: Icon(Feather.x_circle),
        ),
        actions: [
          IconButton(
            onPressed: isSecretValid &&
                    isUrlValid &&
                    isUsernameValid &&
                    isPasswordValid
                ? () {}
                : null,
            tooltip: context.getString('done_tooltip'),
            icon: Icon(Feather.check_circle),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          children: [
            TextFormField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Server URL'.toUpperCase(),
                errorText: isUrlValid ? null : 'The entered URL is not valid',
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.url,
              onFieldSubmitted: (val) {
                // usernameFocus.requestFocus();
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: secretController,
              decoration: InputDecoration(
                labelText: 'Server Secret'.toUpperCase(),
                errorText:
                    isSecretValid ? null : 'Server secret should not be empty',
              ),
              // focusNode: usernameFocus,
              obscureText: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (val) {
                // passwordFocus.requestFocus();
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username'.toUpperCase(),
                errorText: isUsernameValid
                    ? null
                    : 'Username should be more than 4 characters',
              ),
              // focusNode: passwordFocus,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (val) {
                // notesFocus.requestFocus();
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: context.getString('password').toUpperCase(),
                errorText: isPasswordValid
                    ? null
                    : 'Password should be more than 8 characters',
              ),
              // focusNode: passwordFocus,
              obscureText: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (val) {
                // notesFocus.requestFocus();
              },
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    urlController.dispose();
    secretController.dispose();
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
