import 'package:flutter/material.dart';

class CharityCard extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int index;
  final String defaultImage =
      'https://source.unsplash.com/random/?charity${DateTime.now().toString()}';

  CharityCard({
    super.key,
    required this.index,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      elevation: 0.3,
      child: InkWell(
        onTap: () {
          print("Item ${snapshot.data![index]['id']} clicked");
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              '${snapshot.data![index]['title']}',
            ),
            subtitle: RichText(
              text: TextSpan(
                text: 'By, ',
                style: const TextStyle(
                  color: Colors.black54,
                ),
                children: [
                  TextSpan(
                    text: '${snapshot.data![index]['by']}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${snapshot.data![index]['image'] ?? defaultImage}',
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
