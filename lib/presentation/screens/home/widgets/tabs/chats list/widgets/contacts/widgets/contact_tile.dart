import 'package:flutter/material.dart';

import '../../../../../../../../../../core/radii.dart';
import '../../../../../../../../../../core/textstyles.dart';

class ContactTile extends StatelessWidget {
  final String name;
  final bool invite;
  final String profilePic;
  const ContactTile(
      {super.key,
      required this.name,
      required this.invite,
      this.profilePic = ''});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2 * chatListImageRadii,
      child: Row(
        children: [
          profilePic != ''
              ? CircleAvatar(
                  backgroundImage: NetworkImage(profilePic),
                  radius: chatListImageRadii,
                )
              : const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/def.png'),
                  radius: chatListImageRadii,
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      softWrap: true,
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.ellipsis,
                      style: chatListTileNameTextStyle,
                    ),
                  ),
                  if (invite)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Invite",
                        style: contactTileInviteTextStyle,
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
