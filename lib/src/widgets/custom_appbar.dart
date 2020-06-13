import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          FaIcon(FontAwesomeIcons.chevronLeft),
          Spacer(),
          FaIcon(FontAwesomeIcons.commentAlt),
          SizedBox(width: 20,),
          FaIcon(FontAwesomeIcons.headphonesAlt),
          SizedBox(width: 20,),
          FaIcon(FontAwesomeIcons.externalLinkAlt),
        ],
      ),
    );
  }
}