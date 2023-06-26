import 'package:flutter/material.dart';
import 'package:giveback/components/profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -35,
                right: 0,
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'images/illustrations/profile.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Image.asset(
                'images/illustrations/profile.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Center(
                  child: Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const ProfileForm(),
            ),
          ),
        ],
      ),
    );
  }
}
