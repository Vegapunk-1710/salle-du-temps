import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomImageNetwork extends StatelessWidget {
  CustomImageNetwork({
    super.key,
    required this.imageURL,
    required this.showIcon,
  });

  String? imageURL;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageURL ??= "https://cdn.pixabay.com/photo/2016/12/04/22/15/fitness-1882721_960_720.jpg",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return showIcon
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Card(elevation: 10, child: Icon(Icons.image)))
            : SizedBox(height: MediaQuery.of(context).size.height / 20);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } 
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
