import 'dart:async';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 显示如何从Chrome中导入密码
class ImportFromChromePage extends StatefulWidget {
  @override
  State createState() {
    return _ImportFromChromePageState();
  }
}

class _ImportFromChromePageState extends State<ImportFromChromePage> {
  var _currentPage = 0;

  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      var targetPage = (_currentPage + 1);
      if (targetPage >= 3) {
        targetPage = 0;
      }
      _pageController.animateToPage(
        targetPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tips = [
      _ChromeTips(
        "assets/images/import_step1.png",
        context.l10n.importFromChromeTips1,
      ),
      _ChromeTips(
        "assets/images/import_step2.png",
        context.l10n.importFromChromeTips2,
      ),
      _ChromeTips(
        "assets/images/import_step3.png",
        context.l10n.importFromChromeTips3,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.importFromChrome,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: OrientationBuilder(builder: (ctx, orientation) {
        return Stack(
          children: [
            Listener(
              child: PageView.builder(
                controller: _pageController,
                itemCount: tips.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (ctx, index) {
                  return Container(
                    padding: AllpassEdgeInsets.dividerInset,
                    child: orientation == Orientation.portrait
                        ? _buildPagerViewOnVertical(tips[index])
                        : _buildPagerViewOnHorizontal(tips[index]),
                  );
                },
              ),
              onPointerDown: (_) {
                _stopTimer();
              },
              onPointerUp: (_) {
                _startTimer();
              },
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    "${_currentPage + 1}/${tips.length}",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildPagerViewOnHorizontal(_ChromeTips tips) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          tips.image,
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 18)),
        Text(
          tips.text,
          style: AllpassTextUI.secondTitleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPagerViewOnVertical(_ChromeTips tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(vertical: 32)),
        Image.asset(
          tips.image,
          width: ScreenUtil().screenWidth * 0.6,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Text(
            tips.text,
            style: AllpassTextUI.secondTitleStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ChromeTips {
  final String image;
  final String text;
  _ChromeTips(this.image, this.text);
}