import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/tilTokAppBar.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class UserDetailPage extends StatefulWidget {
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    Widget head = TikTokAppbar(
      title: 'User',
    );
    var userHead = Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Personal information',
              style: StandardTextStyle.smallWithOpacity,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Revise',
            style: StandardTextStyle.smallWithOpacity.apply(
              color: ColorPlate.orange,
            ),
          ),
        )
      ],
    );
    Widget body = ListView(
      padding: EdgeInsets.only(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
      ),
      children: <Widget>[
        userHead,
        _UserInfoRow(
          title: 'nickname',
          rightIcon: Text(
            'The boring life of Zhu Erdan',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'avatar',
          rightIcon: Text(
            'upload',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'Mobile phone binding',
          rightIcon: Text(
            '186****7767',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'Address',
          rightIcon: Text(
            'Nanhai Avenue, Nanshan District, Shenzhen',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'age',
          rightIcon: Text(
            '18',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'User gender',
          rightIcon: Text(
            'male',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'Occupation',
          rightIcon: Text(
            'President',
            style: StandardTextStyle.small,
          ),
        ),
      ],
    );
    body = Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: body,
      ),
    );
    return Scaffold(
      body: Container(
        color: ColorPlate.back1,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            head,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  _UserInfoRow({
    this.icon,
    this.title,
    this.rightIcon,
    this.onTap,
  });
  final Widget? icon;
  final Widget? rightIcon;
  final String? title;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    Widget iconImg = Container(
      height: 24,
      width: 24,
      child: icon,
    );

    Widget row = Container(
      height: 48,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: <Widget>[
          icon != null ? iconImg : Container(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                title!,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: rightIcon ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
          ),
        ],
      ),
    );
    row = Tapped(
      onTap: onTap,
      child: row,
    );

    return row;
  }
}
