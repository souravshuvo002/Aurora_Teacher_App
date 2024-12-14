import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FloatingActionAddButton extends StatelessWidget {
  final Function onTap;
  const FloatingActionAddButton({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 4.5,
      onPressed: () {
        onTap();
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(13.5),
        child: Lottie.asset(UiUtils.getLottieAnimationPath("add_floating.json"),
            animate: true, repeat: true,),
      ),
    );
  }
}
