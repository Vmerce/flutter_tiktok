import 'package:flutter_tiktok/pages/msgDetailListPage.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/tilTokAppBar.dart';
import 'package:flutter_tiktok/views/userMsgRow.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class MsgPage extends StatefulWidget {
  @override
  _MsgPageState createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
  int select = 0;
  @override
  Widget build(BuildContext context) {
    Widget head = TikTokSwitchAppbar(
      index: select,
      list: ['information'],
      onSwitch: (i) => setState(() => select = i),
    );
    Widget topButtons = Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _TopIconTextButton(
            title: 'Fans',
            icon: Icons.person,
            color: Colors.indigo,
            color2: Colors.green,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (cxt) => MsgDetailListPage(
                    title: 'Fans',
                    msgTitle: 'You fans',
                    msgDesc: 'I\'m your fan',
                  ),
                ),
              );
            },
          ),
          _TopIconTextButton(
            title: 'Likes',
            icon: Icons.golf_course,
            color: Colors.teal,
            color2: Colors.blue,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (cxt) => MsgDetailListPage(
                    title: 'Likes',
                    msgTitle: 'Your Likes',
                    msgDesc: 'Liked you',
                  ),
                ),
              );
            },
          ),
          _TopIconTextButton(
            title: '@',
            icon: Icons.people,
            color: Colors.deepPurple,
            color2: Colors.pink,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (cxt) => MsgDetailListPage(
                    title: '@',
                    msgTitle: 'Mentiones',
                    msgDesc: 'John mentioned you',
                    reverse: true,
                  ),
                ),
              );
            },
          ),
          _TopIconTextButton(
            title: 'Comments',
            icon: Icons.mode_comment,
            color: Colors.red,
            color2: Colors.amber,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (cxt) => MsgDetailListPage(
                    title: 'Comment',
                    msgTitle: 'Old iron double-click 666',
                    msgDesc: 'Your followers',
                    reverse: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    Widget ad = Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: AspectRatio(
        aspectRatio: 4.0,
        child: Container(
          decoration: BoxDecoration(
            color: ColorPlate.darkGray,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            'Reserved carousel',
            style: TextStyle(
              color: Colors.white.withOpacity(0.1),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
    Widget body = Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: <Widget>[
          topButtons,
          ad,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'System',
              style: StandardTextStyle.smallWithOpacity,
            ),
          ),
          UserMsgRow(
            lead: ClipOval(
              child: Container(
                color: ColorPlate.back2,
                child: Icon(
                  Icons.done_all,
                  color: ColorPlate.orange,
                ),
              ),
            ),
            title: 'Conversations',
            desc: 'You have received 3 conversations',
          ),
          UserMsgRow(
            lead: ClipOval(
              child: Container(
                color: ColorPlate.back2,
                child: Icon(
                  Icons.business,
                  color: ColorPlate.orange,
                ),
              ),
            ),
            title: 'System',
            desc: '12 unread system messages',
          ),
          UserMsgRow(
            lead: ClipOval(
              child: Container(
                color: ColorPlate.back2,
                child: Icon(
                  Icons.business,
                  color: ColorPlate.orange,
                ),
              ),
            ),
            title: 'Notification',
            desc: '98 unread notifications',
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Private messages',
              style: StandardTextStyle.smallWithOpacity,
            ),
          ),
          UserMsgRow(),
          UserMsgRow(),
          UserMsgRow(),
          UserMsgRow(),
          UserMsgRow(),
          UserMsgRow(),
        ],
      ),
    );
    body = Container(
      color: ColorPlate.back1,
      child: Column(
        children: <Widget>[
          head,
          body,
        ],
      ),
    );
    return body;
  }
}

class _TopIconTextButton extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final Color color2;
  final String? title;
  final Function? onTap;

  const _TopIconTextButton({
    Key? key,
    this.icon,
    this.color,
    this.title,
    this.color2: Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconContainer = Container(
      margin: EdgeInsets.all(6),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            color2,
            color!,
          ],
          stops: [0.1, 0.8],
        ),
      ),
      child: Icon(
        icon,
      ),
    );
    Widget body = Column(
      children: <Widget>[
        iconContainer,
        Text(
          title!,
          style: StandardTextStyle.small,
        )
      ],
    );
    body = Tapped(
      child: body,
      onTap: onTap,
    );
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: body,
      ),
    );
  }
}
