import 'package:flutter/material.dart';
class Hourly_forecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const Hourly_forecast({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
        elevation: 5,
        child:Container(
          width: 115,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(time,style:const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10,),
              Icon(icon,size: 32,),
              const SizedBox(height: 10,),
              Text(temperature,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
        )
    );
  }
}

