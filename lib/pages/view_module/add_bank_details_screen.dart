import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/modal/bank_modal.dart';
import 'package:connect_app_driver/provider/bank_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class AddBankDetailsScreen extends StatefulWidget {
  final BankModal? bankModal;
  const AddBankDetailsScreen({super.key, this.bankModal});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ibanAccountNumbberController = TextEditingController();
  TextEditingController bicCodeController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  initialize() {
    if (widget.bankModal != null) {
      bankNameController.text = widget.bankModal!.bank_name;
      bicCodeController.text = widget.bankModal!.bicCode;
      ibanAccountNumbberController.text = widget.bankModal!.ibanAccountNumber;
      accountHolderNameController.text = widget.bankModal!.account_name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Add bank details',
      ),
      bottomNavigationBar:
          Consumer<BankProvider>(builder: (context, bankProvider, child) {
        return CustomButton(
          text: 'Save',
          verticalMargin: 20,
          height: 50,
          horizontalMargin: globalHorizontalPadding,
          load: bankProvider.banksLoad,
          onTap: () {
            if (formKey.currentState!.validate()) {
              // CustomNavigation.pop( context);

              var bankDetails = BankModal(
                id: widget.bankModal?.id,
                user_id: userData!.userId,
                bank_name: bankNameController.text,
                bicCode: bicCodeController.text,
                ibanAccountNumber: ibanAccountNumbberController.text,
                account_name: accountHolderNameController.text,
                created_at: Timestamp.now(),
              );

              print('dsfadsf ${bankDetails.id}');
              // return;
              // var bankProvider = Provider.of<BankProvider>(context, listen: false);

              bankProvider.addOrEditBank(bankDetails,
                  isEdit: widget.bankModal != null);
            }
          },
        );
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: globalHorizontalPadding, vertical: 18),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: bankNameController,
                  hintText: "Bank Name",
                  textCapitalization: TextCapitalization.characters,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
                vSizedBox2,
                CustomTextField(
                  controller: ibanAccountNumbberController,
                  hintText: "IBAN (International Bank Account Number)",
                  // keyboardType: TextInputType.number,
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textCapitalization: TextCapitalization.characters,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
                vSizedBox2,
                CustomTextField(
                  controller: bicCodeController,
                  hintText: "BIC Code",
                  validator: (val) =>
                      ValidationFunction.requiredValidation(val),
                ),
                vSizedBox2,
                CustomTextField(
                  controller: accountHolderNameController,
                  hintText: "Account Holder Name",
                  textCapitalization: TextCapitalization.characters,
                  validator: (val) =>
                      ValidationFunction.requiredValidation(val),
                  onSaved: (bvads) {
                    // formKey.currentState/.
                  },
                ),
                vSizedBox2,
                // CustomTextField(
                //   controller: bankBranchController,
                //   hintText: "Bank Branch",
                //   validator: (val) =>
                //       ValidationFunction.requiredValidation(val),
                // ),
                // vSizedBox2,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
