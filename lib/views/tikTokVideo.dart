import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/tikTokVideoGesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///
/// A TikTok-style video page component that overlays the video and provides the following functions:
/// The mask of the play button
/// Click event
/// Like event callback (every time)
/// Aspect ratio control
/// Bottom padding (used when there is an immersive bottom status bar)
///
class TikTokVideoPage extends StatelessWidget {
  final Widget? video;
  final double aspectRatio;
  final String? tag;
  final double bottomPadding;

  final Widget? rightButtonColumn;
  final Widget? userInfoWidget;

  final bool hidePauseIcon;

  final Function? onAddFavorite;
  final Function? onSingleTap;

  const TikTokVideoPage({
    Key? key,
    this.bottomPadding: 16,
    this.tag,
    this.rightButtonColumn,
    this.userInfoWidget,
    this.onAddFavorite,
    this.onSingleTap,
    this.video,
    this.aspectRatio: 9 / 16.0,
    this.hidePauseIcon: false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // list of buttons on the right
    Widget rightButtons = rightButtonColumn ?? Container();
    // User Info
    Widget userInfo = userInfoWidget ??
        VideoUserInfo(
          bottomPadding: bottomPadding,
        );
    // animation for video loading
    // Widget videoLoading = VideoLoadingPlaceHolder(tag: tag);
    // video playback page
    Widget videoContainer = Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          alignment: Alignment.center,
          child: Container(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: video,
            ),
          ),
        ),
        TikTokVideoGesture(
          onAddFavorite: onAddFavorite,
          onSingleTap: onSingleTap,
          child: Container(
            color: ColorPlate.clear,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        hidePauseIcon
            ? Container()
            : Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 120,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
      ],
    );
    Widget body = Container(
      child: Stack(
        children: <Widget>[
          videoContainer,
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomRight,
            child: rightButtons,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            child: userInfo,
          ),
        ],
      ),
    );
    return body;
  }
}

class VideoLoadingPlaceHolder extends StatelessWidget {
  const VideoLoadingPlaceHolder({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: <Color>[
            Colors.blue,
            Colors.green,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(
            size: 36,
            color: Colors.white.withOpacity(0.3),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: Text(
              tag,
              style: StandardTextStyle.normalWithOpacity,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoUserInfo extends StatelessWidget {
  final String? desc;
  // final Function onGoodGift;
  const VideoUserInfo({
    Key? key,
    required this.bottomPadding,
    // @required this.onGoodGift,
    this.desc,
  }) : super(key: key);

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        bottom: bottomPadding,
      ),
      margin: EdgeInsets.only(right: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '@Zhu Erdan\'s boring life',
            style: StandardTextStyle.big,
          ),
          Container(height: 6),
          Text(
            desc ??
                '#Original rich people\'s life is so unpretentious and boring #shortvideo',
            style: StandardTextStyle.normal,
          ),
          Container(height: 6),
          Row(
            children: <Widget>[
              Icon(Icons.music_note, size: 14),
              Expanded(
                child: Text(
                  'The original sound of Zhu Erdan\'s boring life',
                  maxLines: 9,
                  style: StandardTextStyle.normal,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
