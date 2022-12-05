import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class CommunityUser extends StatefulWidget {
  final String userDisplayName;
  final String userUid;
  final String userProfilePic;
  final bool userPresence;
  const CommunityUser({super.key, required this.userDisplayName, required this.userUid, required this.userProfilePic, required this.userPresence});

  @override
  State<CommunityUser> createState() => _CommunityUserState();
}

class _CommunityUserState extends State<CommunityUser> {
  var size = 100.0.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: widget.userProfilePic != ''
                ? Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                            //border: Border.all(color: secondary, width: 0),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AdvancedNetworkImage(
                                widget.userProfilePic,
                                useDiskCache: true,
                                cacheRule: const CacheRule(maxAge: Duration(days: 30)),
                              ),
                              filterQuality: FilterQuality.medium,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Positioned(
                        top: 27,
                        left: 27,
                        child: Container(
                            height: 11,
                            width: 11,
                            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.circle,
                              color: widget.userPresence == true ? Colors.green : Colors.grey,
                              size: 10,
                            )),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                            //border: Border.all(color: secondary, width: 0),
                            shape: BoxShape.circle,
                            color: hover),
                        child: CustomText(
                          text: widget.userDisplayName[0].toUpperCase(),
                          weight: FontWeight.bold,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        top: 27,
                        left: 27,
                        child: Container(
                            height: 11,
                            width: 11,
                            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(100)),
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.circle,
                              color: widget.userPresence == true ? Colors.green : Colors.grey,
                              size: 10,
                              //opticalSize: 10,
                            )),
                      ),
                    ],
                  ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 220,
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.userDisplayName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    //width: 190,
                    child: Text(
                      'ID: ${widget.userUid}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
