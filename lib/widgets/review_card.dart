import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/reviews.dart';
import 'package:provider/provider.dart';

class ReviewCard extends StatefulWidget {
  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    final reviowData = Provider.of<Reviews>(context);

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
        child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 2.3,
          child: Card(
              color: Color(0xff404040),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 8.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Platform.isIOS
                          ? Icon(
                              CupertinoIcons.star_fill,
                              color: Color(0xffFFC491),
                              size: 45,
                            )
                          : Icon(
                              Icons.star,
                              color: Color(0xffFFC491),
                              size: 50,
                            ),
                      Text(reviowData.averageReviws.toString(),
                          style: TextStyle(
                              color: Color(0xffFFC491), fontSize: 50)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Platform.isIOS
                          ? Icon(
                              CupertinoIcons.person_2_fill,
                              color: Color(0xffFFC491),
                              size: 30,
                            )
                          : Icon(Icons.people, color: Color(0xffFFC491)),
                      Text(
                        " " + reviowData.reviews.length.toString(),
                        style: TextStyle(
                            color: Color(0xffFFC491), fontSize: 16),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
      GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: reviowData.reviews.length == null
            ? 0
            : reviowData.reviews.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
            child: Card(
              color: Color(0xffFFC592),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Platform.isIOS
                              ? Icon(
                                  CupertinoIcons.person_fill,
                                  color: Color(0xff404040),
                                  size: 35,
                                )
                              : Icon(Icons.person,
                                  color: Color(0xff404040), size: 40),
                        ),
                        Text(reviowData.reviews[index].user),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(children: [
                        Platform.isIOS
                            ? Icon(CupertinoIcons.star_fill,
                                color: Color(0xff404040))
                            : Icon(Icons.star, color: Color(0xff404040)),
                        reviowData.reviews[index].star >= 2
                            ? Platform.isIOS
                                ? Icon(CupertinoIcons.star_fill,
                                    color: Color(0xff404040))
                                : Icon(Icons.star, color: Color(0xff404040))
                            : Platform.isIOS
                                ? Icon(CupertinoIcons.star,
                                    color: Color(0xff404040))
                                : Icon(Icons.star_outline,
                                    color: Color(0xff404040)),
                        reviowData.reviews[index].star >= 3
                            ? Platform.isIOS
                                ? Icon(CupertinoIcons.star_fill,
                                    color: Color(0xff404040))
                                : Icon(Icons.star, color: Color(0xff404040))
                            : Platform.isIOS
                                ? Icon(CupertinoIcons.star,
                                    color: Color(0xff404040))
                                : Icon(Icons.star_outline,
                                    color: Color(0xff404040)),
                        reviowData.reviews[index].star >= 4
                            ? Platform.isIOS
                                ? Icon(CupertinoIcons.star_fill,
                                    color: Color(0xff404040))
                                : Icon(Icons.star, color: Color(0xff404040))
                            : Platform.isIOS
                                ? Icon(CupertinoIcons.star,
                                    color: Color(0xff404040))
                                : Icon(Icons.star_outline,
                                    color: Color(0xff404040)),
                        reviowData.reviews[index].star >= 5
                            ? Platform.isIOS
                                ? Icon(CupertinoIcons.star_fill,
                                    color: Color(0xff404040))
                                : Icon(Icons.star, color: Color(0xff404040))
                            : Platform.isIOS
                                ? Icon(CupertinoIcons.star,
                                    color: Color(0xff404040))
                                : Icon(Icons.star_outline,
                                    color: Color(0xff404040)),
                        Text(" " + reviowData.reviews[index].date, style: TextStyle(fontSize: 16),),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(reviowData.reviews[index].comment,
                          textAlign: TextAlign.justify),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3),
      ),
    ],
        ),
      );
  }
}
