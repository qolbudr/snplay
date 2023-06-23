import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snplay/constant.dart';

class MovieBannerWidget extends StatelessWidget {
  const MovieBannerWidget({super.key, this.banner, this.name});
  final String? banner, name;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 8 / 5,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: banner ?? '-',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(1),
                  Colors.transparent,
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
            child: Stack(
              children: [
                Text(
                  name ?? '-',
                  style: h3,
                ),
                Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: defaultButtonStyle.copyWith(
                        backgroundColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      ),
                      child: const Icon(Icons.play_arrow),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
