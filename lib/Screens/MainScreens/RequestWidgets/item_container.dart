import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget? child;
  final double padding;
  final Widget page;
  const ItemContainer({super.key, this.height = 100, this.width = 100, this.child, this.padding = 12, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> page));
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
              offset: (Offset(5, 10))
            )
          ]
        ),
        child: child,
      ),
    );
  }
}
