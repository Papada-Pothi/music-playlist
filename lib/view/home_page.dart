import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplaylistapp/controller/home_controller.dart';

class HomePage extends GetWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist"),
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.playlist.length,
              itemBuilder: (context, index) {
                final song = controller.playlist[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(song.musicImage)),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.musicName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(song.singer),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.play(index);
                        },
                        icon: const Icon(Icons.play_circle_outline_sharp),
                        iconSize: 30,
                      ),
                    ],
                  ),
                );
              }),
        ),
        Obx(() => controller.showPlaying == true
            ? _bottomPalying()
            : const SizedBox())
      ],
    );
  }

  Widget _bottomPalying() {
    return Obx(() => Container(
          width: Get.width,
          height: 150,
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            children: [
              Slider(
                  onChanged: (value) {
                    controller.seek(value);
                  },
                  value: controller.currentPosition),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        controller.playlist[controller.currentSong].musicImage,
                      )),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.playlist[controller.currentSong].musicName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        controller.playlist[controller.currentSong].singer,
                      ),
                    ],
                  ),
                ),
                controller.isPlaying == false
                    ? IconButton(
                        onPressed: () {
                          controller.resume();
                        },
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 30,
                      )
                    : IconButton(
                        onPressed: () {
                          controller.pause();
                        },
                        icon: const Icon(Icons.pause),
                        iconSize: 30,
                      ),
                IconButton(
                  onPressed: () {
                    controller.close();
                  },
                  icon: const Icon(Icons.close),
                  iconSize: 30,
                )
              ]),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
