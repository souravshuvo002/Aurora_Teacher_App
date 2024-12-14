import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class DismissibleBackgroundContainer extends StatelessWidget {
  const DismissibleBackgroundContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onPrimary,),
      child: Row(
        children: [
          Icon(
            Icons.edit,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            UiUtils.getTranslatedLabel(context, editKey),
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ],
      ),
    );
  }
}
