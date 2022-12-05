import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class ParticipantInfo extends StatefulWidget {
  final String pName;
  final String pUID;
  final String sName;
  final String pStatus;
  const ParticipantInfo({Key? key, required this.pName, required this.pUID, required this.sName, required this.pStatus}) : super(key: key);

  @override
  State<ParticipantInfo> createState() => _ParticipantInfoState();
}

class _ParticipantInfoState extends State<ParticipantInfo> {
  var pProfilePic = ''.obs;

  @override
  void initState() {
    setProfilePic(widget.pUID);
    super.initState();
  }

  Future<void> setProfilePic(String uID) async {
    pProfilePic.value = await userController.getUserProfilePic(uID);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: onCard),
        //color: hover,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.pStatus == 'waiting'
                      ? Colors.amber.withOpacity(0.8)
                      : widget.pStatus == 'playing'
                          ? Colors.lightGreen.withOpacity(0.9)
                          : Colors.red.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    widget.pName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(color: background, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pProfilePic.value != ''
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 7),
                            child: Container(
                              height: 47,
                              width: 47,
                              decoration: BoxDecoration(
                                  //border: Border.all(color: secondary, width: 0),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AdvancedNetworkImage(
                                      pProfilePic.value,
                                      useDiskCache: true,
                                      cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                                    ),
                                    filterQuality: FilterQuality.medium,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                            child: Container(
                              alignment: Alignment.center,
                              height: 47,
                              width: 47,
                              decoration: BoxDecoration(
                                  //border: Border.all(color: secondary, width: 0),
                                  shape: BoxShape.circle,
                                  color: secondary),
                              child: CustomText(
                                text: widget.pName[0].toUpperCase(),
                                weight: FontWeight.bold,
                                size: 25,
                                color: hover,
                              ),
                            ),
                          ),
                    //CustomText(text: widget.pName),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
                      child: SizedBox(
                        child: Text(
                          widget.sName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
