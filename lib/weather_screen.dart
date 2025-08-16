import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_data.dart';
import 'package:weather_app/hourly_updates.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather ;
  
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
    String cityName='London';
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=7f412841295462ae2090b06e4d7d0840'
      ),
    );
    final data=jsonDecode(res.body);
    if(data['cod']!='200'){
      throw 'an unexpected error occured';
    }
      return data;
    
       
     
  
    }catch(e){
    throw e.toString();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather=getCurrentWeather();
  }

  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
//GestureDetector , Inkwell , Iconbutton all used to add icon without button
         IconButton(
            onPressed: () {
              setState(() {
                weather=getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
            
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          // print(snapshot);
          if(snapshot.connectionState==ConnectionState.waiting){
          //adaptive is used to change the circular indicator acc to ios and android system

            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            //this gives the error on device screen in case of any error ie' error in API 
            return Center(child: Text(snapshot.error.toString()));
          }
          final data=snapshot.data!;
          final weather=data['list'][0];
          final currentTemp=weather['main']['temp'];
          final currentSky=weather['weather'][0]['main'];
          final pressure=weather['main']['pressure'];
          final humidity=weather['main']['humidity'];
          final windSpeed=weather['wind']['speed'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // main card
          
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  //backdropfilter is used to blur the border and clipRRect is used to show the border
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter:ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ), 
                     
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '$currentTemp K',
                          style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          currentSky =='Clouds'|| currentSky=='Rain' 
                          ? Icons.cloud 
                          : Icons.sunny,
                          size: 64,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          currentSky,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
          ),
              const SizedBox(height: 20,),
              const Text(
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              SizedBox(height: 10,),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for(int i=0;i<5;i++)
              //       HourlyUpdates (
              //         time: data['list'][i+1]['dt'].toString(),
              //         icon: data['list'][i+1]['weather'][0]['main']=='Clouds' ||  data['list'][i+1]['weather'][0]['main']=='Rain'
              //         ?Icons.cloud
              //         :Icons.sunny,
              //         temp: data['list'][i+1]['main']['temp'].toString()
              //       ),
              //     ] 
              //   ),
              // ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index){
                    final hourlytime=data['list'][index+6];
                    final hourlySky=data['list'][index+6]['weather'][0]['main'];
                    final hourlyTemp= hourlytime['main']['temp'].toString();
                    final time= DateTime.parse(hourlytime['dt_txt']);
                    return HourlyUpdates(
                      time:DateFormat.j().format(time),
                     icon: hourlySky=='Clouds' || hourlySky=='Rain' ? Icons.cloud :Icons.sunny,
                      temp: hourlyTemp,
                   );
                  }
               ),
              ),
              SizedBox(height: 20,),
              Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoData(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: humidity.toString(),
                  ),
                  AdditionalInfoData(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: windSpeed.toString(),
                  ),
                  AdditionalInfoData(
                    icon: Icons.beach_access_rounded,
                    label: 'Pressure',
                    value: pressure.toString(),
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
