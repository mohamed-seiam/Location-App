import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_cubit.dart';
import 'package:location_app/constance/my_color.dart';
import 'package:location_app/constance/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
   MyDrawer({Key? key}) : super(key: key);

 final PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

   Widget buildDrawerHeader(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),
          child: Image.asset(
            'assets/images/profile.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Mohamed Seiam',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Text(
          '01002834257',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDrawerListItem(
      {required IconData leadingIcon,
      required String title,
      Widget? trailing,
      Color? color,
      Function()? onTap}) {
    return ListTile(
      iconColor: color,
      leading: Icon(leadingIcon,color: color?? MyColor.blue,),
      title: Text(title),
      trailing: trailing ??const Icon(Icons.arrow_right,color: MyColor.blue,),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemDivider()
  {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  void _launchUrl(String url) async
  {
    final Uri url0 = Uri.parse(url);

    await canLaunchUrl(url0) ? await launchUrl(url0) : throw 'Could not launch $url';
  }


  Widget buildIcon (IconData iconData , String url)
  {
    return InkWell(
      onTap: ()=> _launchUrl(url),
      child: Icon(iconData,color: MyColor.blue,size: 35,),
    );
  }


  Widget buildSocialMediaIcons ()
  {
    return Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(FontAwesomeIcons.facebook, 'https://www.facebook.com/amr.seiam.1'),
          const SizedBox(width: 15,),
          buildIcon(FontAwesomeIcons.linkedin, 'https://www.linkedin.com/in/mohamed-seiam-a0a282242/'),
          const SizedBox(width: 15,),
          buildIcon(FontAwesomeIcons.instagram, 'https://www.instagram.com/seiammohamed/'),

        ],
      ),
    );
  }

  Widget buildLogOutBlocProvider(context)
  {
    return  Container(
      child: BlocProvider<PhoneAuthCubit>
        (create: (context) => phoneAuthCubit,
        child: buildDrawerListItem(leadingIcon: Icons.logout,
          color: Colors.red,
          title: 'Logout',
          onTap: () async
          {
            await phoneAuthCubit.logOut();
            Navigator.pushReplacementNamed(context, loginScreen);
          },
          trailing:const SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[100],
              ),
                child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.history, title: 'Places History',onTap: (){}),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemDivider(),
          buildLogOutBlocProvider(context),
          const SizedBox(height: 240,),
           ListTile(
            leading: Text('Follow Us',style:TextStyle(color: Colors.grey.shade600) ,),),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
