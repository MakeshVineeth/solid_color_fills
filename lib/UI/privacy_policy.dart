import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  final text =
      'We do not collect your personal data, period. Moreover, Solid Color Fills is an Open Source Project.';

  final text0 =
      'At MakeshTech, one of our main priorities is the privacy of our users. This Privacy Policy document contains types of information that is collected and recorded by MakeshTech and how we use it.';

  final text1 =
      'If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.';

  final h2 = 'Consent';
  final text2 =
      'By using our services, you hereby consent to our Privacy Policy and agree to its terms.';

  final text3 =
      'The information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your non-critical information.';

  final h4 = 'Log Files';
  final text4 =
      'MakeshTech follows a standard procedure of using log files. These are not linked to any information that is personally identifiable. The log files are only collected when the user manually generates a bug report. The information collected by log files include email provided by you during Bug Reports, System OS Version, Screenshots of Crash/Bugs and Device Name/Brand.';

  final h5 = 'How we use your information';
  final text5 =
      'This non-critical data will only be used for fixing the reported bugs and will never be shared with anyone or any third-party services. Occasionally, we might ask you for your email for any bug report that you have submitted. This will only be used for contacting you (with your permission) and discuss about that aforementioned bug report, nothing else.';

  final h6 = 'Advertising Partners Privacy Policies';
  final text6 =
      'MakeshTech\'s Privacy Policy does not apply to other advertisers. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information.';

  final text7 = 'So, if any of our apps are supported by advertising, be assured that we will also provide an option to disable them through a much affordable in-app purchase. We would also provide an option to disable Interest-Based Ads, thus less tracking, for the people who do not intend to pay.';


  final space = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    text0,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    text1,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    h2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: space),
                  Text(
                    text2,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    text3,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    h4,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: space),
                  Text(
                    text4,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    h5,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: space),
                  Text(
                    text5,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    h6,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: space),
                  Text(
                    text6,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: space),
                  Text(
                    text7,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
