import TextX "../src/TextX";
import Text "mo:core/Text";
import Runtime "mo:core/Runtime";
import { test } "mo:test";
import Bool "mo:core/Bool";

func assertText(actual : Text, expected : Text) {
  if (actual != expected) {
    Runtime.trap("expected: '" # expected # "', actual: '" # actual # "'");
  };
};

test(
  "slice",
  func() {
    assertText(TextX.slice("Hello", 1, 3), "ell");
    assertText(TextX.slice("Hello", 1, 1), "e");
    assertText(TextX.slice("Hello", 1, 0), "");
    assertText(TextX.slice("Hello", 0, 5), "Hello");
    assertText(TextX.slice("Hello", 0, 6), "Hello");
    assertText(TextX.slice("Hello", 6, 6), "");
  },
);

test(
  "sliceToEnd",
  func() {
    assertText(TextX.sliceToEnd("Hello", 1), "ello");
    assertText(TextX.sliceToEnd("Hello", 0), "Hello");
    assertText(TextX.sliceToEnd("Hello", 5), "");
  },
);

test(
  "isEmptyOrWhitespace",
  func() {
    let check = func(value : Text, expected : Bool) {
      if (TextX.isEmptyOrWhitespace(value) != expected) {
        Runtime.trap("Value: " # value # ", expected: '" # Bool.toText(expected) # "', actual: '" # value # "'");
      };

    };
    check("", true);
    check(" ", true);
    check("  ", true);
    check("sdfsdf", false);
  },
);

test(
  "equalIgnoreCase",
  func() {
    let check = func(x : Text, y : Text, expected : Bool) {
      if (TextX.equalIgnoreCase(x, y) != expected) {
        Runtime.trap("x: '" # x # "', y: '" # y # "', expected: " # Bool.toText(expected));
      };
    };

    // 1. Basic lowercase/uppercase comparisons
    check("hello", "HELLO", true);
    check("WORLD", "world", true);

    // 2. Mixed case comparisons
    check("HelloWorld", "hElLoWoRlD", true);
    check("camelCase", "CaMeLcAsE", true);

    // 3. Empty strings and spaces
    check("", "", true);
    check(" ", " ", true);
    check("   ", "   ", true);

    // 4. Special characters and numbers
    check("Hello123!", "HELLO123!", true);
    check("Test@#$%", "test@#$%", true);

    // 5. Different strings that should not match
    check("hello", "hallo", false);
    check("test", "tset", false);

    // 7. Strings with whitespace
    check("hello world", "HELLO WORLD", true);
    check("  spaces  ", "  SPACES  ", true);

    // 8. Single characters
    check("a", "A", true);
    check("Z", "z", true);

    // 9. Longer text
    check("ThisIsAVeryLongStringToTest", "thirisaverylongstringtotest", false);
    check("ThisIsAVeryLongStringToTest", "thisisaverylongstringtotest", true);
  },
);
