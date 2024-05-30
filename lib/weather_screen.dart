import 'dart:convert';
import 'dart:ui';
import 'package:currency_converter/additional_info_item.dart';
import 'package:currency_converter/secrets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'hourly_forcast_item.dart';
import 'additional_info_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // double temp=0;
  // @override
  //
  // void initState() {
  //   super.initState();
  //   getCurrentWeather();
  // }

  Future<Map<String,dynamic>> getCurrentWeather() async{
     try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'
        ),
      );
       final data=jsonDecode(res.body);
       if(data['cod']!='200')
        {
          throw 'An unexpected error occur';
        }
      // setState((){
      //   temp=data['list'][0]['main']['temp'];
      // });
       return data;
    } catch(e){
      throw e.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Weather App",
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 29),
        ) ,
        centerTitle: true,
        actions:[
          IconButton(
              onPressed: (){
              setState(() {}
              );
            },
              icon:Icon(Icons.refresh) ),
        ],
      ),
      body:
      // temp==0?const  CircularProgressIndicator():
      FutureBuilder(
        future: getCurrentWeather(),
        builder:(context,snapshot) {
          print(snapshot);
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(
                child: Text(snapshot.error.toString()));
          }
          final data =snapshot.data!;
          final currentTemp=data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentPressure=data['list'][0]['main']['pressure'];
          final currentHumidity=data['list'][0]['main']['humidity'];
          final currentWind=data['list'][0]['wind']['speed'];



          return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //main card
             SizedBox(
               width: double.infinity,
               child: Card(
                 elevation: 10,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20),
                 ),
                 child:ClipRRect(
                   borderRadius: BorderRadius.circular(10),
                   child: BackdropFilter(
                     filter:ImageFilter.blur(sigmaX: 10,sigmaY: 10) ,
                     child:  Padding(
                       padding:const EdgeInsets.all(10.0),
                       child: Column(
                         children: [
                           Text(' $currentTemp K',style:const TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                           const SizedBox(height: 20,),
                           Icon(
                             currentSky=='Clouds'?Icons.cloud:currentSky=='Rain' ? Icons.cloudy_snowing:Icons.sunny,size: 60,),
                           const SizedBox(height: 20,),
                           Text(currentSky,style:const TextStyle(fontSize: 30),)
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ),

              const SizedBox(height: 20,),

              const Text('Hourly Forecast',style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
               ),),

              const SizedBox(height: 15,),

              //weather forecast card
              //   SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //    child: Row(
              //     children: [
              //       for(int i=0;i<7;i++)
              //         Hourly_forecast(
              //           // final time =DateTime.parse();
              //         time: data['list'][i+1]['dt_txt'].toString(),
              //         icon:data['list'][i+1]['weather'][0]['main']=='Clouds'||data['list'][i+1]['weather'][0]['main']=='Rain'?Icons.cloud:Icons.sunny,
              //         temperature: data['list'][i+1]['main']['temp'].toString(),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    final hourlyforecast=data['list'][index+1];
                    final hourlysky=hourlyforecast['weather'][0]['main'];
                    final hourlytemp=hourlyforecast['main']['temp'].toString();
                    final time =DateTime.parse(hourlyforecast['dt_txt']);
                    return Hourly_forecast(
                      time:DateFormat.Hm().format(time),
                      icon:hourlysky=='Clouds'?Icons.cloud:hourlysky=='Rain'?Icons.cloudy_snowing:Icons.sunny,
                      temperature:hourlytemp,
                    );
                  },
                ),
              ),


              const SizedBox(height: 20,),

              const Text('Additonal Information',style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
              ),),

              const SizedBox(height: 15,),

              //additional information

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: currentHumidity.toString(),
                  ),
                  AdditionalInfoItem(
                    icon:Icons.air,
                    label: "Wind Speed",
                    value: currentWind.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access_sharp,
                    label: "Pressure",
                    value: currentPressure.toString(),
                  ),
                ],
              )

            ],
          ),
        );
        },
      ),

    );
  }
}

