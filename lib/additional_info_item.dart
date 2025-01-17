import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  //creating constructor
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,size: 32,),
        const SizedBox(height: 10,),
        Text(label,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        const SizedBox(height: 10,),
        Text(value,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ],
    );
  }
}
