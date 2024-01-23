import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomImageNetwork extends StatelessWidget {
  CustomImageNetwork({
    super.key,
    required this.imageURL,
    required this.showIcon,
    this.fit = BoxFit.cover,
  });

  final String imageURL;
  final bool showIcon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return imageURL.isEmpty
        ? showIcon
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Card(elevation: 1, child: Icon(Icons.image)))
            : SizedBox(height: MediaQuery.of(context).size.height / 20)
        : Image.network(
            imageURL,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return showIcon
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:
                          const Card(elevation: 10, child: Icon(Icons.image)))
                  : SizedBox(height: MediaQuery.of(context).size.height / 20);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
