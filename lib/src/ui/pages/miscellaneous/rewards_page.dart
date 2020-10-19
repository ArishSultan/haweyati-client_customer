import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollableView.sliver(
      showBackground: true,
      appBar: HaweyatiAppBar(hideCart: true, hideHome: true),
      padding: const EdgeInsets.all(0),
      children: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(child: HeaderView(
            title: 'Haweyati Rewards',
            subtitle: loremIpsum.substring(0, 70),
          )),
        ),

        SliverToBoxAdapter(child: Container(
          height: 170,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          decoration: BoxDecoration(
            color: Color(0xff313f53),
            borderRadius: BorderRadius.circular(25)
          ),
          padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Stack(children: <Widget>[
            Column(children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Image.asset(GiftIcon, width: 20),
                  backgroundColor: Color(0xffdaa520)
                ),
                title: Padding(
                  padding: const EdgeInsets.only(
                    top: 18, bottom: 5
                  ),
                  child: RichText(text: TextSpan(
                    text: '2,596',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    children: [
                      TextSpan(
                        text: '   points',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        )
                      )
                    ]
                  ))
                ),
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.all(0),
                subtitle: Text('1599 points expiring on DATE', style: TextStyle(
                  fontSize: 12, color: Colors.white
                )),
              ),
              Spacer(),
              Text("Earn Points", style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: 5),
              Text("Spend 2000 SR  and get 100 points",style: TextStyle(color: Colors.white, fontSize: 12)),
            ], mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(AppLogoBgAlt, width: 60)
            ),
          ])
        )),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(children: [
              Expanded(child: FlatButton(
                onPressed: () {},
                color: Colors.grey.shade200,
                shape: StadiumBorder(),
                child: Text('History', style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF313F53)
                ))
              )),
              SizedBox(width: 20),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.grey.shade200,
                  shape: StadiumBorder(),
                  child: Text('Your Vouchers', style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF313F53)
                  ))
                )
              ),
            ]),
          ),
        ),

        // _buildHeading(text: 'Construction Dumpster'),
        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 240,
        //     child: ListView(
        //       padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        //       children: <Widget>[
        //         _buildHorizontalList(text1: "Sand", text2: "350 points",image: 'assets/images/Sand 1.png'),
        //         _buildHorizontalList(text1: "Gypsum", text2: "212 points",image: 'assets/images/Sand 2.png'),
        //         _buildHorizontalList(text1: "Cement", text2: "630 points",image: 'assets/images/Sand 5.png'),
        //         _buildHorizontalList(text1: "Gypsum", text2: "325 points",image: 'assets/images/Sand 4.png'),
        //       ],
        //       scrollDirection: Axis.horizontal,
        //     ),
        //   ),
        // ),
        // _buildHeading(text: 'Scaffolding'),
        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 240,
        //     child: ListView(
        //       padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        //       children: <Widget>[
        //         _buildHorizontalList(text1: "Sand", text2: "350 points",image: 'assets/images/Sand 1.png'),
        //         _buildHorizontalList(text1: "Gypsum", text2: "212 points",image: 'assets/images/Sand 2.png'),
        //         _buildHorizontalList(text1: "Cement", text2: "630 points",image: 'assets/images/Sand 5.png'),
        //         _buildHorizontalList(text1: "Gypsum", text2: "325 points",image: 'assets/images/Sand 4.png'),
        //       ],
        //       scrollDirection: Axis.horizontal,
        //     ),
        //   ),
        // ),
        _buildHeading(text: 'Finishing Materials'),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              children: <Widget>[
                _buildHorizontalList
                  (text1: "Get Mapefill", text2: "1200 points",image: 'assets/images/item-1.png'),
                _buildHorizontalList
                  (text1: "Get Mapefill", text2: "360 points",image: 'assets/images/item-2.png'),
                _buildHorizontalList
                  (text1: "Get Mapefill", text2: "190 points",image: 'assets/images/item-3.png'),
                _buildHorizontalList
                  (text1: "Get Mapefill", text2: "100 points",image: 'assets/images/item-4.png'),
                _buildHorizontalList
                  (text1: "Get Mapefill", text2: "320 points",image: 'assets/images/item-5.png'),
              ],
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        _buildHeading(text: 'Building Materials'),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              children: <Widget>[
                _buildHorizontalList(text1: "Sand", text2: "350 points",image: 'assets/images/Sand 1.png'),
                _buildHorizontalList(text1: "Gypsum", text2: "212 points",image: 'assets/images/Sand 2.png'),
                _buildHorizontalList(text1: "Cement", text2: "630 points",image: 'assets/images/Sand 5.png'),
                _buildHorizontalList(text1: "Gypsum", text2: "325 points",image: 'assets/images/Sand 4.png'),
              ],
              scrollDirection: Axis.horizontal,
            ),
          ),
        )
      ],
    );
    // return ScrollablePage(
    //   padding: 0,
    //   distance: 5,
    //   title: "Haweyati Rewards",
    //   showBackgroundImage: false,
    //   subtitle: loremIpsum.substring(0, 50),
    //
    //   child: SliverList(delegate: SliverChildListDelegate([
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



    //
    //
    //   ])),
    // );
  }

  Widget _buildHeading({String text}) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
      sliver: SliverToBoxAdapter(
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
