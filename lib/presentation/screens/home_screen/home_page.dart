import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghost Chat"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 2.h,
          ),
          FutureBuilder(
              future: ContactsService.getContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Contact> contacts = snapshot.data as List<Contact>;
                  return ListView.builder(
                    
                      itemCount: contacts.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      itemBuilder: (context, index) {
                        Contact contact = contacts[index];
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.darkColor,
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                              padding: EdgeInsets.all(5.w),
                              child: Center(
                                child: Text(
                                  contact.givenName!,
                                  style: const TextStyle(
                                      color: AppColors.lightColor,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            )
                          ],
                        );
                      });
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ));
                }
              }),
        ],
      ),
    );
  }
}
