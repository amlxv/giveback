import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giveback/pages/single-charity.dart';
import 'package:giveback/utils/misc.dart';
import 'package:shimmer/shimmer.dart';

class CharitySliderCard extends StatelessWidget {
  final dynamic data;
  final String defaultImage = 'https://picsum.photos/seed';
  final String from;

  const CharitySliderCard({super.key, required this.data, required this.from});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.3,
      child: InkWell(
        onTap: () {
          push(context, SingleCharity(data: data));
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: from + data['id'],
                child: CachedNetworkImage(
                  imageUrl: data['image'] ?? "$defaultImage/${data['id']}/500",
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    height: double.infinity,
                    width: 80,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 20,
                        width: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${data['title']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${data['by']}',
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
