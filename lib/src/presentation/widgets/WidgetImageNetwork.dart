import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageNetworkShape { none, circle }
enum ImageNetworkCache { none, cache }

class WidgetImageNetwork extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final ImageNetworkShape shape;
  final ImageNetworkCache cache;
  final String assetError;

  const WidgetImageNetwork(
      {@required this.url,
      this.cache = ImageNetworkCache.cache,
      this.fit,
      this.height,
      this.width,
      this.assetError,
      this.shape = ImageNetworkShape.none});

  const WidgetImageNetwork.cacheNone(
      {@required this.url,
      this.cache = ImageNetworkCache.none,
      this.fit,
      this.height,
      this.width,
      this.assetError,
      this.shape = ImageNetworkShape.none});

  @override
  Widget build(BuildContext context) {
    switch (cache) {
      case ImageNetworkCache.none:
        switch (shape) {
          case ImageNetworkShape.circle:
            return CircleAvatar(
                radius: (width ?? height) / 2,
                backgroundImage: Image.network(
                  url,
                  errorBuilder: (_, __, ___) => CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      assetError ?? AssetImage("assets/logo.png"),
                      fit: BoxFit.fill,
                      width: (width ?? height) * 2 / 3,
                    ),
                  ),
                  loadingBuilder: (_, child, progress) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ).image);
          default:
            return Image.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  assetError ?? AssetImage("assets/logo.png"),
                  fit: BoxFit.fill,
                  width: (width ?? height) * 2 / 3,
                ),
              ),
              loadingBuilder: (_, child, progress) => Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
        break;
      default:
        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          placeholder: (_, __) => Center(
            child: CircularProgressIndicator(),
          ),
          imageBuilder: (_, image) {
            switch (shape) {
              case ImageNetworkShape.circle:
                return CircleAvatar(
                    radius: (width ?? height) / 2, backgroundImage: image);
              default:
                return Image(
                  image: image,
                  fit: fit ?? BoxFit.cover,
                );
            }
          },
          errorWidget: (_, __, ___) => CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              assetError ?? AssetImage("assets/logo.png"),
              fit: BoxFit.fill,
              width: (width ?? height) * 2 / 3,
            ),
          ),
        );
    }
  }
}
