import 'package:aliens/models/partner_model.dart';

import './memberDetails_model.dart';
import 'applicant_model.dart';

class ScreenArguments {
  MemberDetails?  memberDetails;
  String? status;
  Applicant? applicant;
  List<Partner>? partners;

  ScreenArguments(this.memberDetails, this.status, this.applicant, this.partners);
}
