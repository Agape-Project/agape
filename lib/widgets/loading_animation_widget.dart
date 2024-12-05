import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  // final double size;
  // final Color color;

  // const LoadingIndicatorWidget({
  //   super.key,
  //   this.size = 60.0, // default size
  //   this.color = const Color.fromARGB(255, 255, 255, 255), // default colo

  // });

  @override
  Widget build(BuildContext context) {
        return LoadingAnimationWidget.staggeredDotsWave(
          color: const Color.fromARGB(255, 132, 0, 255),
          size: 60.0,
        );
    }
  }



