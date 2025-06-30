import 'package:flutter/material.dart';

class Callout extends StatelessWidget {
  const Callout({
    super.key,
    this.isValid = false,
    this.shape = BoxShape.rectangle,
    required this.icon,
    required this.text,
    this.actionText = '',
    this.onActionTap,
  });

  final bool isValid;
  final BoxShape shape;
  final IconData icon;
  final String text;
  final String actionText;
  final Function()? onActionTap;

  Color get primaryColor {
    return isValid ? const Color(0XFF6DD58C) : const Color(0XFFFFB300);
  }

  Color get backgroundColor {
    return isValid ? const Color(0X146DD58C) : const Color(0X14FFB300);
  }

  Color get borderColor {
    return isValid ? const Color(0X4D6DD58C) : const Color(0X4DFFB300);
  }

  Color get actionColor {
    return isValid ? const Color(0XFF6DD58C) : const Color(0X4DFFFFFF);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
          ),
          const SizedBox.square(
            dimension: 8,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: primaryColor),
          ),
          const Spacer(),
          TextButton(
            onPressed: onActionTap,
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                actionColor,
              ),
            ),
            child: actionText.isNotEmpty
                ? Text(actionText)
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
