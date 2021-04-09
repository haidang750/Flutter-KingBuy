import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreen/Category.dart';

List<dynamic> items = [
  {
    "image": "star.png",
    "name": "Danh mục đang hot",
    "banner": "banner.jpg",
    "type": [
      {
        "name": "Ghế Massage Xịn",
        "image": "Image 4.png",
        "products": [
          {
            "image": "Image 4.png",
            "name": "Ghế massage toàn thân OTO Prestige PE-09 (dòng cao cấp)",
            "brand": "OTO",
            "star": "5",
            "discount": "- 37%",
            "oldPrice": "190.000.000đ",
            "newPrice": "119.000.000đ"
          },
          {
            "image": "Image 4.png",
            "name":
                "Ghế massage toàn thân OTO Prestige Swarovski PE-09 (Black - đính hạt pha lê)",
            "brand": "OTO",
            "star": "3",
            "discount": "- 47%",
            "oldPrice": "195.000.000đ",
            "newPrice": "100.000.000đ"
          },
        ]
      },
      {
        "name": "Ghế Massage Cùi",
        "image": "Image 4.png",
        "products": [
          {
            "image": "Image 4.png",
            "name": "Ghế massage toàn thân OTO Prestige PE-09 (dòng cao cấp)",
            "brand": "OTO",
            "star": "5",
            "discount": "- 37%",
            "oldPrice": "190.000.000đ",
            "newPrice": "119.000.000đ"
          },
          {
            "image": "Image 4.png",
            "name":
                "Ghế massage toàn thân OTO Prestige Swarovski PE-09 (Black - đính hạt pha lê)",
            "brand": "OTO",
            "star": "3",
            "discount": "- 47%",
            "oldPrice": "195.000.000đ",
            "newPrice": "100.000.000đ"
          },
        ]
      }
    ]
  },
  {
    "image": "Image 4.png",
    "name": "Ghế Massage",
    "banner": "banner.jpg",
    "type": [
      {
        "name": "Ghế Massage Xịn",
        "image": "Image 4.png",
        "products": [
          {
            "image": "Image 4.png",
            "name": "Ghế massage toàn thân OTO Prestige PE-09 (dòng cao cấp)",
            "brand": "OTO",
            "star": "5",
            "discount": "- 37%",
            "oldPrice": "190.000.000đ",
            "newPrice": "119.000.000đ"
          },
          {
            "image": "Image 4.png",
            "name":
                "Ghế massage toàn thân OTO Prestige Swarovski PE-09 (Black - đính hạt pha lê)",
            "brand": "OTO",
            "star": "3",
            "discount": "- 47%",
            "oldPrice": "195.000.000đ",
            "newPrice": "100.000.000đ"
          },
        ]
      },
      {
        "name": "Ghế Massage Cùi",
        "image": "Image 4.png",
        "products": [
          {
            "image": "Image 4.png",
            "name": "Ghế massage toàn thân OTO Prestige PE-09 (dòng cao cấp)",
            "brand": "OTO",
            "star": "5",
            "discount": "- 37%",
            "oldPrice": "190.000.000đ",
            "newPrice": "119.000.000đ"
          },
          {
            "image": "Image 4.png",
            "name":
                "Ghế massage toàn thân OTO Prestige Swarovski PE-09 (Black - đính hạt pha lê)",
            "brand": "OTO",
            "star": "3",
            "discount": "- 47%",
            "oldPrice": "195.000.000đ",
            "newPrice": "100.000.000đ"
          },
        ]
      }
    ]
  },
  {
    "image": "Image 3.png",
    "name": "Máy chạy bộ",
    "banner": "banner.jpg",
    "type": []
  },
  {
    "image": "Image 6.jpg",
    "name": "Thể dục - Thể thao",
    "banner": "banner.jpg",
    "type": [
      {
        "name": "Ghế Massage Xịn",
        "image": "Image 4.png",
        "products": [
          {
            "image": "Image 4.png",
            "name": "Ghế massage toàn thân OTO Prestige PE-09 (dòng cao cấp)",
            "brand": "OTO",
            "star": "5",
            "discount": "- 37%",
            "oldPrice": "190.000.000đ",
            "newPrice": "119.000.000đ"
          },
          {
            "image": "Image 4.png",
            "name":
                "Ghế massage toàn thân OTO Prestige Swarovski PE-09 (Black - đính hạt pha lê)",
            "brand": "OTO",
            "star": "3",
            "discount": "- 47%",
            "oldPrice": "195.000.000đ",
            "newPrice": "100.000.000đ"
          },
        ]
      },
      {
        "name": "Ghế Massage Cùi",
        "image": "Image 4.png",
        "products": [
          {
            "image": "Image 4.png",
            "name": "Ghế massage toàn thân OTO Prestige PE-09 (dòng cao cấp)",
            "brand": "OTO",
            "star": "5",
            "discount": "- 37%",
            "oldPrice": "190.000.000đ",
            "newPrice": "119.000.000đ"
          },
          {
            "image": "Image 4.png",
            "name":
                "Ghế massage toàn thân OTO Prestige Swarovski PE-09 (Black - đính hạt pha lê)",
            "brand": "OTO",
            "star": "3",
            "discount": "- 47%",
            "oldPrice": "195.000.000đ",
            "newPrice": "100.000.000đ"
          },
        ]
      }
    ]
  },
  {
    "image": "Image 5.png",
    "name": "Máy Massage",
    "banner": "banner.jpg",
    "type": []
  },
  {
    "image": "Image 8.png",
    "name": "Sức khỏe - Sắc đẹp",
    "banner": "banner.jpg",
    "type": []
  },
  {
    "image": "Image 7.jpg",
    "name": "Điện máy - Gia dụng",
    "banner": "banner.jpg",
    "type": []
  }
];

class RootCategoriesScreen extends StatefulWidget {
  @override
  _RootCategoriesScreenState createState() => _RootCategoriesScreenState();
}

class _RootCategoriesScreenState extends State<RootCategoriesScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  final controller = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Danh mục"),
          automaticallyImplyLeading: false,
        ),
        body: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildListItems(index, () {
                    setState(() {
                      currentIndex = index;
                    });
                    controller.jumpToPage(currentIndex);
                  });
                },
              ),
            ),
            Expanded(
                child: PageView(
              controller: controller,
              scrollDirection: Axis.vertical,
              children: List.generate(
                  items.length,
                  (index) => Container(
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    width: 0.3, color: Colors.grey))),
                        child: Column(
                          children: [
                            _buildItemName(
                                items[index]["name"],
                                () => index == 0
                                    ? null
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Category(
                                              title: items[index]["name"]),
                                        ))),
                            _buildItemContent(index)
                          ],
                        ),
                      )),
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
            ))
          ],
        ));
  }

  Widget _buildOneItem(String name, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 70,
            height: 70,
            color: name == "Danh mục đang hot"
                ? Colors.yellow.shade200
                : Colors.white,
            child: Image.asset("assets/$image")),
        SizedBox(height: name == "Danh mục đang hot" ? 0 : 6),
        Container(
          child: name == "Danh mục đang hot"
              ? null
              : Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
        )
      ],
    );
  }

  Widget _buildListItems(int index, Function action) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 5,
              color: index == currentIndex ? Colors.blue : Colors.white),
          Expanded(
              child: GestureDetector(
            child: Container(
                color:
                    index == currentIndex ? Colors.grey.shade50 : Colors.white,
                child:
                    _buildOneItem(items[index]["name"], items[index]["image"])),
            onTap: action,
          )),
        ],
      ),
    );
  }

  Widget _buildItemName(String title, Function action) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 0.1, color: Colors.grey),
          bottom: BorderSide(width: 1, color: Colors.grey.shade400),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          GestureDetector(
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              ),
              onTap: action)
        ],
      ),
    );
  }

  Widget _buildItemContent(int index) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: index == 0
                ? Container()
                : Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        image: DecorationImage(
                            image:
                                AssetImage("assets/${items[index]["banner"]}"),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, index == 0 ? 0 : 5, 15, 5),
              child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  children: List.generate(
                    items[index]["type"].length,
                    (index1) {
                      List<Map<String, dynamic>> products =
                          items[index]["type"];
                      return GestureDetector(
                        child: _buildOneItem(products[index1]["name"],
                            products[index1]["image"]),
                        onTap: () {
                          print("Handle Tap 1 Item");
                        },
                      );
                    },
                  )),
            ),
          )
        ],
      ),
    );
  }
}
