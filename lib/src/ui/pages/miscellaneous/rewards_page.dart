import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    // return ScrollablePage(
    //   padding: 0,
    //   distance: 5,
    //   title: "Haweyati Rewards",
    //   showBackgroundImage: false,
    //   subtitle: loremIpsum.substring(0, 50),
    //
    //   child: SliverList(delegate: SliverChildListDelegate([
    //     Container(
    //       decoration: BoxDecoration(
    //         color: Color(0xff313f53),
    //         borderRadius: BorderRadius.circular(20)
    //       ),
    //       margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    //       padding: EdgeInsets.all(23),
    //       child: Stack(children: <Widget>[
    //         Column(children: <Widget>[
    //           Row(children: <Widget>[
    //             CircleAvatar(backgroundColor: Colors.yellow),
    //             SizedBox(width: 10),
    //             Text("2,596", style: TextStyle(
    //               fontSize: 22,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold
    //             )),
    //             SizedBox(width: 10),
    //             Text("points", style: TextStyle(color: Colors.white, fontSize: 12)),
    //             SizedBox(width: 10),
    //           ], mainAxisAlignment: MainAxisAlignment.start),
    //
    //           SizedBox(height: 70),
    //
    //           Text("Earn Points", style: TextStyle(
    //             fontSize: 20,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold
    //           )),
    //           SizedBox(height: 15),
    //           Text("Spend 2000 SR  and get 100 points",style: TextStyle(color: Colors.white)),
    //         ],
    //             mainAxisAlignment:
    //             MainAxisAlignment.start,
    //             crossAxisAlignment:
    //             CrossAxisAlignment.start),
    //         Align(
    //           alignment:
    //           Alignment(0.9, -0.6),
    //           child:
    //           SizedBox(
    //               width: 100,
    //
    //               height: 80,
    //
    //               child: Image.asset(
    //               "assets/images/app-logo-bg.png",
    //             )
    //           )
    //         ),
    //       ])
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       child: Row(children: <Widget>[
    //         Expanded(child: SizedBox(
    //           height: 45,
    //           child: FlatButton(
    //             onPressed: () {},
    //             color:
    //             Colors.grey.shade300,
    //             shape:
    //             StadiumBorder(),
    //             child:
    //             Text("History")
    //           ),
    //         )),
    //         SizedBox(
    //             width: 20),
    //         Expanded(
    //             child:
    //             SizedBox(
    //               height: 45,
    //
    //           child:
    //           FlatButton(
    //             onPressed:
    //                 ()
    //             {},
    //             color:
    //             Colors.grey.shade300,
    //             shape:
    //             StadiumBorder(),
    //             child: Text("Your Vouchers")
    //           ),
    //         )
    //         ),
    //       ]
    //       ),
    //     ),
    //     _buildHeading(text: "Construction Dumspter"),
    //     SizedBox(
    //       height: 240,
    //       child: ListView(
    //         padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
    //         children: <Widget>[
    //           _buildHorizontalList(text1: "12 Yard", text2: "120 points",image: 'assets/images/dumpster.png'),
    //           _buildHorizontalList(text1: "20 Yard", text2: "180 points",image: 'assets/images/dumpster-12.png'),
    //         ],
    //         scrollDirection: Axis.horizontal,
    //       ),
    //     ),
    //     _buildHeading(text: "Scaffolding"),
    //     SizedBox(
    //       height: 240,
    //       child: ListView(
    //         padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
    //         children: <Widget>[
    //           _buildHorizontalList(text1: "Steel Scaffolding", text2: "1200 points",image: 'assets/images/pantedScaffolding.png'),
    //           _buildHorizontalList(text1: "Single Scaffolding", text2: "630 points",image: 'assets/images/pantedScaffolding.png'),
    //           _buildHorizontalList(text1: "Patended Scaffolding", text2: "850 points",image: 'assets/images/pantedScaffolding.png'),
    //         ],
    //         scrollDirection: Axis.horizontal,
    //       ),
    //     ),
    //
    //     _buildHeading(text: "Finishing Materials"),
    //     SizedBox(
    //       height: 240,
    //       child:
    //       ListView(
    //         padding:
    //         const
    //         EdgeInsets.fromLTRB(20, 28, 20, 0),
    //         children:
    //         <Widget>[
    //           _buildHorizontalList
    //             (text1: "Get Mapefill", text2: "1200 points",image: 'assets/images/item-1.png'),
    //           _buildHorizontalList
    //             (text1: "Get Mapefill", text2: "360 points",image: 'assets/images/item-2.png'),
    //           _buildHorizontalList
    //             (text1: "Get Mapefill", text2: "190 points",image: 'assets/images/item-3.png'),
    //           _buildHorizontalList
    //             (text1: "Get Mapefill", text2: "100 points",image: 'assets/images/item-4.png'),
    //           _buildHorizontalList
    //             (text1: "Get Mapefill", text2: "320 points",image: 'assets/images/item-5.png'),
    //         ],
    //         scrollDirection: Axis.horizontal,
    //       ),
    //     ),
    //     _buildHeading(text: "Building Materials"),
    //     SizedBox(
    //       height: 240,
    //       child: ListView(
    //         padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
    //         children: <Widget>[
    //           _buildHorizontalList(text1: "Sand", text2: "350 points",image: 'assets/images/Sand 1.png'),
    //           _buildHorizontalList(text1: "Gypsum", text2: "212 points",image: 'assets/images/Sand 2.png'),
    //           _buildHorizontalList(text1: "Cement", text2: "630 points",image: 'assets/images/Sand 5.png'),
    //           _buildHorizontalList(text1: "Gypsum", text2: "325 points",image: 'assets/images/Sand 4.png'),
    //         ],
    //         scrollDirection: Axis.horizontal,
    //       ),
    //     ),
    //
    //
    //   ])),
    // );
  }

  Widget _buildHeading({String text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHorizontalList({String text1, String text2,String image}) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 20),
        height: 140,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              spreadRadius: 10,
              color: Colors.grey.shade200
            )
          ],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Image.asset(image),
      ),
      Padding(
        padding:
        const
        EdgeInsets.fromLTRB(8, 20, 8, 5),
        child:
        Text(text1,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding:
        const
        EdgeInsets.fromLTRB(10, 2, 0, 0),
        child:
        Text(text2),
      )
    ],
    mainAxisAlignment:
    MainAxisAlignment.start,
    crossAxisAlignment:
    CrossAxisAlignment.start);
  }
}
