import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/pages/view_module/add_bank_details_screen.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_confirmation_dialog.dart';
import 'package:connect_app_driver/widget/custom_paginated_list_view.dart';
import 'package:connect_app_driver/widget/custom_rich_text.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/bank_provider.dart';

class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  // List valueList = [
  //   {
  //     'holderName': 'John Smith',
  //     'accountNo': '1234 xxxx xxxx 1234',
  //     'bankName': 'XYZ bank name',
  //     'ifscCode': 'J123IFSC'
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Bank Details',
      ),
      body: Column(
        children: [
          Expanded(
              child:Consumer<BankProvider>(
                  builder: (context, bankProvider, child) {
                  return CustomPaginatedListView(
                    noDataHeight: 500,
                    padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
                      itemCount: bankProvider.allBanks.length,
                      itemBuilder: (ctx, index) {
                        var bankModal = bankProvider.allBanks[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0xFF848484),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText.bodyText2(
                                        'IBAN',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      vSizedBox02,
                                      CustomText.bodyText2(
                                        bankModal.ibanAccountNumber,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            CustomNavigation.push(context: context, screen: AddBankDetailsScreen(bankModal: bankModal,));
                                          },
                                          child: Image.asset(
                                            MyImagesUrl.edit,
                                            width: 23,
                                          )),
                                      hSizedBox,
                                      GestureDetector(
                                          onTap: () async{
                                            bool? result = await showCustomConfirmationDialog(
                                              headingIcon: Icons.warning,
                                              headingImageColor: Colors.white,
                                              cancelButtonText: 'No',
                                            );
                                            print('dsfkasdf $result');

                                            if(result==true){
                                              bankProvider.deleteBank(bankModal.id!);
                                            }
                                          },
                                          child: Image.asset(
                                            MyImagesUrl.trash,
                                            width: 23,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                              vSizedBox,
                              CustomText.heading(
                                bankModal.account_name.toString(),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              vSizedBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: CustomRichText(
                                      firstText: 'Bank Name: ',
                                      firstTextFontSize: 14,
                                      firstTextFontWeight: FontWeight.w700,
                                      firstTextColor: MyColors.blackColor,
                                      secondText:
                                          '\n${bankModal.bank_name.toString()}',
                                      secondTextFontSize: 14,
                                      secondTextFontWeight: FontWeight.w300,
                                      secondTextColor: MyColors.whiteColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: CustomRichText(
                                      firstText: 'BIC CODE: ',
                                      firstTextFontSize: 14,
                                      firstTextFontWeight: FontWeight.w700,
                                      firstTextColor: MyColors.blackColor,
                                      secondText: '\n${bankModal.bicCode.toString()}',
                                      secondTextFontSize: 14,
                                      secondTextFontWeight: FontWeight.w300,
                                      secondTextColor: MyColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                }
              ))
        ],
      ),
    );
  }
}
