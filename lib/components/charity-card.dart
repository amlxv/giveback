import 'package:flutter/material.dart';
import 'package:giveback/pages/single-charity.dart';
import 'package:giveback/utils/misc.dart';
import 'package:shimmer/shimmer.dart';

class CharityCard extends StatelessWidget {
  final dynamic data;
  final String defaultImage =
      'https://source.unsplash.com/random/?charity${DateTime.now().toString()}';

  CharityCard({super.key, required this.data});

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
          push(context, SingleCharity(data: data));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              '${data['title']}',
            ),
            subtitle: RichText(
              text: TextSpan(
                text: 'By, ',
                style: const TextStyle(
                  color: Colors.black54,
                ),
                children: [
                  TextSpan(
                    text: '${data['by']}',
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
              child: FutureBuilder(
                future: Future.delayed(
                  const Duration(seconds: 2),
                  () => true,
                ),
                builder: (context, builder) {
                  if (builder.hasData) {
                    return Image.network(
                      '${data['image'] ?? defaultImage}',
                      width: 80,
                      fit: BoxFit.cover,
                    );
                  }
                  return SizedBox(
                    width: 80,
                    height: 80,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 20,
                        width: 100,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
