import 'package:flutter/material.dart';
import '../../data/model/onboarding_model.dart';
import '../../../../core/constants/colors.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;  // take model from model file 

  const OnboardingPage({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              model.image,
              fit: BoxFit.cover,
            ),
        
            SizedBox(height: 35),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 140,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 189, 225, 222),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        model.badge, // badge data from modl
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          color: DarkTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
        
                SizedBox(height: 12),
        
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    model.title, // title from model
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: DarkTeal,
                    ),
                  ),
                ),
        
                SizedBox(height: 15),
        
                Text(
                  model.description, // descripton from model
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Boxshadowcolor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
