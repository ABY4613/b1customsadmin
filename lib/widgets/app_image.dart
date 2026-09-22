import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final IconData fallbackIcon;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.fallbackIcon = Icons.two_wheeler,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl.trim();

    Widget imageWidget;
    if (cleanUrl.isEmpty) {
      imageWidget = _buildFallback();
    } else if (cleanUrl.startsWith('data:image/')) {
      imageWidget = _buildMemoryImage(cleanUrl);
    } else if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
      imageWidget = _buildNetworkImage(cleanUrl);
    } else if (cleanUrl.startsWith('assets/')) {
      imageWidget = _buildAssetImage(cleanUrl);
    } else {
      // Could be raw base64 or fallback
      imageWidget = _buildMemoryImage('data:image/png;base64,$cleanUrl');
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildMemoryImage(String dataUrl) {
    try {
      final commaIndex = dataUrl.indexOf(',');
      final base64String = commaIndex != -1 ? dataUrl.substring(commaIndex + 1) : dataUrl;
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } catch (e) {
      return _buildFallback();
    }
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  Widget _buildAssetImage(String assetPath) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: AppColors.border,
          child: Center(
            child: Icon(
              fallbackIcon,
              color: AppColors.accentGrey,
              size: (width != null && width! < 30) ? 16 : 24,
            ),
          ),
        );
  }
}
