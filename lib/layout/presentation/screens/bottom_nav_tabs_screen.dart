import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../event/presentation/screens/event_screen.dart';
import '../../../home/presentation/screens/home_screens.dart';
import '../../../invitations/presentation/screens/invitations_screen.dart';
import '../../../more/presentation/screens/more_screen.dart';
import '../controller/bottom_nav_cubit.dart';
import '../controller/bottom_nav_states.dart';
import '../components/bottom_nav_widget.dart';

class BottomNavTabsScreen extends StatefulWidget {
  const BottomNavTabsScreen({Key? key}) : super(key: key);

  @override
  _BottomNavTabsScreenState createState() => _BottomNavTabsScreenState();
}

class _BottomNavTabsScreenState extends State<BottomNavTabsScreen> {

  @override
  Widget build(BuildContext context) {
    var bottomNavProvider = BottomNavCubit.get(context);
        return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
              context.watch<BottomNavCubit>().currentIndex==0?const HomeScreen():context.watch<BottomNavCubit>().currentIndex==1?const InvitationsScreen():context.watch<BottomNavCubit>().currentIndex==2?const EventScreen():const MoreScreen(),
              BlocBuilder<BottomNavCubit,BottomNavState>(
                  buildWhen: (context,state) => state is ChangeState,
                  builder: (context, state,) {
                    return BottomNavBar(currentIndex: bottomNavProvider.currentIndex,
                      onTap0: (){
                        bottomNavProvider.setCurrentIndex(0);
                      },
                      onTap1: (){
                        bottomNavProvider.setCurrentIndex(1);
                      },
                      onTap2: (){
                        bottomNavProvider.setCurrentIndex(2);
                      },
                      onTap3: (){
                        bottomNavProvider.setCurrentIndex(3);
                      },

                    );
                  }
              ),
            ],
          );
  }
}
