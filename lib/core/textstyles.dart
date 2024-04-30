import 'package:babble/core/strings.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'misc.dart';

//appTitle
const appTitleTextStyle = TextStyle(
    color: babbleTitleColor,
    fontSize: 45,
    fontWeight: FontWeight.bold,
    fontFamily: juaFont);
//ChatList
const chatListTileNameTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: titleColor,
        fontSize: 16),
    roomListTileNameTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.white,
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
        fontSize: 14,
        color: chatListLastMsgTime),
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
        fontSize: 12,
        color: roomsListTileSpeakingTitleTextColor),
    roomAppBarLeaveTextStyle = TextStyle(
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
        fontSize: 24),
    roomControlMembersTitleTextStyle = TextStyle(
        fontFamily: 'Hind',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontSize: 20),
    registrationPhoneNumberTextStyle =
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
        fontSize: 15),
    myMessageCardTimeTextStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      color: myMessageCardTimeColor,
    ),
    senderCardTimeTextStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      color: senderMessageCardTimeColor,
    ),
    senderMessageCardTextStyle = TextStyle(
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontSize: 16,
    ),
    myMessageCardTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    chatAppBarTextStyle = TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: chatAppBarNameSize),
    contactTileInviteTextStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Hind',
      fontWeight: FontWeight.w600,
      color: babbleTitleColor,
    ),
    floatingActionRoomAddButtonTextStyle = TextStyle(
        color: Colors.white,
        fontFamily: 'Hind',
        fontWeight: FontWeight.w500,
        fontSize: 16),
    settingsNameSheetTextStyle =
        TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Hind'),
    settingsButtonTS =
        TextStyle(color: babbleTitleColor, fontSize: 14, fontFamily: 'Hind'),
    settingsRedButtonTS =
        TextStyle(color: Colors.red, fontSize: 14, fontFamily: 'Hind');
