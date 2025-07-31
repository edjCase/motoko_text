import CharX "../src/CharX";
import { test } "mo:test";

test(
  "toUpper",
  func() {
    // Basic Latin (ASCII) tests
    assert (CharX.toUpper('a') == 'A');
    assert (CharX.toUpper('b') == 'B');
    assert (CharX.toUpper('z') == 'Z');
    assert (CharX.toUpper('A') == 'A'); // Already uppercase
    assert (CharX.toUpper('0') == '0'); // Non-alphabetic
    assert (CharX.toUpper(' ') == ' '); // Whitespace
    assert (CharX.toUpper('!') == '!'); // Symbol

  },
);

test(
  "toLower",
  func() {
    // Basic Latin (ASCII) tests
    assert (CharX.toLower('A') == 'a');
    assert (CharX.toLower('B') == 'b');
    assert (CharX.toLower('Z') == 'z');
    assert (CharX.toLower('a') == 'a'); // Already lowercase
    assert (CharX.toLower('0') == '0'); // Non-alphabetic
    assert (CharX.toLower(' ') == ' '); // Whitespace
    assert (CharX.toLower('!') == '!'); // Symbol

  },
);
