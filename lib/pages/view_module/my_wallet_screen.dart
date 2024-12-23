import 'package:connect_app_driver/pages/view_module/bank_list_screen.dart';
import 'package:connect_app_driver/pages/view_module/withdraws_screen.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/custom_number_formatters.dart';
import '../../provider/bank_provider.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_rich_text.dart';
import 'add_bank_details_screen.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var bankProvider = Provider.of<BankProvider>(context, listen: false);
      bankProvider.getTransactionHistory();
      bankProvider.getAllBanks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'My Earnings',
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomImage(
                            imageUrl: userData!.profileImage ?? '',
                            // imageUrl: MyImagesUrl.profileImage,
                            // fileType: CustomFileType.asset,
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                          ),
                          hSizedBox05,
                          CustomText.bodyText1(
                            'Total Earnings',
                            fontWeight: FontWeight.w400,
                            color: MyColors.blackColor,
                          )
                        ],
                      ),
                      vSizedBox2,
                      // CustomText.smallText(
                      //   'Total Earning',
                      //   fontSize: 13,
                      //   color: MyColors.blackColor,
                      // ),
                      // vSizedBox05,
                      Consumer<FirebaseAuthProvider>(
                          builder: (context, firebaseAuthProvider, child) {
                        return CustomText.headingLarge(
                          CustomNumberFormatters
                              .formatNumberInCommasEnWithCurrencyWithoutDecimals(
                                  userData!.walletEarnings),
                          fontSize: 30,
                          color: MyColors.blackColor,
                          fontWeight: FontWeight.w600,
                        );
                      }),
                    ],
                  ),
                  Image.asset(
                    MyImagesUrl.greyWallet,
                    width: 80,
                    color: MyColors.blackColor,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    width: 129,
                    height: 34,
                    borderRadius: 7,
                    text: 'Bank Details',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    onTap: () {
                      CustomNavigation.push(
                          context: context, screen: const BankListScreen());
                    },
                  ),
                ),
                hSizedBox,
                Expanded(
                  child: CustomButton(
                    height: 34,
                    borderRadius: 7,
                    text: 'Withdrawal',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    onTap: () {
                      CustomNavigation.push(
                        context: context,
                        screen: const WithdrawsScreen(),
                      );
                    },
                  ),
                ),
                hSizedBox,
                Expanded(
                  child: CustomButton(
                    height: 34,
                    borderRadius: 7,
                    text: 'Add Bank',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    onTap: () {
                      CustomNavigation.push(
                          context: context,
                          screen: const AddBankDetailsScreen());
                    },
                  ),
                ),
              ],
            ),
            vSizedBox,
            CustomText.bodyText1(
              'Transations',
              fontWeight: FontWeight.w500,
            ),
            vSizedBox,
            Consumer<BankProvider>(
              builder: (context, bankProvider, child) => Expanded(
                child: ListView.builder(
                  itemCount: bankProvider.transactionHistoryList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: MyColors.lightWhiteColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          bankProvider.transactionHistoryList[index].action
                                      .toLowerCase() ==
                                  "credit"
                              ? Image.asset(
                                  MyImagesUrl.transaction,
                                  width: 40,
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffffc6c2),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Image.asset(
                                    MyImagesUrl.transactionRedUp,
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                          hSizedBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomRichText(
                                  firstText: CustomNumberFormatters
                                      .formatNumberInCommasEnWithCurrencyWithoutDecimals(
                                          bankProvider
                                              .transactionHistoryList[index]
                                              .amount),
                                  firstTextColor: bankProvider
                                              .transactionHistoryList[index]
                                              .action
                                              .toLowerCase() ==
                                          "credit"
                                      ? MyColors.greenColor
                                      : MyColors.redColor,
                                  firstTextFontSize: 14,
                                  firstTextFontWeight: FontWeight.w600,
                                  secondText:
                                      ' ${bankProvider.transactionHistoryList[index].text}',
                                  secondTextColor: MyColors.whiteColor,
                                  secondTextFontSize: 14,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      MyImagesUrl.calender01,
                                      width: 15,
                                    ),
                                    hSizedBox05,
                                    CustomText.smallText(bankProvider
                                        .transactionHistoryList[index].time),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // showDialog(context){
  //   return showCommonAlertDailog(
  //       context,
  //       isShowTitle: true,
  //       rowWidget: Column(
  //         children: [
  //           vSizedBox2,
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const SubHeadingText(
  //                 'Enter requested amount',
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //               GestureDetector(
  //                   onTap: (){
  //                     popPage(context: context);
  //                   },
  //                   child: const Icon(Icons.close,color: MyColors.primaryColor,))
  //
  //             ],
  //           ),
  //           vSizedBox2,
  //           InputTextFieldWidget(
  //             controller:amount,
  //             hintText: 'Enter your amount',
  //             headingText: 'Enter Amount',
  //             keyboardType: TextInputType.number,
  //             validator: (val)=>ValidationFunction.requiredValidation(val!),
  //           ),
  //         ],
  //       ),
  //       actions: [ RoundEdgedButton(
  //         text: 'Send',
  //         verticalMargin: 0,
  //         horizontalMargin: 0,
  //         color: MyColors.primaryColor,
  //         onTap: (){
  //           if(formKey.currentState!.validate()){popPage(context: context);
  //           }
  //         },
  //       ),]
  //   );
  // }
}
