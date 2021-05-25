// Ảnh 46 - Cam kết của Kingbuy
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/profile_screens/commitment/commitment_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';

class CommitmentScreen extends StatefulWidget {
  @override
  CommitmentScreenState createState() => CommitmentScreenState();
}

class CommitmentScreenState extends State<CommitmentScreen> with ResponsiveWidget {
  CommitmentScreenViewModel commitmentViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: CommitmentScreenViewModel(),
        onViewModelReady: (viewModel) => commitmentViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(titleSpacing: 0, title: Text("Cam kết của Kingbuy")),
            body: Container(color: Colors.grey.shade300, child: buildUi(context: context))));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: commitmentViewModel.commitmentStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.5),
                              borderRadius: BorderRadius.all(Radius.circular(35)),
                            ),
                            child: Center(
                              child: Text(
                                snapshot.data[index]["short_title"],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          snapshot.data[index]["title"],
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        Padding(padding: EdgeInsets.only(top: 3)),
                        Text(
                          snapshot.data[index]["description"],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 1.0,
                    child: Container(height: 15),
                  )
                ],
              );
            },
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
