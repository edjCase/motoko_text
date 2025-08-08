import TextX "../src/TextX";
import Text "mo:core/Text";
import Runtime "mo:core/Runtime";
import { test } "mo:test";
import Bool "mo:core/Bool";
import Nat "mo:core/Nat";

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

test(
  "isNullOrEmptyOrWhitespace",
  func() {
    let check = func(value : ?Text, expected : Bool) {
      if (TextX.isNullOrEmptyOrWhitespace(value) != expected) {
        let valueText = switch(value) { case null "null"; case (?t) "\"" # t # "\""; };
        Runtime.trap("Value: " # valueText # ", expected: " # Bool.toText(expected));
      };
    };
    check(null, true);
    check(?"", true);
    check(?" ", true);
    check(?"  ", true);
    check(?"\t\n", true);
    check(?"Hello", false);
    check(?" Hello ", false);
  },
);

test(
  "isNullOrEmpty",
  func() {
    let check = func(value : ?Text, expected : Bool) {
      if (TextX.isNullOrEmpty(value) != expected) {
        let valueText = switch(value) { case null "null"; case (?t) "\"" # t # "\""; };
        Runtime.trap("Value: " # valueText # ", expected: " # Bool.toText(expected));
      };
    };
    check(null, true);
    check(?"", true);
    check(?" ", false);
    check(?"  ", false);
    check(?"Hello", false);
  },
);

test(
  "repeat",
  func() {
    assertText(TextX.repeat("Hi", 0), "");
    assertText(TextX.repeat("Hi", 1), "Hi");
    assertText(TextX.repeat("Hi", 3), "HiHiHi");
    assertText(TextX.repeat("", 5), "");
    assertText(TextX.repeat("A", 5), "AAAAA");
  },
);

test(
  "indexOf",
  func() {
    let checkText = func(text : Text, search : Text, expected : ?Nat) {
      let result = TextX.indexOf(text, #text search);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?n) Nat.toText(n); };
        let resultText = switch(result) { case null "null"; case (?n) Nat.toText(n); };
        Runtime.trap("indexOf(\"" # text # "\", \"" # search # "\") expected: " # expectedText # ", actual: " # resultText);
      };
    };
    
    let checkChar = func(text : Text, search : Char, expected : ?Nat) {
      let result = TextX.indexOf(text, #char search);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?n) Nat.toText(n); };
        let resultText = switch(result) { case null "null"; case (?n) Nat.toText(n); };
        Runtime.trap("indexOf char expected: " # expectedText # ", actual: " # resultText);
      };
    };

    let checkPredicate = func(text : Text, predicate : Char -> Bool, expected : ?Nat) {
      let result = TextX.indexOf(text, #predicate predicate);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?n) Nat.toText(n); };
        let resultText = switch(result) { case null "null"; case (?n) Nat.toText(n); };
        Runtime.trap("indexOf predicate expected: " # expectedText # ", actual: " # resultText);
      };
    };

    checkText("Hello, World!", "World", ?7);
    checkText("Hello", "xyz", null);
    checkText("Hello", "", ?0);
    checkText("", "test", null);
    checkText("abcabc", "abc", ?0);
    
    checkChar("Hello", 'l', ?2);
    checkChar("Hello", 'x', null);
    checkChar("Hello", 'H', ?0);

    checkPredicate("Hello123", func(c) { c >= '0' and c <= '9' }, ?5);
    checkPredicate("ABC", func(c) { c >= 'a' and c <= 'z' }, null);
    checkPredicate("Hello", func(c) { c == 'l' }, ?2);
  },
);

test(
  "lastIndexOf",
  func() {
    let checkText = func(text : Text, search : Text, expected : ?Nat) {
      let result = TextX.lastIndexOf(text, #text search);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?n) Nat.toText(n); };
        let resultText = switch(result) { case null "null"; case (?n) Nat.toText(n); };
        Runtime.trap("lastIndexOf(\"" # text # "\", \"" # search # "\") expected: " # expectedText # ", actual: " # resultText);
      };
    };
    
    let checkChar = func(text : Text, search : Char, expected : ?Nat) {
      let result = TextX.lastIndexOf(text, #char search);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?n) Nat.toText(n); };
        let resultText = switch(result) { case null "null"; case (?n) Nat.toText(n); };
        Runtime.trap("lastIndexOf char expected: " # expectedText # ", actual: " # resultText);
      };
    };

    let checkPredicate = func(text : Text, predicate : Char -> Bool, expected : ?Nat) {
      let result = TextX.lastIndexOf(text, #predicate predicate);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?n) Nat.toText(n); };
        let resultText = switch(result) { case null "null"; case (?n) Nat.toText(n); };
        Runtime.trap("lastIndexOf predicate expected: " # expectedText # ", actual: " # resultText);
      };
    };

    checkText("Hello, World, World!", "World", ?14);
    checkText("Hello", "xyz", null);
    checkText("Hello", "", ?5);
    checkText("abcabc", "abc", ?3);
    
    checkChar("Hello", 'l', ?3);
    checkChar("Hello", 'x', null);
    checkChar("Hello", 'H', ?0);

    checkPredicate("Hello123World456", func(c) { c >= '0' and c <= '9' }, ?15);
    checkPredicate("ABC", func(c) { c >= 'a' and c <= 'z' }, null);
    checkPredicate("Hello", func(c) { c == 'l' }, ?3);
  },
);

test(
  "trimWhitespace",
  func() {
    assertText(TextX.trimWhitespace("  Hello, World!  "), "Hello, World!");
    assertText(TextX.trimWhitespace("Hello"), "Hello");
    assertText(TextX.trimWhitespace("   "), "");
    assertText(TextX.trimWhitespace(""), "");
    assertText(TextX.trimWhitespace("\t\nHello\t\n"), "Hello");
  },
);

test(
  "padStart",
  func() {
    assertText(TextX.padStart("42", 5, '0'), "00042");
    assertText(TextX.padStart("Hello", 3, ' '), "Hello");
    assertText(TextX.padStart("", 3, 'x'), "xxx");
    assertText(TextX.padStart("test", 4, '-'), "test");
  },
);

test(
  "padEnd",
  func() {
    assertText(TextX.padEnd("42", 5, '0'), "42000");
    assertText(TextX.padEnd("Hello", 3, ' '), "Hello");
    assertText(TextX.padEnd("", 3, 'x'), "xxx");
    assertText(TextX.padEnd("test", 4, '-'), "test");
  },
);

test(
  "left",
  func() {
    assertText(TextX.left("Hello, World!", 5), "Hello");
    assertText(TextX.left("Hi", 5), "Hi");
    assertText(TextX.left("Hello", 0), "");
    assertText(TextX.left("", 5), "");
  },
);

test(
  "right",
  func() {
    assertText(TextX.right("Hello, World!", 6), "World!");
    assertText(TextX.right("Hi", 5), "Hi");
    assertText(TextX.right("Hello", 0), "");
    assertText(TextX.right("", 5), "");
  },
);

test(
  "isNumeric",
  func() {
    let check = func(value : Text, expected : Bool) {
      if (TextX.isNumeric(value) != expected) {
        Runtime.trap("isNumeric(\"" # value # "\") expected: " # Bool.toText(expected));
      };
    };
    check("12345", true);
    check("123a", false);
    check("", false);
    check("0", true);
    check("1234567890", true);
    check("123.45", false);
    check("abc", false);
  },
);

test(
  "isAlpha",
  func() {
    let check = func(value : Text, expected : Bool) {
      if (TextX.isAlpha(value) != expected) {
        Runtime.trap("isAlpha(\"" # value # "\") expected: " # Bool.toText(expected));
      };
    };
    check("Hello", true);
    check("Hello123", false);
    check("", false);
    check("abc", true);
    check("ABC", true);
    check("aBc", true);
    check("Hello!", false);
  },
);

test(
  "isAlphaNumeric",
  func() {
    let check = func(value : Text, expected : Bool) {
      if (TextX.isAlphaNumeric(value) != expected) {
        Runtime.trap("isAlphaNumeric(\"" # value # "\") expected: " # Bool.toText(expected));
      };
    };
    check("Hello123", true);
    check("Hello-123", false);
    check("", false);
    check("abc", true);
    check("123", true);
    check("Hello!", false);
    check("Test123ABC", true);
  },
);

test(
  "charAt",
  func() {
    let check = func(text : Text, index : Nat, expected : ?Char) {
      let result = TextX.charAt(text, index);
      if (result != expected) {
        let expectedText = switch(expected) { case null "null"; case (?c) "'" # Text.fromChar(c) # "'"; };
        let resultText = switch(result) { case null "null"; case (?c) "'" # Text.fromChar(c) # "'"; };
        Runtime.trap("charAt(\"" # text # "\", " # Nat.toText(index) # ") expected: " # expectedText # ", actual: " # resultText);
      };
    };
    check("Hello", 1, ?'e');
    check("Hello", 10, null);
    check("Hello", 0, ?'H');
    check("", 0, null);
    check("A", 0, ?'A');
  },
);

test(
  "safeSlice",
  func() {
    assertText(TextX.safeSlice("Hello", 1, 3), "ell");
    assertText(TextX.safeSlice("Hello", 10, 5), "");
    assertText(TextX.safeSlice("Hello", 3, 10), "lo");
    assertText(TextX.safeSlice("Hello", 0, 0), "");
    assertText(TextX.safeSlice("", 0, 5), "");
  },
);

test(
  "truncate",
  func() {
    assertText(TextX.truncate("Hello, World!", 8, true), "Hello...");
    assertText(TextX.truncate("Hello, World!", 8, false), "Hello, W");
    assertText(TextX.truncate("Hello", 10, true), "Hello");
    assertText(TextX.truncate("Hello", 3, true), "Hel");
    assertText(TextX.truncate("Hello", 2, true), "He");
  },
);

test(
  "normalizeWhitespace",
  func() {
    assertText(TextX.normalizeWhitespace("Hello   \n\t  World!"), "Hello World!");
    assertText(TextX.normalizeWhitespace("Hello World"), "Hello World");
    assertText(TextX.normalizeWhitespace("   "), "");
    assertText(TextX.normalizeWhitespace(""), "");
    assertText(TextX.normalizeWhitespace("  a  b  c  "), "a b c");
  },
);

test(
  "toCamelCase",
  func() {
    assertText(TextX.toCamelCase("hello world test"), "helloWorldTest");
    assertText(TextX.toCamelCase("alreadyCamelCase"), "alreadycamelcase");
    assertText(TextX.toCamelCase("HELLO WORLD"), "helloWorld");
    assertText(TextX.toCamelCase(""), "");
    assertText(TextX.toCamelCase("single"), "single");
  },
);

test(
  "toPascalCase",
  func() {
    assertText(TextX.toPascalCase("hello world test"), "HelloWorldTest");
    assertText(TextX.toPascalCase("AlreadyPascalCase"), "Alreadypascalcase");
    assertText(TextX.toPascalCase("HELLO WORLD"), "HelloWorld");
    assertText(TextX.toPascalCase(""), "");
    assertText(TextX.toPascalCase("single"), "Single");
  },
);

test(
  "toSnakeCase",
  func() {
    assertText(TextX.toSnakeCase("Hello World Test"), "hello_world_test");
    assertText(TextX.toSnakeCase("already_snake_case"), "already_snake_case");
    assertText(TextX.toSnakeCase("HELLO WORLD"), "hello_world");
    assertText(TextX.toSnakeCase(""), "");
    assertText(TextX.toSnakeCase("single"), "single");
  },
);

test(
  "capitalize",
  func() {
    assertText(TextX.capitalize("hello"), "Hello");
    assertText(TextX.capitalize("Hello"), "Hello");
    assertText(TextX.capitalize("HELLO"), "Hello");
    assertText(TextX.capitalize(""), "");
    assertText(TextX.capitalize("a"), "A");
    assertText(TextX.capitalize("hELLO wORLD"), "Hello world");
  },
);

test(
  "concatOpt",
  func() {
    assertText(TextX.concatOpt("Hello", ?" World"), "Hello World");
    assertText(TextX.concatOpt("Hello", null), "Hello");
    assertText(TextX.concatOpt("", ?"World"), "World");
    assertText(TextX.concatOpt("", null), "");
  },
);

test(
  "concatBothOpt",
  func() {
    let check = func(x : ?Text, y : ?Text, expected : ?Text) {
      let result = TextX.concatBothOpt(x, y);
      if (result != expected) {
        let xText = switch(x) { case null "null"; case (?t) "\"" # t # "\""; };
        let yText = switch(y) { case null "null"; case (?t) "\"" # t # "\""; };
        let expectedText = switch(expected) { case null "null"; case (?t) "\"" # t # "\""; };
        let resultText = switch(result) { case null "null"; case (?t) "\"" # t # "\""; };
        Runtime.trap("concatBothOpt(" # xText # ", " # yText # ") expected: " # expectedText # ", actual: " # resultText);
      };
    };
    check(?"Hello", ?" World", ?"Hello World");
    check(null, ?"World", ?"World");
    check(?"Hello", null, ?"Hello");
    check(null, null, null);
    check(?"", ?"", ?"");
  },
);

test(
  "startsWithOpt",
  func() {
    let check = func(text : ?Text, pattern : Text.Pattern, expected : Bool) {
      let result = TextX.startsWithOpt(text, pattern);
      if (result != expected) {
        let textStr = switch(text) { case null "null"; case (?t) "\"" # t # "\""; };
        Runtime.trap("startsWithOpt(" # textStr # ") expected: " # Bool.toText(expected) # ", actual: " # Bool.toText(result));
      };
    };
    check(?"Hello World", #text("Hello"), true);
    check(null, #text("Hello"), false);
    check(?"Hello World", #char('H'), true);
    check(?"Hello World", #text("World"), false);
    check(?"", #text(""), true);
  },
);

test(
  "endsWithOpt",
  func() {
    let check = func(text : ?Text, pattern : Text.Pattern, expected : Bool) {
      let result = TextX.endsWithOpt(text, pattern);
      if (result != expected) {
        let textStr = switch(text) { case null "null"; case (?t) "\"" # t # "\""; };
        Runtime.trap("endsWithOpt(" # textStr # ") expected: " # Bool.toText(expected) # ", actual: " # Bool.toText(result));
      };
    };
    check(?"Hello World", #text("World"), true);
    check(null, #text("World"), false);
    check(?"Hello World", #char('d'), true);
    check(?"Hello World", #text("Hello"), false);
    check(?"", #text(""), true);
  },
);
