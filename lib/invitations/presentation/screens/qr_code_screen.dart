import 'package:expert_events/core/ui/components.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QrCodeScreen extends StatelessWidget {
  final String id;
  const QrCodeScreen({Key? key,required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit  = MoreCubit.get(context);
    return Scaffold(
      appBar: customAppBar(title: ''),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: cubit.userPhone,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
