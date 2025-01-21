import 'package:flutter/material.dart';
import 'package:vendor_registration/shared/utils/colors.dart';

BoxDecoration BackgroundDecoration() {
    return BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  darkerGradientPurple,
                  lighterGradientPurple,
                ],
                
              ),
              
            );
  }