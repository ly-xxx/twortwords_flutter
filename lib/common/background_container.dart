import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundContainer extends StatefulWidget {
  BackgroundContainer({required this.child, this.opacity, Key? key})
      : super(key: key);

  Widget child;
  final double? opacity;

  @override
  State<BackgroundContainer> createState() => _BackgroundContainerState();
}

class _BackgroundContainerState extends State<BackgroundContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1.4.sh,
        width: 1.sw,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(50, 50, 50, 1),
            image: DecorationImage(
                image: ExtendedNetworkImageProvider(
                    'https://bing.img.run/m.php',
                    cache: true,
                    imageCacheName: 'bcg',
                    retries: 2,
                    scale: 1),
                opacity: widget.opacity ?? 0.6,
                fit: BoxFit.cover)),
        child: widget.child);
  }
}
