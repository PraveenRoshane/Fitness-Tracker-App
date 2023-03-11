import 'package:flutter/material.dart';

class DiscoverSmallCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final double? width;
  final Widget? vectorBottom;
  final Widget? vectorTop;
  final double? borderRadius;
  final Widget? icon;
  final Function()? onTap;
  const DiscoverSmallCard(
      {Key? key,
      this.title,
      this.subtitle,
      this.gradientStartColor,
      this.gradientEndColor,
      this.height,
      this.width,
      this.vectorBottom,
      this.vectorTop,
      this.borderRadius,
      this.icon,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap ?? () {},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              gradientStartColor ?? const Color(0xff441DFC),
              gradientEndColor ?? const Color(0xff4E81EB),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: 125,
              width: 150,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 125,
                width: 150,
                child: Stack(
                  children: const [
                    // SizedBox(
                    //   height: 125,
                    //   width: 150,
                    //   child: SvgAsset(assetName: AssetName.vectorSmallBottom),
                    // ),
                    // SizedBox(
                    //   child: SvgAsset(
                    //       height: 125,
                    //       width: 150,
                    //       fit: BoxFit.fitHeight,
                    //       assetName: AssetName.vectorSmallTop),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 125,
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    // Row(
                    //   children: [
                    //     icon ??
                    //         const SvgAsset(
                    //           assetName: AssetName.headphone,
                    //           height: 24,
                    //           width: 24,
                    //         ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
