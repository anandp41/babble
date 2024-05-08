import 'package:babble/core/strings.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'colors.dart';
import 'misc.dart';

///////////////////////landing
const appTitleTextStyle = TextStyle(
        color: babbleTitleColor,
        fontSize: 45,
        fontWeight: FontWeight.bold,
        fontFamily: juaFont),
    getStartedTS =
        TextStyle(color: titleColor, fontSize: 18, fontWeight: FontWeight.w600);
////////////////////////auth

const registrationPhoneNumberTextStyle =
        TextStyle(fontFamily: 'Urbanist', fontSize: 15, color: otpSubColor),
    sendVerifyOTPButtonTextstyle = TextStyle(
        color: kWhite,
        fontSize: 15,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w400),
    regOTPScreenBannerTextStyle = TextStyle(
      color: regTitleColor,
      fontFamily: 'Urbanist',
      fontSize: 35,
      letterSpacing: 0,
      fontWeight: FontWeight.bold,
    ),
    otpScreenHeadingTextStyle =
        TextStyle(color: otpSubColor, fontFamily: "Urbanist", fontSize: 16),
    otpPhoneNumberTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 15);

////////////////////////Chat
const chatListTileNameTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: titleColor,
        fontSize: 16),
    chatListTileLastMsgTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: chatListTileLastMsgTextColor),
    chatListTileLastMsgTimeTextStyle = TextStyle(
        fontFamily: 'Hind',
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
        fontSize: 14,
        color: chatListLastMsgTime),
    messageReplyPreviewNameTS = TextStyle(
      color: senderMessageNameColor,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
    ),
    myMessageCardTimeTextStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      color: myMessageCardTimeColor,
      overflow: TextOverflow.ellipsis,
    ),
    senderCardTimeTextStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      color: senderMessageCardTimeColor,
      overflow: TextOverflow.ellipsis,
    ),
    senderMessageCardTextStyle = TextStyle(
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
      fontSize: 16,
    ),
    myMessageCardTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
      fontSize: 16,
    ),
    chatDateTextStyle = TextStyle(
        fontFamily: 'Hind',
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
        color: Colors.white70,
        fontSize: 12),
    chatAppBarTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: chatAppBarNameSize);
///////////////////////Contact

const selectContactsTitleTS = TextStyle(
      fontSize: 18,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    contactTileInviteTextStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w600,
      color: babbleTitleColor,
      overflow: TextOverflow.ellipsis,
    );

////////////////Links
TextStyle linkStyle = const TextStyle(
  color: Color.fromARGB(255, 20, 109, 182),
  overflow: TextOverflow.ellipsis,
);
TextStyle defaultStyle = const TextStyle(
  color: Colors.white,
  fontSize: 16.0,
  overflow: TextOverflow.ellipsis,
);
///////////////FLoating Action Button
const floatingActionRoomAddButtonTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Hind',
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
    fontSize: 16);

/////////////////////Dropdown

const dropDownListButtonTS = TextStyle(
    fontFamily: 'Hind',
    fontSize: 16,
    color: babbleTitleColor,
    overflow: TextOverflow.ellipsis,
    fontWeight: FontWeight.w500);

///////////////////////////Rooms

var roomSpeakingMemberInNameTS = TextStyle(
    overflow: TextOverflow.fade,
    backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0));

const roomAppBarLeaveTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 15),
    roomHeadingsTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 15),
    roomMemberNameTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w400,
        color: roomMemberNameTextColor,
        fontSize: 14),
    roomControlRoomNameTextStyle = TextStyle(
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: babbleTitleColor,
        overflow: TextOverflow.ellipsis,
        fontSize: 24),
    roomControlMembersTitleTextStyle = TextStyle(
        fontFamily: 'Hind',
        fontWeight: FontWeight.w400,
        color: Colors.white,
        overflow: TextOverflow.ellipsis,
        fontSize: 20),
    roomsListTileNameTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: titleColor,
        fontSize: 16),
    roomsListTileSpeakingTitleTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: roomsListTileSpeakingTitleTextColor),
    roomControlBottomButtonTextTS = TextStyle(
        fontFamily: 'Hind',
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
        fontSize: 24,
        color: Colors.white),
    roomListTileNameTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 16);

//////////////////////////////////////////////Settings
const settingsAppBarTitleTS = TextStyle(
        color: Colors.white,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,
        fontSize: 24),
    settingsButtonsTitleTS =
        TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Hind'),
    settingsNamePreviewTS = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: babbleTitleColor),
    settingsNameSheetTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Hind',
      overflow: TextOverflow.ellipsis,
    ),
    settingsButtonTS = TextStyle(
      color: babbleTitleColor,
      fontSize: 14,
      fontFamily: 'Hind',
      overflow: TextOverflow.ellipsis,
    ),
    settingsRedButtonTS = TextStyle(
      color: Colors.red,
      fontSize: 14,
      fontFamily: 'Hind',
      overflow: TextOverflow.ellipsis,
    );
