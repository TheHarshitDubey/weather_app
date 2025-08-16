import 'package:flutter/material.dart';

class HourlyUpdates extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyUpdates({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
    });

  @override
  Widget build(BuildContext context) {
             return Card(
                      elevation: 6,
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8,),
                                Icon(
                                  icon,
                                  size: 32,
                                ),
                                 SizedBox(height: 10,),
                                Text(
                                  temp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}