import 'dart:convert';

import 'package:felixx/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../utils/methods.dart';

class ApiCalls {

  static callSignUp(name, email, phone, deviceID, type) async {

    if(!await Methods.checkConnection()){
      return false;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Strings.urlLogin));

      request.fields.addAll({
        'name': name,
        'email': email,
        'phone_no': phone,
        'device_id': deviceID,
        'type': type
      });

      debugPrint(request.toString());
      debugPrint(request.fields.toString());

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseLogin = json.decode(await response.stream.bytesToString());
        Methods.showToast(responseLogin['message']);
        Methods.processUserData(responseLogin, type);
        debugPrint(responseLogin.toString());
        return true;

      } else {
        Methods.showError("${response.reasonPhrase!}: ${json.decode(await response.stream.bytesToString())['message']}");
        return false;
      }
    } on Exception catch(e) {
      return Methods.callException(e);
    }
  }

  static callLogout() async {

    if(!await Methods.checkConnection()){
      return false;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    try {

      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}'
      };

      var request = http.MultipartRequest('POST', Uri.parse(Strings.urlLogout));

      request.headers.addAll(headers);

      debugPrint(request.toString());

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseLogout = json.decode(await response.stream.bytesToString());
        Methods.showToast(responseLogout['messages']);

        //pref.setBool('isLoggedIn', false);
        pref.clear();

        Routes.navigateToSplash();

        debugPrint(responseLogout.toString());
        return true;

      } else {
        Methods.showError("${response.reasonPhrase!}: ${json.decode(await response.stream.bytesToString())['message']}");
        return false;
      }
    } on Exception catch(e) {
      Methods.callException(e);
    }
  }

  static checkToken() async {

    if(!await Methods.checkConnection()){
      return false;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    try {

      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}'
      };

      var request = http.MultipartRequest('GET', Uri.parse(Strings.urlToken));

      request.headers.addAll(headers);

      debugPrint(request.toString());
      debugPrint(request.headers.toString());

      http.StreamedResponse response = await request.send();

      String data = await response.stream.bytesToString();
      debugPrint(data);

      pref.setBool('isLoggedIn', bool.parse(data));

      return true;

    } on Exception catch(e) {

      pref.setBool('isLoggedIn', false);
      return Methods.callException(e);
    }
  }

  static albumAdd(albumID) async {

    if(!await Methods.checkConnection()){
      return false;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}'
      };
      var request = http.MultipartRequest('POST', Uri.parse(Strings.urlAlbumAdd));
      request.fields.addAll({
        'album_id': albumID
      });

      request.headers.addAll(headers);

      debugPrint(request.toString());
      debugPrint(request.headers.toString());
      debugPrint(request.fields.toString());

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseAdd = json.decode(await response.stream.bytesToString());
        debugPrint(responseAdd.toString());
        Methods.showToast(responseAdd['messages']);
        return true;

      } else {
        Methods.showError("${response.reasonPhrase!}: ${json.decode(await response.stream.bytesToString())['messages']['message']}");
        return false;
      }
    } on Exception catch(e) {
      Methods.callException(e);
    }

    Routes.navigateToLastPage();
  }

  static albumRemove(albumID) async {

    if(!await Methods.checkConnection()){
      return false;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}'
      };
      var request = http.MultipartRequest('POST', Uri.parse(Strings.urlAlbumRemove));
      request.fields.addAll({
        'album_id': albumID
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        var responseAdd = json.decode(await response.stream.bytesToString());
        Methods.showToast(responseAdd['messages']);
        pref.remove(albumID);
        return true;

      } else {
        Methods.showError("${response.reasonPhrase!}: ${json.decode(await response.stream.bytesToString())['messages']['message']}");
        return false;
      }
    } on Exception catch(e) {
      Methods.callException(e);
    }

    Routes.navigateToLastPage();
  }

  static fetchAlbumList() async {

    if(!await Methods.checkConnection()){
      return '';
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}'
      };
      var request = http.MultipartRequest('GET', Uri.parse(Strings.urlAlbumList));

      request.headers.addAll(headers);

      debugPrint(request.toString());
      debugPrint(request.headers.toString());

      http.StreamedResponse response = await request.send();

      debugPrint(response.statusCode.toString());

      String data = await response.stream.bytesToString();
      debugPrint(data);

      if (response.statusCode == 200) {
        return data;
      } else if (response.statusCode == 409){
        Methods.showError('Session Expired!');
        Methods.proceedToSplash();
        return '';
      } else {
        Methods.showError("${response.reasonPhrase!}: ${json.decode(data)['messages']['message']}");
        return '';
      }
    } on Exception catch(e) {
      Methods.callException(e);
      return '';
    }
  }

  static getAlbumDetails(albumID, id) async {

    if(!await Methods.checkConnection()){
      return false;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${pref.getString('token')}'
      };
      var request = http.MultipartRequest('POST', Uri.parse(Strings.urlAlbumDetails));
      request.fields.addAll({
        'album_id': id
      });

      request.headers.addAll(headers);

      debugPrint(request.toString());
      debugPrint(request.headers.toString());

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        var responseDetails = json.decode(await response.stream.bytesToString());
        debugPrint(json.encode(responseDetails['albumImages']).toString());
        Methods.saveAlbumData(json.encode(responseDetails['albumImages']).toString(), albumID);
        return responseDetails['albumImages'];

      } else {
        Methods.showError("${response.reasonPhrase!}: ${json.decode(await response.stream.bytesToString())['messages']['message']}");
        return '';
      }
    } on Exception catch(e) {
      Methods.callException(e);
      return '';
    }
  }

}