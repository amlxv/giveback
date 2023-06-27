import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giveback/utils/misc.dart';
import 'package:shimmer/shimmer.dart';

class SingleCharity extends StatefulWidget {
  final dynamic data;
  const SingleCharity({super.key, required this.data});

  @override
  State<SingleCharity> createState() => _SingleCharityState();
}

class _SingleCharityState extends State<SingleCharity> {
  String defaultImage = 'https://source.unsplash.com/random/?charity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: widget.data['id'],
                child: CachedNetworkImage(
                  imageUrl: widget.data['image'] ??
                      "$defaultImage-${widget.data['id']}",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.data['title']}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'By, ',
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: '${widget.data['by']}',
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
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "RM ${widget.data['current']}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(
                          text: " raised from ",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        TextSpan(
                          text: "RM ${widget.data['target']}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: widget.data['current'] / widget.data['target'],
                        color: Colors.deepPurple,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.data['desc']}',
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SubmitButton(
            labelText: "Donate",
            onPressed: () {
              print("Donate button pressed");
            },
            height: 70,
          ),
        ),
      ),
    );
  }
}
