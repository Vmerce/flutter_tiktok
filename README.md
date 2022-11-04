# flutter_tiktok

A flutter app imitating Douyin. It mainly realizes the function of watching video, you can swipe the video very smoothly, slide left and right, and click a little love.

Flutter_web is currently supported, but the experience in mobile browsers is very limited.

# New features (in development)

🎉Welcome everyone to pay attention to this project. I originally wanted to wait for the official videoplayer to support all platforms before expanding to all platforms.

But now I see that there are players for various platforms on pub, so this project will soon support all platforms 🎉🎉🎉.

The following features are under development and planned to be supported:

- Re-enable fijkplayer on iOS/Android system
- Support MacOS system
- Support Linux system
- Support Windows system

# Project FAQ
1. ** and Douyin are not like **: the main interaction has been fully realized, and you can modify the page according to your own business needs.
2. **UI performance issues**: On both Android and iOS, this project is very smooth and has no performance issues. It will be relatively laggy on the web, especially on the mobile web platform, because the performance of the flutter web itself is limited, and the performance of the mobile browser is also weak, so we can only wait for the official optimization here.

If you have other questions, you can also add Q group feedback

<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/ images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Joining the group requires answering basic knowledge questions.

# implement the function

- Swipe the video up and down, the video will automatically load the cover, support unlimited pull-down to load the video, dynamically add a player, and control the memory usage
- Support the player before releasing, and support re-init when sliding back (does not depend on widget life cycle)
- Support preload video, you can control the number of preload
- Swipe left and right to search and personal center
- Double click to like the heart
- see comments
- Toggle Bottom Tabbar

# application screenshot

![Screenshot1](./screenshot.png)

# detail

Adapted to different scale screens, on slender screens, the bottom tabbar will not be superimposed on the video:


![Screenshot 1](./screen.png)

The picture shows the effect of forced adjustment under debug. The App will automatically determine the current screen ratio of the phone.


# other

For other pages that do not belong to the video business, the style is simply copied. If you need to customize the project, you can simply replace it with various pages written by yourself.

If you need to add videos infinitely, you only need to add videos to the array when the PageView slides to the end, it's very simple.

After loading a certain amount of video, remember to release the unused player to avoid flashback due to too much memory usage.

# project structure


rely:
````yaml
  # Load the animation library (it seems that it is not used after the revision)
  flutter_spinkit: ^4.1.2
  # Bilibili open source video playback component
  fijkplayer: ^0.8.3
  # Basic transparent animation click effect
  tapped: any
  # map safe value
  safemap: any
````
Main files:
```bash
./lib
├── main.dart
├── mock
│ └── video.dart # Fake data
├── other
│ └── bottomSheet.dart # Modified the height of the system BottomSheet
├── pages
│ ├── cameraPage.dart # Shooting page (no actual function)
│ ├── followPage.dart # Omitted
│ ├── homePage.dart # The main page, including the actual application functions of tikTokScaffold
│ ├── msgDetailListPage.dart # Omitted
│ ├── msgPage.dart # Omitted
│ ├── searchPage.dart # Omitted
│ ├── todoPage.dart # Omitted
│ ├── userDetailPage.dart # Omitted
│ ├── userPage.dart # Omitted
│ └── walletPage.d # Omitted
├── style
│ ├── style.dart # Global text size and color
│ └── text.dart # The main text styles
└── views
    ├── backButton.dart # iOS shaped back button component
    ├── loadingButton.dart # Button component that can be set as loading style
    ├── selectText.dart # Text that can be set to "selected" or "unselected" style
    ├── tikTokCommentBottomSheet.dart # Imitation TikTok comment style
    ├── tikTokHeader.dart # Imitation Tiktok top switch component
    ├── tikTokScaffold.dart # Imitation Tiktok core scaffolding, encapsulates functions such as gestures and switching, and does not contain UI content itself
    ├── tikTokVideo.dart # Tiktok-like video UI style package, does not include video playback
    ├── tikTokVideoButtonColumn.dart # Imitation of the button column components such as the avatar and like on the right side of the Tiktok video
    ├── tikTokVideoGesture.dart # Imitation of TikTok's double-click like effect
    ├── tikTokVideoPlayer.dart # Video playback page, with VideoListController class that controls sliding
    ├── tiktokTabBar.dart # Imitation of the bottom Tabbar component of Tiktok
    ├── tilTokAppBar.dart # Appbar component imitating Tiktok
    ├── topToolRow.dart # The top state of the user page, hide the back button when the tab switches to the user page
    └── userMsgRow.dart # A style component for user information
````

# thanks

The left and right swipe gesture code comes from the package of the author of the project https://github.com/ditclear/tiktok_gestures, thanks here.

# treat me to coffee

I believe that the code of this project will definitely help you in commercial projects. If you benefit from this project, please invite the author to have a cup of coffee:

![Take me a coffee](./pay.png)