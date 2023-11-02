import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_now/view_model/news_view_model.dart';

import '../models/categories_news_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  NewsViewModel newsViewModel= NewsViewModel();
  final format=DateFormat("MMMM dd, yyyy");
  String categoryName='general';

  List<String>categoriesList=[
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.sizeOf(context).width*1;
    final height= MediaQuery.sizeOf(context).height*1;
    return  Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: (){ Navigator.pop(context);},icon: Icon(Icons.arrow_back)),

    ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context,index){

                    return InkWell(
                      onTap:(){
                        categoryName= categoriesList[index];
                        setState(() {
                          //to refresh the state
                        });

                      },
                      child: Padding(

                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color:categoryName== categoriesList[index] ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(20)
                          ),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(fontSize: 13,color: Colors.white),)),
                          ),
                        ),
                      ),
                    );



                  }),
            ),
              SizedBox(height: 30,),
              Expanded(
                child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (BuildContext context, snapshot){

                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: SpinKitCircle(size: 50, color: Colors.orange,) ,
                    );
                  }else{
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,index){
                          DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Container(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index]!.urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        height: height* .18,
                                        width: width* .3,
                                        placeholder: (context,url) =>Container(child: Center(
                                          child: SpinKitCircle(size: 50, color: Colors.orange,) ,),),
                                        errorWidget: (context,url,error)=> Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center ,
                                          children: [
                                            Icon(Icons.error_outline,color: Colors.red,),
                                            Text('Unable to Load Image :(',style: GoogleFonts.poppins(),)
                                          ],
                                        )
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: height*.18,
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: [
                                            Text(snapshot.data!.articles![index].title.toString(),style: GoogleFonts.poppins(fontSize:15,color: Colors.black54,fontWeight: FontWeight.w700),maxLines: 3,),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),style: GoogleFonts.poppins(fontSize: 9,color: Colors.black54,fontWeight: FontWeight.w600),maxLines: 3,),
                                                Text(format.format(dateTime),style: GoogleFonts.poppins(fontSize:7,color: Colors.black54,fontWeight: FontWeight.w700),maxLines: 3,)

                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            )
                          ) ;

                        });
                  }
                },
            ),
              )
          ],
        ),
      ),
    );
  }
}
