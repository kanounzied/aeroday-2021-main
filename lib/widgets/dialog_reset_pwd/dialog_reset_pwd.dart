import 'package:aeroday_2021/widgets/dialog_reset_pwd/pwd_dialog.dart';
import 'package:flutter/material.dart';

Future<void> dialogResetPwd(context, String loginNumber) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return PwdDialog(loginNumber);
    },
  );
}

// class _DialogResetPwdState extends State<DialogResetPwd> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return PwdDialog();
//               },
//             );
//           },
//           child: Text("Custom Dialog"),
//         ),
//       ),
//     );
//   }
// }