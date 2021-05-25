import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'base_viewmodel.dart';

class BaseWidget<T extends BaseViewModel> extends StatefulWidget {
  /*
    child, childDesktop, childMobile, childTablet:
    Its widget not listen on consumer
    Use to paint to widget not change(Appbar, background....)
   */
  final Widget child;
  final Widget childDesktop;
  final Widget childMobile;
  final Widget childTablet;

  final Widget Function(BuildContext context, T viewModel, Widget child) builder;
  final T viewModel;
  final Function(T viewModel) onViewModelReady;
  final bool showPhone;
  final bool mainScreen; // dùng để điều chỉnh vị trí của nút Call tại mỗi màn hình

  BaseWidget({
    Key key,
    @required this.viewModel,
    @required this.builder,
    this.showPhone = true,
    this.mainScreen = false,
    this.child,
    this.childDesktop,
    this.childMobile,
    this.childTablet,
    this.onViewModelReady,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseViewModel> extends State<BaseWidget<T>> with ResponsiveWidget {
  T viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    if (widget.onViewModelReady != null) {
      widget.onViewModelReady(viewModel);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => viewModel..setContext(context),
        child: Consumer<T>(
            builder: (BuildContext context, T viewModel, Widget child) => Stack(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      child: widget.builder.call(context, viewModel, child),
                    ),
                    if (widget.showPhone)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, widget.mainScreen ? 40 : 100),
                        child: GestureDetector(
                          child: Container(
                            height: 60,
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(width: 0.8, color: Colors.red),
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                            child: Container(
                              height: 46,
                              width: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.all(Radius.circular(23))),
                              child: Container(
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(15))),
                                child: Image.asset(AppImages.icPhone, height: 20, width: 20, color: AppColors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            AppUtils.handlePhone(context, "19006810");
                          },
                        ),
                      )
                    else
                      Container()
                  ],
                ),
            child: buildUi(defaultWidget: widget.child, context: context)));
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return widget.childDesktop ?? widget.child;
  }

  @override
  Widget buildMobile(BuildContext context) {
    return widget.childMobile ?? widget.child;
  }

  @override
  Widget buildTablet(BuildContext context) {
    return widget.childDesktop ?? widget.child;
  }
}

abstract class ResponsiveWidget {
  Widget buildDesktop(BuildContext context);

  Widget buildTablet(BuildContext context);

  Widget buildMobile(BuildContext context);

  Widget buildUi({@required BuildContext context, Widget defaultWidget}) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      if (sizeInfo.deviceScreenType == DeviceScreenType.desktop) {
        return buildDesktop(context);
      } else if (sizeInfo.deviceScreenType == DeviceScreenType.tablet) {
        return buildTablet(context);
      } else if (sizeInfo.deviceScreenType == DeviceScreenType.mobile) {
        return buildMobile(context);
      }
      return defaultWidget ?? SizedBox();
    });
  }
}
