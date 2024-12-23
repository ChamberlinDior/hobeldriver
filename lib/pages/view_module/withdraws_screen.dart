import 'dart:convert';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/constants/types/withdraw_request_status.dart';
import 'package:connect_app_driver/functions/custom_number_formatters.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/functions/showCustomDialog.dart';
import 'package:connect_app_driver/pages/view_module/add_bank_details_screen.dart';
import 'package:connect_app_driver/provider/bank_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/common_alert_dailog.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_dropdown.dart';
import 'package:connect_app_driver/widget/custom_rich_text.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/custom_text_field.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WithdrawsScreen extends StatefulWidget {
  const WithdrawsScreen({super.key});

  @override
  State<WithdrawsScreen> createState() => _WithdrawsScreenState();
}

class _WithdrawsScreenState extends State<WithdrawsScreen> {
  ValueNotifier selectedReasonIndex = ValueNotifier(-1);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<BankProvider>(context, listen: false).getWithdrawalRequests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Withdraw Request'),
      floatingActionButton: Consumer<BankProvider>(
        builder: (context, bankProviderInst, child) => FloatingActionButton(
          backgroundColor: MyColors.primaryColor,
          onPressed: () {
            if (bankProviderInst.allBanks.isEmpty) {
              showCommonAlertDailog(context,
                  successIcon: false,
                  actions: [
                    CustomButton(
                      text: "Ok",
                      width: 100,
                      height: 45,
                      onTap: () {
                        CustomNavigation.pushReplacement(
                            context: context,
                            screen: const AddBankDetailsScreen());
                      },
                    ),
                  ],
                  headingText: "Bank Not Added",
                  message:
                      "Bank details not found. Please add your bank details to proceed.");
            } else if (generalSettings.minWithdrawalLimit >
                userData!.walletEarnings) {
              showSnackbar(
                  "Your account balance is below the minimum withdrawal limit of WITHDRAW_LIMIT_PRICE"
                      .replaceAll("WITHDRAW_LIMIT_PRICE",
                          generalSettings.minWithdrawalLimit.toString()));
            } else {
              showDialog(context);
            }
          },
          child: const Icon(
            Icons.add,
            color: MyColors.whiteColor,
          ),
        ),
      ),
      body: Consumer<BankProvider>(
        builder: (context, bankProvider, child) => Column(
          children: [
            Expanded(
              child: bankProvider.withdrawalRequests.isEmpty
                  ? Center(
                      child: CustomText.headingSmall(
                        "No Data Found",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : ValueListenableBuilder(
                      valueListenable: selectedReasonIndex,
                      builder: (context, selectedReason, child) =>
                          ListView.builder(
                              itemCount: bankProvider.withdrawalRequests.length,
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      selectedReasonIndex.value = index;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      margin: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          color: MyColors.lightWhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        MyImagesUrl.calender,
                                                        width: 14,
                                                      ),
                                                      hSizedBox05,
                                                      CustomText.headingSmall(
                                                        bankProvider
                                                            .withdrawalRequests[
                                                                index]
                                                            .time,
                                                        color:
                                                            MyColors.whiteColor,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ],
                                                  ),
                                                  CustomText.headingSmall(
                                                    "IBAN",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  vSizedBox02,
                                                  CustomText.headingSmall(
                                                    bankProvider
                                                        .withdrawalRequests[
                                                            index]
                                                        .accountNumber,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: WithdrawRequestStatus
                                                        .getColor(bankProvider
                                                            .withdrawalRequests[
                                                                index]
                                                            .requestStatus)),
                                                child: CustomText.headingSmall(
                                                  WithdrawRequestStatus.getName(
                                                      bankProvider
                                                          .withdrawalRequests[
                                                              index]
                                                          .requestStatus),
                                                  fontSize: 10,
                                                  color: MyColors.whiteColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                          vSizedBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText.headingSmall(
                                                bankProvider
                                                    .withdrawalRequests[index]
                                                    .bankHolderName,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              CustomText.headingSmall(
                                                CustomNumberFormatters
                                                    .formatNumberInCommasEnWithCurrencyWithoutDecimals(
                                                        bankProvider
                                                            .withdrawalRequests[
                                                                index]
                                                            .amount),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          vSizedBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child: CustomRichText(
                                                  firstText: 'Bank Name: ',
                                                  firstTextFontSize: 14,
                                                  firstTextFontWeight:
                                                      FontWeight.w500,
                                                  firstTextColor:
                                                      MyColors.primaryColor,
                                                  secondText:
                                                      '\n${bankProvider.withdrawalRequests[index].bankName}',
                                                  secondTextFontSize: 14,
                                                  secondTextFontWeight:
                                                      FontWeight.w300,
                                                  secondTextColor:
                                                      MyColors.whiteColor,
                                                ),
                                              ),
                                              Flexible(
                                                  child: CustomRichText(
                                                firstText: "BIC CODE: ",
                                                firstTextFontSize: 14,
                                                firstTextFontWeight:
                                                    FontWeight.w500,
                                                firstTextColor:
                                                    MyColors.primaryColor,
                                                secondText:
                                                    "\n${bankProvider.withdrawalRequests[index].bicCode}",
                                                secondTextFontSize: 14,
                                                secondTextFontWeight:
                                                    FontWeight.w300,
                                                secondTextColor:
                                                    MyColors.whiteColor,
                                              )),
                                            ],
                                          ),
                                          if (bankProvider
                                              .withdrawalRequests[index]
                                              .rejecetedReason
                                              .isNotEmpty)
                                            vSizedBox,
                                          if (bankProvider
                                              .withdrawalRequests[index]
                                              .rejecetedReason
                                              .isNotEmpty)
                                            CustomText.heading(
                                              "Rejected Reason :- ",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          if (bankProvider
                                              .withdrawalRequests[index]
                                              .rejecetedReason
                                              .isNotEmpty)
                                            CustomText.bodyText1(
                                              bankProvider
                                                  .withdrawalRequests[index]
                                                  .rejecetedReason,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            )
                                        ],
                                      ),
                                    ),
                                  )),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  showDialog(context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController amount = TextEditingController();
    ValueNotifier selectedBankNoti = ValueNotifier(null);
    BankProvider bankProviderInsta = Provider.of(context, listen: false);
    List bankList = List.generate(bankProviderInsta.allBanks.length,
        (index) => bankProviderInsta.allBanks[index].toJson());
    return showCustomDialog(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText.heading(
                  'Create New Request',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                vSizedBox05,
                GestureDetector(
                    onTap: () {
                      CustomNavigation.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: MyColors.redColor,
                    ))
              ],
            ),
            vSizedBox,
            CustomText.bodyText1(
              'Please fill the details to create a new withdraw request',
              fontSize: 14,
            ),
            vSizedBox,
            CustomTextField(
              controller: amount,
              hintText: 'Enter your amount',
              horizontalPadding: 0,
              headingText: 'Enter Amount',
              headingColor: MyColors.whiteColor,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Required*";
                } else if (double.parse(val) > userData!.walletEarnings) {
                  return "Amount should be less then balance.";
                } else {
                  return null;
                }
              },
            ),
            vSizedBox,
            ValueListenableBuilder(
                valueListenable: selectedBankNoti,
                builder: (context, selectedValue, child) {
                  return CustomDropdownButton(
                    items: bankList,
                    onChangedSingle: (value) {
                      selectedBankNoti.value = value;
                      value[ApiKeys.createdAt] = "";
                      myCustomLogStatements(
                          "bank details is that ${jsonEncode(value)}");
                    },
                    validatorSingle: (val) {
                      if (val == null) {
                        return "Required*";
                      } else {
                        return null;
                      }
                    },
                    itemMapKey: "bankNameAndAcNumber",
                    singleSelectedItem: selectedValue,
                    hint: "Select Account",
                    headingText: "Select Account",
                    labelColor: MyColors.whiteColor,
                  );
                }),
            vSizedBox2,
            CustomButton(
              text: "Submit",
              width: double.infinity,
              verticalMargin: 0,
              horizontalMargin: 0,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  CustomNavigation.pop(context);
                  bankProviderInsta.createWithDrawRequest(
                      selectedBankNoti.value, amount.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
