import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_cubit.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ProfileFailure){
            return Center(child: Text(state.error),);
          }

          if (state is ProfileSuccess){

            final user = state.user;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user.email),
                Text(user.name),
                Text(user.user_id)
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
