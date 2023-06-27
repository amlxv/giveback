import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giveback/pages/single-charity.dart';
import 'package:giveback/utils/misc.dart';
import 'package:shimmer/shimmer.dart';

class CharityCard extends StatelessWidget {
  final dynamic data;
  final String defaultImage = 'https://source.unsplash.com/random/?charity';

  const CharityCard({super.key, required this.data});

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
                text: (data['amount']) != null ? 'RM ' : 'By, ',
                style: const TextStyle(
                  color: Colors.black54,
                ),
                children: [
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${(data['amount']) != null ? data['amount'] : data['by']}',
                    style: (data['amount']) != null
                        ? null
                        : const TextStyle(
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
              child: Hero(
                tag: data['id'],
                child: CachedNetworkImage(
                  imageUrl: data['image'] ?? "$defaultImage-${data['id']}",
                  width: 80,
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
          ),
        ),
      ),
    );
  }
}
