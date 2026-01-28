import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_cubit.dart';
import 'package:zygo/presentation/pages/log_in/log_in.dart';
import 'package:zygo/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initilizeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileCubit>()),
      ],
      child: MaterialApp(
        title: 'Zygo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LogIn(),
      ),
    );
  }
}

