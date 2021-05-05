import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/configs/configs.dart';

class MyLoading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitCircle(color: AppColors.loading, size: 40));
  }
}