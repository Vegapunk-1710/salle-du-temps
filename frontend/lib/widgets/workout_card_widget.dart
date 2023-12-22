import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String imageURL;
  final String title;
  final String desc;
  final String misc;
  final void Function()? func;
  const WorkoutCard(
      {Key? key,
      required this.imageURL,
      required this.title,
      required this.desc,
      required this.misc,
      required this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDescLengthy = false;
    int maxDescLength = 128;
    if (desc.length > maxDescLength) {
      isDescLengthy = true;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageURL,
            height: MediaQuery.of(context).size.height / 7,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[800],
                  ),
                ),
                Container(height: 10),
                isDescLengthy
                    ? Text(
                        desc.substring(0, maxDescLength) + "...",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      )
                    : Text(
                        desc,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      misc,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: func,
                      child: Text(
                        "Start",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 5),
        ],
      ),
    );
  }
}
