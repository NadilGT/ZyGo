import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zygo/data/models/service_model/service_model.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_cubit.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_state.dart';
import 'package:zygo/presentation/pages/map/pricing_cubit/pricing_cubit.dart';
import 'package:zygo/presentation/widgets/service_card.dart';
import 'package:zygo/service_locator.dart';

import '../map/map.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileCubit>()..getProfile()),
      ],
      child: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceModel> services = [
      ServiceModel(
        title: 'Rides',
        icon: Icons.directions_car,
        width: 45,
        svgPath: 'assets/icons/taxi-svgrepo-com.svg',
        color: const Color(0xFFF5A623),
      ),
      ServiceModel(
        title: 'Food',
        icon: Icons.fastfood,
        width: 40,
        svgPath: 'assets/icons/sandwich-burger-svgrepo-com.svg',
        color: const Color(0xFFF5A623),
        iconColor: const Color(0xFFE74C3C),
      ),
      ServiceModel(
        title: 'Market',
        width: 37,
        icon: Icons.shopping_basket,
        color: const Color(0xFF3498DB),
        svgPath: 'assets/icons/cart-svgrepo-com.svg',
        iconColor: const Color(0xFF3498DB),
      ),
      ServiceModel(
        title: 'Events',
        width: 50,
        icon: Icons.directions_car,
        svgPath: 'assets/icons/calendar-svgrepo-com.svg',
        color: const Color(0xFFF5A623),
      ),
      ServiceModel(
        title: 'Rentals',
        width: 40,
        icon: Icons.luggage,
        color: const Color(0xFFF1C40F),
        svgPath: 'assets/icons/real-estate-rental-svgrepo-com.svg',
        iconColor: const Color(0xFFE74C3C),
      ),
      ServiceModel(
        title: 'Flash',
        width: 40,
        icon: Icons.flash_on,
        color: const Color(0xFFF5A623),
        svgPath: 'assets/icons/package-box-svgrepo-com.svg',
        iconColor: const Color(0xFFF5A623),
        hasDeliveryBadge: true,
      ),
      ServiceModel(
        title: 'Trucks',
        width: 35,
        icon: Icons.local_shipping,
        color: const Color(0xFFF5A623),
        svgPath: 'assets/icons/truck-delivery-svgrepo-com.svg',
        iconColor: const Color(0xFFF5A623),
      ),
      ServiceModel(
        title: 'Scan N\' Go',
        width: 45,
        icon: Icons.qr_code_scanner,
        svgPath: 'assets/icons/scan-qr-svgrepo-com.svg',
        color: const Color(0xFFF5A623),
        iconColor: Colors.black,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              String name = '';
              if (state is ProfileSuccess) {
                name = state.user.name;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, $name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        leadingWidth: 150,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(
                      service: services[index],
                      onTap: () => _handleServiceTap(context, services[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(BuildContext context, ServiceModel service) {
    switch (service.title) {
      case 'Rides':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => PricingCubit(),
              child: MapView(),
            ),
          ),
        );
        break;
      case 'Food':
        _showComingSoon(context, service.title);
        break;
      case 'Market':
        _showComingSoon(context, service.title);
        break;
      case 'Rentals':
        _showComingSoon(context, service.title);
        break;
      case 'Flash':
        _showComingSoon(context, service.title);
        break;
      case 'Trucks':
        _showComingSoon(context, service.title);
        break;
      case 'Scan N\' Go':
        _showComingSoon(context, service.title);
        break;
      default:
        _showComingSoon(context, service.title);
    }
  }

  void _showComingSoon(BuildContext context, String serviceName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$serviceName coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
