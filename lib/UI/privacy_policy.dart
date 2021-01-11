import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  final text =
      'We do not collect your personal data, period. Moreover, Solid Color Fills is an Open Source Project. At MakeshTech Hub, accessible from https://makeshvineeth.github.io, one of our main priorities is the privacy of our users. This Privacy Policy document contains types of information that is collected and recorded by MakeshTech Hub and how we use it.';

  final text1 =
      'If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.';

  final h2 = 'Consent';
  final text2 =
      'By using our services, you hereby consent to our Privacy Policy and agree to its terms.';

  final text3 =
      'The information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your non-critical information.';

  final h4 = 'Log Files';
  final text4 =
      'MakeshTech Hub follows a standard procedure of using log files. These are not linked to any information that is personally identifiable. The information collected by log files include Email provided by you during Bug Reports, System OS Version, Screenshots of Crash/Bugs and Device Name/Brand';

  final h5 = 'How we use your information';
  final text5 =
      'This non-critical data will only be used for fixing the reported bugs and will NEVER be shared with anyone or any third-party services. Occasionally, we might ask you for your email for any bug report that you have submitted. This will only be used for contacting you (with your permission) and discuss about that aforementioned bug report, nothing else.';

  final h6 = 'Advertising Partners Privacy Policies';
  final text6 =
      'MakeshTech Hub\'s Privacy Policy does not apply to other advertisers. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information.';

  final text7 =
      'If any of our apps are supported by Ads, be assured that we will also provide an option to disable them through a much affordable in-app purchase. We would also provide an option to disable Interest-Based Ads, thus less tracking, for the people who do not intend to pay.';

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
                  SizedBox(height: 10),
                  Text(
                    text1,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    text2,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    text3,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    text4,
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
