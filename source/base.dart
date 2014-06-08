library base;

import 'dart:math';
import 'serialization.dart';

class Base {
  static Structure _endingsStructure = new MapStructure<String
      , List<Map<String,int>>>(new StringStructure()
      , new ListStructure<Map<String,int>>(new MapStructure<String,int>
      (new FixedStringStructure(1), new IntStructure())));
  static Structure _beginningsStructure = new MapStructure<String,int>
            (new StringStructure(), new IntStructure());
  static Structure _totalStructure = new IntStructure();

  Map<String, List<Map<String,int>>> _endings
      = new Map<String, List<Map<String,int>>>();
  Map<String, int> _beginnings = new Map<String, int>();
  int _totalBeginningsWeight = 0;

  Map<int,int> endingWeights = {2:1, 3:5, 4:20};
  int minDifference = 5;
  Random random = new Random();


  String toText(){
    String text = _endingsStructure.toText(_endings);
    text += _beginningsStructure.toText(_beginnings);
    return text + _totalStructure.toText(_totalBeginningsWeight);
  }

  Base(String text){
    Structure.init(text);
    _endings = _endingsStructure.fromText();
    _beginnings = _beginningsStructure.fromText();
    _totalBeginningsWeight = _totalStructure.fromText();
  }


  Base.fromWordList(List<String> words) {
    for(String word in words) {
      String beginning = word.substring(0, 2);
      if(_beginnings.containsKey(beginning)) {
        _beginnings[beginning] += 1;
      } else {
        _beginnings[beginning] = 1;
      }
      _totalBeginningsWeight++;

      for(int length = 3; length <= 5; length++) {
        for(int index = 0; index + length < word.length; index++) {
          String chunk = word.substring(index, index + length);
          int chunkEndingIndex = index + length;

          for(int endingLength = 2; endingLength < min(5, length)
              ; endingLength++) {
            String ending = word.substring(chunkEndingIndex - endingLength
                , chunkEndingIndex);

            List<Map<String,int>> endingList = _endings[ending];
            if(endingList == null) {
              endingList = new List<Map<String,int>>(2);
              _endings[ending] = endingList;
            }

            int endingType = (chunkEndingIndex == word.length - 1) ? 1 : 0;

            Map<String,int> endingMap = endingList[endingType];
            if(endingMap == null) {
              endingMap = new Map<String,int>();
              endingList[endingType] = endingMap;
            }

            String rChunk
               = word.substring(chunkEndingIndex, chunkEndingIndex + 1);
            if(endingMap.containsKey(rChunk)) {
              endingMap[rChunk] += 1;
            } else {
              endingMap[rChunk] = 1;
            }
          }
        }
      }
    }
  }


  String generateWord(int minLetters, int maxLetters) {
    while(true) {
      String word = _generateWord(minLetters, maxLetters);
      if(!word.isEmpty) return word;
    }
  }

  String _generateWord(int minLetters, int maxLetters) {
    String word = "";
    int beginningSeed = random.nextInt(_totalBeginningsWeight);
    _beginnings.forEach((chunk, weight) {
      if(beginningSeed >= 0) {
        beginningSeed -= weight;
        if(beginningSeed < 0) word = chunk;
      }
    });

    String firstChunk = word;

    int length = minLetters + random.nextInt(maxLetters - minLetters + 1);
    while(word.length < length) {
      Map<String, int> weights = new Map<String, int>();
      int totalWeight = 0;
      int endingType = (word.length == length - 1) ? 1 : 0;

      int endingLettersWeight = 0;
      for(int endingLength = 2; endingLength <= min(word.length, 4)
          ; endingLength++) {
        String ending = word.substring(word.length - endingLength);
        int endingWeight = endingWeights[endingLength];

        List<Map<String, int>> endingList = _endings[ending];
        if(endingList == null) continue;

        Map<String, int> endingMap = _endings[ending][endingType];
        if(endingMap == null) continue;

        endingMap.forEach((letter, weight) {
          weight *= endingWeight;
          if(weights.containsKey(letter)) {
            weights[letter] += weight;
          } else {
            weights[letter] = weight;
          }
          totalWeight += weight;
        });

        if(endingType == 0) {
          endingMap = _endings[ending][1];
          if(endingMap == null) continue;
          endingMap.forEach((letter, weight) {
            endingLettersWeight += weight * endingWeight;
          });
        }
      }

      if(totalWeight == 0) {
        if(endingType == 1 && length < maxLetters) {
          length++;
        } else {
          return "";
        }
        continue;
      }

      if(endingType == 0) {
        if(totalWeight * minDifference < endingLettersWeight) {
          return "";
        }
      }

      int weightSeed = random.nextInt(totalWeight);
      weights.forEach((letter, weight) {
        if(weightSeed >= 0) {
          weightSeed -= weight;
          if(weightSeed < 0) word += letter;
        }
      });
    }

    return word;
  }
}