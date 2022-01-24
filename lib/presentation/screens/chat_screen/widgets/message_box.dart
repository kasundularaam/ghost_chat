import 'package:flutter/material.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';

class MessageBox extends StatelessWidget {
  final TextEditingController controller;
  const MessageBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppTextInput(
        onChanged: (messageText) {},
        textInputAction: TextInputAction.newline,
        controller: controller,
        isPassword: false,
        minLines: 1,
        maxLines: 6,
        textInputType: TextInputType.multiline,
        hintText: "Text Message",
        bgColor: AppColors.darkGrey.withOpacity(0.2),
        textColor: AppColors.lightColor,
      ),
    );
  }
}
