import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class IntroVC extends StatefulWidget {
  const IntroVC({Key? key}) : super(key: key);

  @override
  State<IntroVC> createState() => _IntroVCState();
}

class _IntroVCState extends State<IntroVC> {
  PageController? pageCountroller;
  int currentPage = 0;
  YoutubePlayerController? controller;
  List arrVideos = [
    "hHCqzpr9t9w",
    "hwMGDTDoNPA",
    "hwMGDTDoNPA"
  ];

  initializePlayer(int index) {
    controller = YoutubePlayerController(
      initialVideoId: arrVideos[index],
      params: const YoutubePlayerParams(
        autoPlay: false,
        startAt: Duration(minutes: 0, seconds: 0),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    controller?.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    controller?.onExitFullscreen = () {};
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageCountroller = PageController(initialPage: currentPage);
    initializePlayer(0);
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.greenAccent, Colors.lightGreen])),
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                      initializePlayer(index);
                    });
                  },
                  controller: pageCountroller,
                  itemCount: arrVideos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Container(
                        color: Colors.black,
                        child: YoutubePlayerControllerProvider(
                          controller: controller!,
                          child: Center(
                            child: Stack(
                              children: [
                                player,
                                Positioned.fill(
                                  child: YoutubeValueBuilder(
                                    controller: controller,
                                    builder: (context, value) {
                                      return AnimatedCrossFade(
                                        firstChild: const SizedBox.shrink(),
                                        secondChild: Material(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    YoutubePlayerController
                                                        .getThumbnail(
                                                      videoId: controller!
                                                          .initialVideoId,
                                                      quality:
                                                          ThumbnailQuality.medium,
                                                    ),
                                                  ),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                ),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        crossFadeState: value.isReady
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                        duration:
                                            const Duration(milliseconds: 300),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 30),
              child: SmoothPageIndicator(
                controller: pageCountroller!,
                count: arrVideos.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 10,
                  dotColor: Colors.white54,
                  activeDotColor: Colors.white,
                  // type: WormType.thin,
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentPage == 0) {
                        print("Pop to Welcome");
                      } else {
                        pageCountroller?.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.bounceIn);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 25, right: 25, bottom: 10),
                        child: currentPage >= 1
                            ? Text(
                                "Previous",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )
                            : Text(
                                "Back",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (currentPage == arrVideos.length-1) {
                        print("Push to Sign Up");
                      } else {
                        pageCountroller?.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.bounceIn);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 25, right: 25, bottom: 10),
                        child: currentPage == arrVideos.length-1
                            ? Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )
                            : Text(
                                "Next",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
