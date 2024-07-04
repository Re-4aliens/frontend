import 'package:aliens/models/matching_applicant_model.dart';
import 'package:aliens/models/partner_model.dart';

import 'member_details_model.dart';

class ScreenArguments {
  MemberDetails? memberDetails;
  String? status;
  MatchingApplicant? matchingApplicant;
  List<Partner>? partners;

  ScreenArguments(
      this.memberDetails, this.status, this.matchingApplicant, this.partners);
}
