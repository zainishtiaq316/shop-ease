import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopease/controllers/banners-controllers.dart';

class BannerWidet extends StatefulWidget {
  const BannerWidet({super.key});

  @override
  State<BannerWidet> createState() => _BannerWidetState();
}

class _BannerWidetState extends State<BannerWidet> {
  final CarouselController carouselController = CarouselController();
  final BannersControllers _bannersControllers = Get.put(BannersControllers());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return CarouselSlider(
          items: _bannersControllers.bannerUrls
              .map(
                (imageUrls) => ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrls,
                      fit: BoxFit.cover,
                      width: Get.width - 10,
                      placeholder: (context, url) => ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      errorWidget: ((context, url, error) => Icon(Icons.error)),
                    )),
              )
              .toList(),
          options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              aspectRatio: 2.5,
              viewportFraction: 1),
        );
      }),
    );
  }
}
