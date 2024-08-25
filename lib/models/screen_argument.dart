import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/models/partner_model.dart';

import 'member_details_model.dart';

class ScreenArguments {
  MemberDetails memberDetails;
  String? status;
  Applicant? applicant;
  List<Partner>? partners;

  ScreenArguments(
      this.memberDetails, this.status, this.applicant, this.partners);
}
