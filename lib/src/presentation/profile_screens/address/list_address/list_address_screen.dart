// Ảnh 45 - Địa chỉ giao hàng
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/profile_screens/address/list_address/list_address_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/address_model.dart';
import 'package:rxdart/rxdart.dart';
import '../address.dart';

class ListAddress extends StatefulWidget {
  ListAddress({this.enableSelect, this.isCallFromCart, this.selectedAddressId, this.cartAddress});

  bool enableSelect;
  bool isCallFromCart;
  int selectedAddressId;
  Address cartAddress;

  @override
  ListAddressState createState() => ListAddressState();
}

class ListAddressState extends State<ListAddress> with ResponsiveWidget {
  ListAddressViewModel listAddressViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ListAddressViewModel>(
      viewModel: ListAddressViewModel(),
      onViewModelReady: (viewModel) => listAddressViewModel = viewModel..init(widget.cartAddress),
      builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text("Địa chỉ giao hàng"),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, listAddressViewModel.cartAddressSubject.stream.value);
                  },
                );
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                child: GestureDetector(
                  child: StreamBuilder(
                    stream: listAddressViewModel.showAddAddressIcon.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data) {
                          return CircleAvatar(radius: 12, child: Icon(Icons.add, size: 20), backgroundColor: Colors.white);
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  onTap: () {
                    listAddressViewModel.onTapButtonAdd(widget.isCallFromCart);
                  },
                ),
              ),
            ],
          ),
          body: buildUi(context: context)),
    );
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: listAddressViewModel.listAddressSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Address> listAddress = snapshot.data;

          return Container(
              color: Colors.grey.shade300,
              child: Stack(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: listAddress.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          buildOneAddress(listAddress[index], index),
                          index == listAddress.length - 1 ? Container() : Opacity(opacity: 1.0, child: Container(height: 5))
                        ]);
                      }),
                  if (widget.enableSelect)
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: StreamBuilder(
                            stream: listAddressViewModel.selectedAddressSubject.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                    child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: snapshot.data != -1 ? AppColors.primary : AppColors.disableButton,
                                          borderRadius: BorderRadius.all(Radius.circular(22.5))),
                                      child: Text("Giao đến địa chỉ này",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.buttonContent)),
                                    ),
                                    onTap: snapshot.data != -1
                                        ? () {
                                            listAddressViewModel.handleDeliveryToAddress(snapshot.data);
                                          }
                                        : null);
                              } else {
                                return Container();
                              }
                            }))
                  else
                    Container()
                ],
              ));
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildOneAddress(Address address, int index) {
    return GestureDetector(
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            color: Colors.white,
            child: Row(
              children: [
                widget.enableSelect
                    ? StreamBuilder(
                        stream: listAddressViewModel.selectedAddressSubject.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == index) {
                              return Image.asset(AppImages.icEnableRadio, height: 20, width: 20);
                            } else {
                              return Image.asset(AppImages.icDisableRadio, height: 20, width: 20);
                            }
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Container(),
                SizedBox(width: 10),
                Container(
                  width: widget.enableSelect ? MediaQuery.of(context).size.width - 50 : MediaQuery.of(context).size.width - 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.fullName,
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      Text(address.fullAddress, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                      Text(address.firstPhone, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: address.isDefault == 1
                            ? Text("Địa chỉ mặc định", style: TextStyle(color: Colors.red.shade600, fontSize: 17, fontWeight: FontWeight.w600))
                            : null,
                      )
                    ],
                  ),
                )
              ],
            )),
        onTap: () => listAddressViewModel.onSelectOneAddress(widget.enableSelect, index, address, widget.isCallFromCart));
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
