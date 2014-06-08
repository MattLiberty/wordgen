library wordgen;

import 'dart:html';
import 'dart:math';

import 'base.dart';


int rows = 30, cols = 12;
int minLetters = 5, maxLetters = 11;
TableElement table;


void generate(Base base) {
  cols = document.documentElement.clientWidth ~/ 9 ~/ maxLetters;
  rows = (document.documentElement.clientHeight - 52) ~/ 26;
  table.text = "";
  for(int row = 0; row < rows; row++) {
    TableRowElement row = new TableRowElement();
    table.append(row);
    table.attributes["align"] = "center";
    for(int col = 0; col < cols; col++) {
      TableCellElement cell = new TableCellElement();
      table.append(cell);
      cell.attributes["align"] = "center";
      cell.text = base.generateWord(minLetters, maxLetters);
    }
  }
}


void init(Base base) {
  table = new TableElement();
  document.body.append(table);

  document.body.children.first.remove();
  document.getElementById("center").hidden = false;

  document.getElementById("gen").onClick.listen((event) {
    generate(base);
  });

  InputElement minField = document.getElementById("min");
  InputElement maxField = document.getElementById("max");

  minField.onChange.listen((event) {
    minLetters = int.parse(minField.value);
    maxLetters = max(minLetters, maxLetters);
    maxField.value = maxLetters.toString();
  });

  maxField.onChange.listen((event) {
    maxLetters = int.parse(maxField.value);
    minLetters = min(minLetters, maxLetters);
    minField.value = minLetters.toString();
  });

  generate(base);
}