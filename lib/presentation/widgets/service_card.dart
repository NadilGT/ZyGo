import 'package:flutter/material.dart';
import 'package:zygo/core/theme/app_colors.dart';
import 'package:zygo/data/models/service_model/service_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: _buildServiceIcon()),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Text(
            service.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // if (service.hasDeliveryBadge)
          //   Positioned(
          //     top: 8,
          //     left: 0,
          //     right: 0,
          //     child: Center(
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 12,
          //           vertical: 4,
          //         ),
          //         decoration: BoxDecoration(
          //           color: const Color(0xFFFF5252),
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //         child: const Text(
          //           'Delivery',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 11,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon() {
    if (service.svgPath != null) {
      return SvgPicture.asset(service.svgPath!, width: service.width, height: service.width);
    }

    // ignore: unnecessary_null_comparison
    if (service.icon != null) {
      return Icon(service.icon, size: 45, color: service.iconColor);
    }
  }
}
