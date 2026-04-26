import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';

/// A tutorial walk-through that plays the "How to use the app" YouTube
/// playlist (PLt5MYkKh1HK43BGEI5y_uWl6UwvzCcDyM) one video at a time.
/// After the user finishes (or chooses to skip) all videos they are
/// invited to register, with a CTA that takes them to the sign-in screen.
class GuestScreenEn extends StatefulWidget {
  const GuestScreenEn({Key? key}) : super(key: key);

  @override
  State<GuestScreenEn> createState() => _GuestScreenEnState();
}

class _GuestScreenEnState extends State<GuestScreenEn> {
  /// Ordered tutorial videos. The order follows the natural flow a new
  /// user would take: register, then create an event, then add guests,
  /// and finally how to postpone or cancel.
  static const List<_TutorialVideo> _videos = [
    _TutorialVideo(id: 'EkzUzcAN8kM', titleKey: 'tutorialVideoRegister'),
    _TutorialVideo(id: 'RvG97-KZuD8', titleKey: 'tutorialVideoCreateEvent'),
    _TutorialVideo(id: '6K6hvm57i5Q', titleKey: 'tutorialVideoAddGuests'),
    _TutorialVideo(id: 'kWNKsmxfPBw', titleKey: 'tutorialVideoCancelEvent'),
  ];

  late final YoutubePlayerController _controller;
  int _currentIndex = 0;
  bool _currentVideoEnded = false;

  _TutorialVideo get _currentVideo => _videos[_currentIndex];
  bool get _isLastVideo => _currentIndex == _videos.length - 1;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _currentVideo.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'ar',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToVideo(int index) {
    if (index < 0 || index >= _videos.length) return;
    setState(() {
      _currentIndex = index;
      _currentVideoEnded = false;
    });
    _controller.load(_videos[index].id);
  }

  void _onVideoEnded() {
    if (!mounted || _currentVideoEnded) return;
    setState(() => _currentVideoEnded = true);
  }

  void _goToSignIn() {
    AppUtil.removeUntilNavigator(context, const SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      // YoutubePlayerBuilder ensures fullscreen rotation works correctly
      // and the player keeps state when the surrounding widget rebuilds.
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppUI.mainColor,
        progressColors: const ProgressBarColors(
          playedColor: AppUI.mainColor,
          handleColor: AppUI.secondColor,
        ),
        onEnded: (_) => _onVideoEnded(),
      ),
      builder: (context, player) {
        final progress = (_currentIndex + 1) / _videos.length;
        return Scaffold(
          backgroundColor: AppUI.whiteColor,
          appBar: AppBar(
            backgroundColor: AppUI.whiteColor,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: AppUI.greyColor),
            centerTitle: true,
            title: CustomText(
              text: 'tutorial'.tr(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: _goToSignIn,
                child: CustomText(
                  text: 'skip'.tr(),
                  color: AppUI.mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                player,
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: _currentVideo.titleKey.tr(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        text: '${_currentIndex + 1} / ${_videos.length}',
                        color: AppUI.greyColor,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppUI.backgroundColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppUI.mainColor),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      children: [
                        if (_isLastVideo && _currentVideoEnded)
                          _RegisterPromptCard(onRegister: _goToSignIn),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomButton(
                        text: _isLastVideo
                            ? 'register'.tr()
                            : 'nextVideo'.tr(),
                        onPressed: _isLastVideo
                            ? _goToSignIn
                            : () => _goToVideo(_currentIndex + 1),
                      ),
                      if (_currentIndex > 0) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _goToVideo(_currentIndex - 1),
                          child: CustomText(
                            text: 'previous'.tr(),
                            color: AppUI.greyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TutorialVideo {
  final String id;
  final String titleKey;
  const _TutorialVideo({required this.id, required this.titleKey});
}

class _RegisterPromptCard extends StatelessWidget {
  final VoidCallback onRegister;
  const _RegisterPromptCard({Key? key, required this.onRegister})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUI.inputColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x264970AE)), // mainColor @ 15% alpha
      ),
      child: Column(
        children: [
          const Icon(Icons.celebration_outlined,
              color: AppUI.mainColor, size: 44),
          const SizedBox(height: 12),
          CustomText(
            text: 'tutorialCompleted'.tr(),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'readyToStart'.tr(),
            color: AppUI.greyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
