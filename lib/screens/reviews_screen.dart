import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/reviews.dart';
import 'package:la_queen/widgets/app_drawer.dart';
import 'package:la_queen/widgets/bottom_app_bar.dart';
import 'package:la_queen/widgets/review_card.dart';
import 'package:provider/provider.dart';

class ReviewsScreen extends StatefulWidget {
  static const routeName = '/reviews';
  final int i;

  ReviewsScreen(this.i);
  
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Reviews>(context).getAllReviews().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recenzije",
          style: TextStyle(color: Color(0xff2d2d2d)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFFC592),
        elevation: 20,
      ),
      backgroundColor: Color(0xff2d2d2d),
      body: _isLoading
        ? Center(
          child: 
            Platform.isIOS ? 
            CupertinoTheme(data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: CupertinoActivityIndicator())
            :CircularProgressIndicator())
        : ReviewCard(),
        bottomNavigationBar: BottomNavigationAppBar(widget.i),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff2d2d2d),
        ),
        child: AppDrawer(),
      ),
    );
  }
}
