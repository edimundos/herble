library my_prj.globals;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Size screenSize = WidgetsBinding.instance.window.physicalSize;
double width = screenSize.width;
double height = screenSize.height;
bool isLoggedIn = false;
int userID = 0;
String fcmToken = '';
String username = '';
String password = '';
String email = '';
DateTime wateringTime = DateTime(2023, 1, 1, 20, 0, 0);
List<Tip>? allTips;
List<Instruction>? allInstructions;
Plant currentPlant = Plant(
    plantId: 0,
    plantName: "a",
    plantDescription: "a",
    dayCount: 1,
    picture: "0",
    waterVolume: 1);

class Plant {
  final int plantId;
  final String plantName;
  final String plantDescription;
  final int dayCount;
  final String picture;
  final int waterVolume;

  Plant({
    required this.plantId,
    required this.plantName,
    required this.plantDescription,
    required this.dayCount,
    required this.picture,
    required this.waterVolume,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: int.parse(json['plant_id']),
      plantName: json['plant_name'],
      plantDescription: json['plant_description'],
      dayCount: int.parse(json['day_count']),
      picture: json['picture'],
      waterVolume: int.parse(json['water_volume']),
    );
  }
}

class Instruction {
  final int instructionId;
  final String question;
  final String answer;

  Instruction({
    required this.instructionId,
    required this.question,
    required this.answer,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      instructionId: int.parse(json['id']),
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class Tip {
  final int tipId;
  final String title;
  final String description;
  final Uint8List picture;

  Tip({
    required this.tipId,
    required this.title,
    required this.description,
    required this.picture,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      tipId: int.parse(json['id']),
      title: json['title'],
      description: json['description'],
      picture: Uint8List.fromList(base64.decode(json['picture'])),
    );
  }
}
