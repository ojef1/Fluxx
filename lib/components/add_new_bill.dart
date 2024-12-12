// import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
// import 'package:Fluxx/blocs/month_detail_bloc/month_detail_state.dart';
// import 'package:Fluxx/components/custom_text_field.dart';
// import 'package:Fluxx/models/bill_model.dart';
// import 'package:Fluxx/themes/app_theme.dart';
// import 'package:Fluxx/utils/helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';

// class AddNewBill extends StatefulWidget {
//   final int monthId;
//   final int categoryId;
//   const AddNewBill(
//       {super.key, required this.monthId, required this.categoryId});

//   @override
//   State<AddNewBill> createState() => _AddNewBillState();
// }

// class _AddNewBillState extends State<AddNewBill> {
//   late TextEditingController nameController;
//   late TextEditingController priceController;

//   @override
//   void initState() {
//     nameController = TextEditingController();
//     priceController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     priceController.dispose();
//     GetIt.I<MonthsDetailCubit>()
//         .updateAddBillsResponse(AddBillsResponse.initial);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context).size;
//     return BottomSheet(
//       showDragHandle: true,
//       backgroundColor: Colors.white60,
//       onClosing: () {},
//       builder: (context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: SingleChildScrollView(
//             child: Container(
//               height: mediaQuery.height * .55,
//               width: mediaQuery.width,
//               padding: EdgeInsets.symmetric(vertical: mediaQuery.height * .02),
//               color: Colors.transparent,
//               child: Column(
//                 children: [
//                   Text(
//                     'Adicionar uma nova Conta',
//                     style: AppTheme.textStyles.tileTextStyle,
//                   ),
//                   SizedBox(height: mediaQuery.height * .05),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'nome',
//                         style: AppTheme.textStyles.subTileTextStyle,
//                       ),
//                       CustomTextField(
//                         controller: nameController,
//                         icon: Icons.text_fields_sharp,
//                       ),
//                       SizedBox(height: mediaQuery.height * .03),
//                       Text(
//                         'valor',
//                         style: AppTheme.textStyles.subTileTextStyle,
//                       ),
//                       CustomTextField(
//                         controller: priceController,
//                         icon: Icons.attach_money_rounded,
//                         keyboardType: TextInputType.number,
//                       ),
//                       SizedBox(height: mediaQuery.height * .05),
//                       BlocBuilder<MonthsDetailCubit, MonthsDetailState>(
//                         bloc: GetIt.I(),
//                         builder: (context, state) {
//                           var isLoading = state.addBillsResponse ==
//                               AddBillsResponse.loaging;
//                           return GestureDetector(
//                             onTap: _addNewBill,
//                             child: Container(
//                               width: mediaQuery.width * .85,
//                               height: mediaQuery.height * .07,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: mediaQuery.width * .05),
//                               decoration: BoxDecoration(
//                                 gradient: AppTheme.colors.primaryColor,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       'Finalizar',
//                                       textAlign: TextAlign.center,
//                                       style: AppTheme.textStyles.titleTextStyle,
//                                     ),
//                                   ),
//                                   isLoading
//                                       ? const Center(
//                                           child: CircularProgressIndicator())
//                                       : const Icon(
//                                           Icons.check,
//                                           color: Colors.white,
//                                         ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _addNewBill() async {
//     if (nameController.text.isEmpty) {}
//     if (priceController.text.isEmpty) {}
//     if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
//       final String price = priceController.text.replaceAll(',', '.');

//       var newBill = BillModel(
//         id: GetIt.I<MonthsDetailCubit>().codeVoucherGenerate(),
//         name: nameController.text,
//         monthId: widget.monthId,
//         categoryId: widget.categoryId,
//         price: double.parse(price),
//         isPayed: 0,
//       );
//       var result = await GetIt.I<MonthsDetailCubit>().addNewBill(newBill);
//       var state = GetIt.I<MonthsDetailCubit>().state;
//       if (result != -1) {
//         Navigator.pop(context);
//         GetIt.I<MonthsDetailCubit>()
//             .getBills(widget.monthId, widget.categoryId);
//         showFlushbar(context, state.successMessage, false);
//       } else {
//         showFlushbar(context, state.errorMessage, true);
//       }
//     }
//   }
// }
