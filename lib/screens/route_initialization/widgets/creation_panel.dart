import 'package:flutter/material.dart';
import 'package:routes_mobile/screens/app_dimens.dart';

class CreationPanel extends StatefulWidget {
  final Widget child;
  const CreationPanel({
    required this.child,
    super.key
  });

  @override
  State<CreationPanel> createState() => _CreationPanelState();
}

class _CreationPanelState extends State<CreationPanel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInQuad
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: AppDimens.widthPercentage(1, context),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.widthPercentage(0.08, context),
            vertical: AppDimens.heightPercentage(0.02, context)
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, -1),
                blurRadius: 5,
                spreadRadius: 0.5
              )
            ],
            color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: widget.child
        ),
      ),
    );
  }
}