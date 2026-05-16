import 'package:flutter/material.dart';
import 'package:svgaplayer/parser.dart';
import 'package:svgaplayer/player.dart';
import 'package:svgaplayer/proto/svga.pb.dart';

class SvgaAnimation extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;
  final bool loop;

  const SvgaAnimation({
    super.key,
    required this.assetPath,
    this.width = 100,
    this.height = 100,
    this.loop = true,
  });

  @override
  State<SvgaAnimation> createState() => _SvgaAnimationState();
}

class _SvgaAnimationState extends State<SvgaAnimation>
    with SingleTickerProviderStateMixin {
  late SVGAAnimationController _controller;
  MovieEntity? _movieEntity;

  @override
  void initState() {
    super.initState();
    _controller = SVGAAnimationController(vsync: this);
    _loadSVGA();
  }

  Future<void> _loadSVGA() async {
    final movieEntity = await SVGAParser.shared.decodeFromAssets(
      widget.assetPath,
    );
    if (mounted) {
      setState(() {
        _movieEntity = movieEntity;
        _controller.videoItem = movieEntity;
        if (widget.loop) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_movieEntity == null) {
      return SizedBox(width: widget.width, height: widget.height);
    }
    return SVGAImage(
      _controller,
      preferredSize: Size(widget.width, widget.height),
    );
  }
}
