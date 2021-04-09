// Ảnh 46 - Cam kết của Kingbuy
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Commitment/KingbuyCommitment_viewmodel.dart';

List<Map<String, String>> options = [
  {
    "time": "7 ngày",
    "title": "Đổi trả trong vòng 7 ngày",
    "content":
        "Nếu phụ kiện bị lỗi do nhà sản xuất, Kingbuy sẽ hỗ trợ Quý khách trả lại trong 7 ngày mà không phát sinh thêm chi phí."
  },
  {
    "time": "Miễn phí",
    "title": "Giao hàng, lắp đặt, trải nghiệm miễn phí",
    "content":
        "Hỗ trợ giao hàng, lắp đặt miễn phí tại nhà trên toàn quốc. Trải nghiệm miễn phí tại showroom trên toàn quốc."
  },
  {
    "time": "6 năm",
    "title": "Bảo hành 6 năm, bảo trì trọn đời",
    "content": "Kingbuy bảo hành 6 năm, bảo trì trọn đời cho sản phẩm."
  }
];

class KingbuyCommitment extends StatefulWidget {
  @override
  _KingbuyCommitmentState createState() => _KingbuyCommitmentState();
}

class _KingbuyCommitmentState extends State<KingbuyCommitment> {
  final commitmentViewModel = CommitmentViewModel();

  @override
  void initState() {
    super.initState();
    commitmentViewModel.fetchContactInfo();
  }

  @override
  void dispose() {
    commitmentViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cam kết của Kingbuy")),
        body: Container(
            color: Colors.grey.shade300,
            padding: EdgeInsets.only(top: 15),
            child: _buildListItem()));
  }

  Widget _buildListItem() {
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35)),
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
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
