import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_now/models/news_channels_headlines_model.dart';
import 'package:news_now/view/categories_screen.dart';
import 'package:news_now/view_model/news_view_model.dart';

import '../models/categories_news_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


enum  FilterList{bbcNews,aryNews,independent,reuters,cnn,alJazeera, bloomberg,buzzfeed}


class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel= NewsViewModel();
  final format=DateFormat("MMMM dd, yyyy ");
  FilterList? selectedMenu;

  String name= 'bbc-news';
  
  @override
  Widget build(BuildContext context) {
    //width and height necessary
    final width= MediaQuery.sizeOf(context).width*1;
    final height= MediaQuery.sizeOf(context).height*1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoriesScreen()));
        },
          icon: Image.asset('images/category_icon.png'),
        padding: EdgeInsets.all(15),
      ),
        actions: [
        PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert_outlined,color: Colors.black,),

            onSelected: (FilterList item){
              if(FilterList.bbcNews.name == item.name){
                name = 'bbc-news';
              }
              if(FilterList.aryNews.name == item.name){
                name = 'ary-news';
              }
              if(FilterList.alJazeera.name == item.name){
                name = 'al-jazeera';
              }
              if(FilterList.bloomberg.name == item.name){
                name = 'bloomberg';
              }
              if(FilterList.buzzfeed.name == item.name){
                name = 'buzzfeed';
              }





              setState(() {
                selectedMenu= item;
              });
            },

            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews ,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews ,
                child: Text('Ary News'),
              ),

              PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera,
                  child: Text('Al Jazeera')
              ),
              PopupMenuItem<FilterList>(
                  value: FilterList.bloomberg,
                  child: Text('Bloomberg'),
              ),
              PopupMenuItem<FilterList>(
                  value: FilterList.buzzfeed,
                  child: Text('Buzzfeed')
              )




            ]


        )

        ],
        title: Text("NewsNow",style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w700),),),
      body: ListView(

        children: [
         const SizedBox(height: 10,),
          //for horizontal list always make sure size should be fixed
          SizedBox(
            height: height* .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (BuildContext context, snapshot){

                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.orange,) ,
                  );
                }else{
                 return ListView.builder(
                   itemCount: snapshot.data!.articles!.length,
                     scrollDirection: Axis.horizontal,
                     itemBuilder: (context,index){
                     DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                     return SizedBox(
                     child:  Stack(
                       alignment: Alignment.center,
                       children: [
                       Container(
                          height: height*0.6,
                           width: width*0.9,
                           padding: EdgeInsets.symmetric(
                             horizontal: height*0.02,
                           ),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(15),
                             child: CachedNetworkImage(
                               imageUrl: snapshot.data!.articles![index]!.urlToImage.toString(),
                               fit: BoxFit.cover,
                               placeholder: (context,url) =>Container(child: spinkit2,),
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
                         ),
                         Positioned(
                           bottom: 20,
                           child: Card(
                             elevation: 5,
                             color: Colors.white,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Container(
                               child: Container(
                                 alignment: Alignment.bottomCenter,
                                 padding: EdgeInsets.all(15),
                                 height: height*0.22,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Container(
                                       width: width*0.7,
                                       child: Text(snapshot.data!.articles![index].title.toString(),
                                       maxLines: 2,
                                       overflow: TextOverflow.ellipsis,
                                       style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                                        ),

                                     ),
                                     Spacer(),
                                     Container(
                                       width: width*0.7,
                                       child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(snapshot.data!.articles![index].source!.name.toString(),
                                             maxLines: 2,
                                             overflow: TextOverflow.ellipsis,
                                             style: GoogleFonts.poppins(
                                               fontSize: 10,
                                                 fontWeight: FontWeight.w600),
                                           ),

                                           Text(format.format(dateTime),
                                             maxLines: 2,
                                             overflow: TextOverflow.ellipsis,
                                             style: GoogleFonts.poppins(
                                               fontSize: 8,
                                                 fontWeight: FontWeight.w500),
                                           ),
                                         ],
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         )
                       ],
                     ), // stack ends here
                     );

                     });
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('general'),
              builder: (BuildContext context, snapshot){

                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.orange,) ,
                  );
                }else{
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
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
    );
  }



}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
