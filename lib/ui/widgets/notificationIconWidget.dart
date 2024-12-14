import 'package:aurora_teacher/app/routes.dart';
import 'package:aurora_teacher/ui/screens/home/homeScreen.dart';
import 'package:aurora_teacher/ui/styles/colors.dart';
import 'package:flutter/material.dart';

class NotificationIconWidget extends StatelessWidget {
  const NotificationIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notificationCountValueNotifier,
      builder: (context, value, child) => Container(
        height: 40,
        width: 30,
        alignment: Alignment.centerRight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.notifications);
              },
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (value > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: redColor,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    value > 9 ? "9+" : value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
