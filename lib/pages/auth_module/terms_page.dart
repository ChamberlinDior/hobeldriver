import 'package:connect_app_driver/provider/term_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_loader.dart';
import '../../widget/custom_scaffold.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({
    super.key,
  });

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TermsProvider>(context, listen: false).getTerms();
    });
  }

  //   bool load = false;
  // String result = "";
  // getData()async{
  //   setState(() {
  //     load = true;
  //   });
  //   var request = {
  //     ApiKeys.userType:1
  //   };
  //   var response = await NewestWebServices.getResponse(apiUrl: ApiUrls.terms, request: request, apiMethod: ApiMethod.get);
  //   result = response.data['description'].toString();
  //   setState(() {
  //     load = false;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Privacy Policy',
      ),
      body: Consumer<TermsProvider>(builder: (context, termsProvider, child) {
        if (termsProvider.load) {
          return const Center(child: CustomLoader());
        } else {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Html(
                data: """${termsProvider.terms}""",
              ),
            ),
          );
        }
      }),
    );
  }
}
