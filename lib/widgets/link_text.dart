import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkText extends StatelessWidget {
  final String text;
  final String? uriText;
  final Uri uri;
  final TextStyle? style;
  final TextStyle? urlStyle;
  final void Function()? onFailLaunchUri;

  const LinkText(
    this.text, {
    super.key,
    this.uriText,
    required this.uri,
    this.onFailLaunchUri,
    this.style,
    this.urlStyle,
  });

  @override
  Widget build(BuildContext context) {
    final realUriText = uriText ?? uri.toString();
    final beforeUriText = text.substring(0, text.indexOf(realUriText));
    final afterUriText =
        text.substring(text.indexOf(realUriText) + realUriText.length);

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final TextStyle effectiveTextStyle = style ?? defaultTextStyle.style;

    return RichText(
      text: TextSpan(
        style: effectiveTextStyle,
        children: [
          TextSpan(text: beforeUriText),
          TextSpan(
            text: realUriText,
            style: urlStyle ??
                effectiveTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final canLaunch = await canLaunchUrl(uri);
                if (!canLaunch) {
                  onFailLaunchUri?.call();
                  return;
                }
                await launchUrl(uri);
              },
          ),
          TextSpan(text: afterUriText),
        ],
      ),
    );
  }
}
