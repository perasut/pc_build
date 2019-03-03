import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'package:pc_build/widgets/widgets.dart';
import 'package:pc_build/models/pc.dart';

class PcPartCard extends StatelessWidget {
  final PcPart part;

  PcPartCard({Key key, this.part}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        pcCard(),
        pcThumbnail(),
        pcCardTitle(),
        pcCardContent(),
      ],
    ));
  }

  Widget pcCard() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0x88333366),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }

  Widget pcThumbnail() {
    return Container(
      alignment: FractionalOffset.center,
      margin: EdgeInsets.symmetric(vertical: 48),
      child: part.picture == null
          ? null
          : CachedNetworkImage(imageUrl: part.picture),
    );
  }

  Widget pcCardContent() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(part.brandModel == null ? '' : part.brandModel,
              style: myTextStyle.subHeader.copyWith(color: Colors.white70)),
          Text(
            part.price == null
                ? ''
                : FlutterMoneyFormatter(amount: part.price.toDouble())
                        .output
                        .withoutFractionDigits +
                    ' บาท',
            style: myTextStyle.price,
          ),
        ],
      ),
    );
  }

  Widget pcCardTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            part.title == null ? '' : part.title,
            style: myTextStyle.header,
          ),
        ],
      ),
    );
  }
}
