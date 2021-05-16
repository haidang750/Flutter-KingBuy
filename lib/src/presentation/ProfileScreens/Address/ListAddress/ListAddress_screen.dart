// Ảnh 45 - Địa chỉ giao hàng
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/ListAddress/ListAddress_viewmodel.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/CreateAddress/CreateAddress_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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
  final listAddressViewModel = ListAddressViewModel();
  final selectedAddressSubject = BehaviorSubject<int>();
  final listAddressSubject = BehaviorSubject<List<Address>>();
  final showAddAddressIcon = BehaviorSubject<bool>();
  final cartAddressSubject = BehaviorSubject<Address>();

  @override
  void initState() {
    super.initState();
    selectedAddressSubject.sink.add(-1);
    cartAddressSubject.sink.add(widget.cartAddress);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await AppUtils.checkLogin()) {
        print("Login => Show ListAddress Provider");
        await listAddressViewModel.getDeliveryAddress(context);
        listAddressSubject.sink.add(Provider.of<AddressModel>(context, listen: false).addresses);
        showAddAddressIcon.sink.add(true);
      } else {
        print("Not Login => Show ListAddress SharedPreferences");
        List<String> listAddressLocal = await AppShared.getAddressModel();
        List<Address> listAddress = [];
        listAddressLocal.forEach((addressLocal) {
          Map<String, dynamic> address = jsonDecode(addressLocal);
          listAddress.add(Address.fromJson(address));
        });
        showAddAddressIcon.sink.add(listAddress.length > 0 ? false : true);
        listAddressSubject.sink.add(listAddress);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    selectedAddressSubject.close();
    listAddressViewModel.dispose();
    listAddressSubject.close();
    showAddAddressIcon.close();
    cartAddressSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ListAddressViewModel>(
      viewModel: ListAddressViewModel(),
      builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text("Địa chỉ giao hàng"),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, cartAddressSubject.stream.value);
                  },
                );
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                child: GestureDetector(
                  child: StreamBuilder(
                    stream: showAddAddressIcon.stream,
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
                  onTap: () async {
                    listAddressSubject.sink.add(await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAddress(
                                isCallFromCart: widget.isCallFromCart, event: "create", listAddress: listAddressSubject.stream.value))));
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
      stream: listAddressSubject.stream,
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
                        stream: selectedAddressSubject.stream,
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
                                      Address address = listAddressSubject.stream.value[snapshot.data];
                                      if (address.taxCode == null) address.taxCode = "";
                                      if (address.companyName == null) address.companyName = "";
                                      if (address.companyAddress == null) address.companyAddress = "";
                                      if (address.companyEmail == null) address.companyEmail = "";
                                      CartModel.of(context).setDeliveryAddressId(address.id);
                                      Navigator.pop(context, address);
                                    }
                                  : null,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )
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
                        stream: selectedAddressSubject.stream,
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
        onTap: widget.enableSelect
            ? () {
                selectedAddressSubject.sink.add(index);
              }
            : () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAddress(
                            isCallFromCart: widget.isCallFromCart,
                            address: address,
                            listAddress: listAddressSubject.stream.value,
                            event: "update"))).then((listAddress) {
                  listAddressSubject.sink.add(listAddress);
                  cartAddressSubject.sink.add(listAddress[0]);
                });
              });
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
