import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangamint/bloc/recomended_bloc/bloc.dart';
import 'package:mangamint/components/my_shimmer.dart';
import 'package:mangamint/constants/base_color.dart';
import 'package:mangamint/repositories/recommended_repo.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyCarousel extends StatefulWidget {
  @override
  _MyCarouselState createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return BlocBuilder<RecomendedBloc,RecomendedState>(
      builder: (context,state){
        if (state is RecommendedLoadingState) {
          return MyShimmer(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                height: 500.h,
                width: MediaQuery.of(context).size.width,
                color: BaseColor.red,
              ),
            ),
          );
        }else if (state is RecommendedLoadedState) {
          return Column(
            children: [
              CarouselSlider(
                items: state.recommendedList.map((e){
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: e.thumb,
                      errorWidget: (context,data,_)=> Center(child: Text(data),),
                      placeholder: (context,data) => Center(child: CircularProgressIndicator(),),
                      imageBuilder: (context,imgProvider){
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 500.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imgProvider,
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Center(child: Text(e.title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    colors: [
                                      BaseColor.black,
                                      Colors.black.withOpacity(0.4)
                                    ]
                                )
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                ),
              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: state.recommendedList.map((url) {
//                  int index = state.recommendedList.indexOf(url);
//                  return Container(
//                    width: 8.0,
//                    height: 8.0,
//                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: _current == index
//                          ? Color.fromRGBO(0, 0, 0, 0.9)
//                          : Color.fromRGBO(0, 0, 0, 0.4),
//                    ),
//                  );
//                }).toList(),
//              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}