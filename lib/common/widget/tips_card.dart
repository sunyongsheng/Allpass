import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TipsCardType {
  success,
  info,
  warning,
  error
}

class TipsCard extends StatefulWidget {
  final TipsCardType type;
  final bool visible;
  final String title;
  final void Function() onClose;

  const TipsCard({super.key, required this.type, required this.visible, required this.title, required this.onClose});

  @override
  _TipsCardState createState() => _TipsCardState();
}

class _TipsCardState extends State<TipsCard> {
  bool _isVisible = true;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.visible;
    _hidden = !_isVisible;
  }

  @override
  void didUpdateWidget(covariant TipsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _isVisible = widget.visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var (contentColor, backgroundColor, prefixIcon) = switch (widget.type) {
      TipsCardType.success => (themeProvider.successContentColor, themeProvider.successBackgroundColor, Icons.verified_outlined),
      TipsCardType.info => (themeProvider.infoContentColor, themeProvider.infoBackgroundColor, Icons.info),
      TipsCardType.warning => (themeProvider.warningContentColor, themeProvider.waringBackgroundColor, Icons.warning),
      TipsCardType.error => (themeProvider.errorContentColor, themeProvider.errorBackgroundColor, Icons.cancel_outlined)
    };
    var card = Card(
      color: backgroundColor,
      margin: AllpassEdgeInsets.forCardInset,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  prefixIcon,
                  size: 16,
                  color: contentColor,
                ),
                Padding(padding: EdgeInsets.only(left: 6)),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            InkWell(
              child: Icon(
                Icons.close,
                size: 16,
                color: themeProvider.iconColor,
              ),
              onTap: () {
                widget.onClose();
              },
            )
          ],
        ),
      ),
    );
    var duration = Duration(milliseconds: 300);
    return AnimatedScale(
      scale: _isVisible ? 1 : 0,
      duration: duration,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1 : 0,
        duration: duration,
        onEnd: () {
          if (!_isVisible) {
            setState(() {
              _hidden = true;
            });
          }
        },
        child: _hidden ? SizedBox.shrink() : card,
      ),
    );
  }
}
