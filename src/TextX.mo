import Iter "mo:core@1/Iter";
import Text "mo:core@1/Text";
import Char "mo:core@1/Char";
import Nat "mo:core@1/Nat";

module TextX {

  /// Compares two text values ignoring case differences
  ///
  /// ```motoko
  /// let result = TextX.equalIgnoreCase("Hello", "hello"); // true
  /// let result2 = TextX.equalIgnoreCase("WORLD", "world"); // true
  /// let result3 = TextX.equalIgnoreCase("Hello", "Hallo"); // false
  /// ```
  public func equalIgnoreCase(x : Text, y : Text) : Bool {
    Text.toLower(x) == Text.toLower(y);
  };

  /// Returns a substring of the given text.
  ///
  /// ```motoko
  /// let sliced = TextX.slice("Hello, World!", 7, 5);
  /// // sliced is "World"
  /// ```
  public func slice(text : Text, startIndex : Nat, length : Nat) : Text {
    return text.chars()
    |> Iter.drop(_, startIndex)
    |> Iter.take(_, length)
    |> Text.fromIter(_);
  };

  /// Returns a substring from the given index to the end of the text.
  ///
  /// ```motoko
  /// let sliced = TextX.sliceToEnd("Hello, World!", 7);
  /// // sliced is "World!"
  /// ```
  public func sliceToEnd(text : Text, startIndex : Nat) : Text {
    slice(text, startIndex, text.size() - startIndex);
  };

  /// Checks if the given text is empty or contains only whitespace characters.
  ///
  /// ```motoko
  /// let emptyOrWhitespace = TextX.isEmptyOrWhitespace("   ");
  /// // emptyOrWhitespace is true
  /// let notEmptyOrWhitespace = TextX.isEmptyOrWhitespace("Hello");
  /// // notEmptyOrWhitespace is false
  /// ```
  public func isEmptyOrWhitespace(text : Text) : Bool {
    for (char in text.chars()) {
      if (not Char.isWhitespace(char)) {
        return false;
      };
    };
    return true;
  };

  /// Checks if the given optional text is null, empty, or contains only whitespace characters.
  ///
  /// ```motoko
  /// let result1 = TextX.isNullOrEmptyOrWhitespace(null); // true
  /// let result2 = TextX.isNullOrEmptyOrWhitespace(?""); // true
  /// let result3 = TextX.isNullOrEmptyOrWhitespace(?"   "); // true
  /// let result4 = TextX.isNullOrEmptyOrWhitespace(?"Hello"); // false
  /// ```
  public func isNullOrEmptyOrWhitespace(text : ?Text) : Bool {
    switch (text) {
      case (null) true;
      case (?t) isEmptyOrWhitespace(t);
    };
  };

  /// Checks if the given optional text is null or empty (has zero length).
  ///
  /// ```motoko
  /// let result1 = TextX.isNullOrEmpty(null); // true
  /// let result2 = TextX.isNullOrEmpty(?"")); // true
  /// let result3 = TextX.isNullOrEmpty(?"Hello"); // false
  /// let result4 = TextX.isNullOrEmpty(?"   "); // false (contains whitespace)
  /// ```
  public func isNullOrEmpty(text : ?Text) : Bool {
    switch (text) {
      case (null) true;
      case (?t) Text.isEmpty(t);
    };
  };

  /// Repeats the given text the specified number of times.
  ///
  /// ```motoko
  /// let repeated = TextX.repeat("Hi", 3); // "HiHiHi"
  /// let empty = TextX.repeat("test", 0); // ""
  /// ```
  public func repeat(text : Text, count : Nat) : Text {
    if (count == 0) return "";
    var result = "";
    var i = 0;
    while (i < count) {
      result #= text;
      i += 1;
    };
    result;
  };

  /// Returns the index of the first occurrence of the search pattern, or null if not found.
  ///
  /// ```motoko
  /// let index = TextX.indexOf("Hello, World!", #text "World"); // ?7
  /// let notFound = TextX.indexOf("Hello", #text "xyz"); // null
  /// let charIndex = TextX.indexOf("Hello", #char 'l'); // ?2
  /// ```
  public func indexOf(text : Text, pattern : Text.Pattern) : ?Nat {
    switch (pattern) {
      case (#text searchText) {
        if (Text.isEmpty(searchText)) return ?0;
        let textSize = text.size();
        let searchSize = searchText.size();
        if (searchSize > textSize) return null;

        var index = 0;
        let maxIndex = Nat.sub(textSize, searchSize);

        while (index <= maxIndex) {
          let substring = slice(text, index, searchSize);
          if (substring == searchText) {
            return ?index;
          };
          index += 1;
        };
        null;
      };
      case (#char searchChar) {
        var index = 0;
        for (char in text.chars()) {
          if (char == searchChar) {
            return ?index;
          };
          index += 1;
        };
        null;
      };
      case (#predicate predicate) {
        var index = 0;
        for (char in text.chars()) {
          if (predicate(char)) {
            return ?index;
          };
          index += 1;
        };
        null;
      };
    };
  };

  /// Returns the index of the last occurrence of the search pattern, or null if not found.
  ///
  /// ```motoko
  /// let index = TextX.lastIndexOf("Hello, World, World!", #text "World"); // ?14
  /// let notFound = TextX.lastIndexOf("Hello", #text "xyz"); // null
  /// let charIndex = TextX.lastIndexOf("Hello", #char 'l'); // ?3
  /// ```
  public func lastIndexOf(text : Text, pattern : Text.Pattern) : ?Nat {
    switch (pattern) {
      case (#text searchText) {
        if (Text.isEmpty(searchText)) return ?(text.size());
        let textSize = text.size();
        let searchSize = searchText.size();
        if (searchSize > textSize) return null;

        var index = Nat.sub(textSize, searchSize);

        loop {
          let substring = slice(text, index, searchSize);
          if (substring == searchText) {
            return ?index;
          };
          if (index == 0) return null;
          index := Nat.sub(index, 1);
        };
      };
      case (#char searchChar) {
        var lastIndex : ?Nat = null;
        var currentIndex = 0;
        for (char in text.chars()) {
          if (char == searchChar) {
            lastIndex := ?currentIndex;
          };
          currentIndex += 1;
        };
        lastIndex;
      };
      case (#predicate predicate) {
        var lastIndex : ?Nat = null;
        var currentIndex = 0;
        for (char in text.chars()) {
          if (predicate(char)) {
            lastIndex := ?currentIndex;
          };
          currentIndex += 1;
        };
        lastIndex;
      };
    };
  };

  /// Removes leading and trailing whitespace characters.
  ///
  /// ```motoko
  /// let trimmed = TextX.trimWhitespace("  Hello, World!  "); // "Hello, World!"
  /// let noChange = TextX.trimWhitespace("Hello"); // "Hello"
  /// ```
  public func trimWhitespace(text : Text) : Text {
    Text.trim(text, #predicate(Char.isWhitespace));
  };

  /// Pads the text with the specified character at the start to reach the target length.
  ///
  /// ```motoko
  /// let padded = TextX.padStart("42", 5, '0'); // "00042"
  /// let unchanged = TextX.padStart("Hello", 3, ' '); // "Hello" (already longer)
  /// ```
  public func padStart(text : Text, length : Nat, padChar : Char) : Text {
    let currentLength = text.size();
    if (currentLength >= length) return text;
    let paddingLength = Nat.sub(length, currentLength);
    let padding = repeat(Text.fromChar(padChar), paddingLength);
    padding # text;
  };

  /// Pads the text with the specified character at the end to reach the target length.
  ///
  /// ```motoko
  /// let padded = TextX.padEnd("42", 5, '0'); // "42000"
  /// let unchanged = TextX.padEnd("Hello", 3, ' '); // "Hello" (already longer)
  /// ```
  public func padEnd(text : Text, length : Nat, padChar : Char) : Text {
    let currentLength = text.size();
    if (currentLength >= length) return text;
    let paddingLength = Nat.sub(length, currentLength);
    let padding = repeat(Text.fromChar(padChar), paddingLength);
    text # padding;
  };

  /// Returns the leftmost characters of the text up to the specified length.
  ///
  /// ```motoko
  /// let left = TextX.left("Hello, World!", 5); // "Hello"
  /// let shorter = TextX.left("Hi", 5); // "Hi"
  /// ```
  public func left(text : Text, length : Nat) : Text {
    let textSize = text.size();
    let actualLength = if (length > textSize) textSize else length;
    slice(text, 0, actualLength);
  };

  /// Returns the rightmost characters of the text up to the specified length.
  ///
  /// ```motoko
  /// let right = TextX.right("Hello, World!", 6); // "World!"
  /// let shorter = TextX.right("Hi", 5); // "Hi"
  /// ```
  public func right(text : Text, length : Nat) : Text {
    let textSize = text.size();
    if (length >= textSize) return text;
    let startIndex = Nat.sub(textSize, length);
    slice(text, startIndex, length);
  };

  /// Checks if the given text contains only numeric characters (0-9).
  ///
  /// ```motoko
  /// let numeric = TextX.isNumeric("12345"); // true
  /// let notNumeric = TextX.isNumeric("123a"); // false
  /// let empty = TextX.isNumeric(""); // false
  /// ```
  public func isNumeric(text : Text) : Bool {
    if (Text.isEmpty(text)) return false;
    for (char in text.chars()) {
      if (not Char.isDigit(char)) {
        return false;
      };
    };
    return true;
  };

  /// Checks if the given text contains only alphabetic characters.
  ///
  /// ```motoko
  /// let alpha = TextX.isAlpha("Hello"); // true
  /// let notAlpha = TextX.isAlpha("Hello123"); // false
  /// let empty = TextX.isAlpha(""); // false
  /// ```
  public func isAlpha(text : Text) : Bool {
    if (Text.isEmpty(text)) return false;
    for (char in text.chars()) {
      if (not Char.isAlphabetic(char)) {
        return false;
      };
    };
    return true;
  };

  /// Checks if the given text contains only alphanumeric characters.
  ///
  /// ```motoko
  /// let alphaNum = TextX.isAlphaNumeric("Hello123"); // true
  /// let notAlphaNum = TextX.isAlphaNumeric("Hello-123"); // false
  /// let empty = TextX.isAlphaNumeric(""); // false
  /// ```
  public func isAlphaNumeric(text : Text) : Bool {
    if (Text.isEmpty(text)) return false;
    for (char in text.chars()) {
      if (not (Char.isAlphabetic(char) or Char.isDigit(char))) {
        return false;
      };
    };
    return true;
  };

  /// Returns the character at the specified index, or null if index is out of bounds.
  ///
  /// ```motoko
  /// let char = TextX.charAt("Hello", 1); // ?'e'
  /// let outOfBounds = TextX.charAt("Hello", 10); // null
  /// ```
  public func charAt(text : Text, index : Nat) : ?Char {
    if (index >= text.size()) return null;
    let chars = text.chars();
    var currentIndex = 0;
    for (char in chars) {
      if (currentIndex == index) {
        return ?char;
      };
      currentIndex += 1;
    };
    null;
  };

  /// Safely slices text with bounds checking. Returns the substring or empty string
  /// if indices are invalid.
  ///
  /// ```motoko
  /// let safe = TextX.safeSlice("Hello", 1, 3); // "ell"
  /// let outOfBounds = TextX.safeSlice("Hello", 10, 5); // ""
  /// let excessive = TextX.safeSlice("Hello", 3, 10); // "lo"
  /// ```
  public func safeSlice(text : Text, startIndex : Nat, length : Nat) : Text {
    let textSize = text.size();
    if (startIndex >= textSize or length == 0) return "";
    let actualLength = if (startIndex + length > textSize) {
      Nat.sub(textSize, startIndex);
    } else {
      length;
    };
    slice(text, startIndex, actualLength);
  };

  /// Truncates text to the specified maximum length, optionally adding ellipsis.
  ///
  /// ```motoko
  /// let truncated = TextX.truncate("Hello, World!", 8, true); // "Hello..."
  /// let exact = TextX.truncate("Hello, World!", 8, false); // "Hello, W"
  /// let unchanged = TextX.truncate("Hello", 10, true); // "Hello"
  /// ```
  public func truncate(text : Text, maxLength : Nat, addEllipsis : Bool) : Text {
    if (text.size() <= maxLength) return text;
    if (not addEllipsis) return left(text, maxLength);
    if (maxLength <= 3) return left(text, maxLength);
    let truncatedLength = Nat.sub(maxLength, 3);
    left(text, truncatedLength) # "...";
  };

  /// Normalizes whitespace by collapsing multiple consecutive whitespace characters
  /// into single spaces.
  ///
  /// ```motoko
  /// let normalized = TextX.normalizeWhitespace("Hello   \n\t  World!"); // "Hello World!"
  /// let unchanged = TextX.normalizeWhitespace("Hello World"); // "Hello World"
  /// ```
  public func normalizeWhitespace(text : Text) : Text {
    let trimmed = trimWhitespace(text);
    if (Text.isEmpty(trimmed)) return "";

    var result = "";
    var previousWasWhitespace = false;

    for (char in trimmed.chars()) {
      if (Char.isWhitespace(char)) {
        if (not previousWasWhitespace) {
          result #= " ";
          previousWasWhitespace := true;
        };
      } else {
        result #= Text.fromChar(char);
        previousWasWhitespace := false;
      };
    };
    result;
  };

  /// Converts text to camelCase format.
  ///
  /// ```motoko
  /// let camel = TextX.toCamelCase("hello world test"); // "helloWorldTest"
  /// let unchanged = TextX.toCamelCase("alreadyCamelCase"); // "alreadyCamelCase"
  /// ```
  public func toCamelCase(text : Text) : Text {
    let normalized = normalizeWhitespace(text);
    if (Text.isEmpty(normalized)) return "";

    let words = Text.split(normalized, #char ' ');
    var result = "";
    var isFirst = true;

    for (word in words) {
      if (not Text.isEmpty(word)) {
        if (isFirst) {
          result #= Text.toLower(word);
          isFirst := false;
        } else {
          result #= capitalize(word);
        };
      };
    };
    result;
  };

  /// Converts text to PascalCase format.
  ///
  /// ```motoko
  /// let pascal = TextX.toPascalCase("hello world test"); // "HelloWorldTest"
  /// let unchanged = TextX.toPascalCase("AlreadyPascalCase"); // "AlreadyPascalCase"
  /// ```
  public func toPascalCase(text : Text) : Text {
    let normalized = normalizeWhitespace(text);
    if (Text.isEmpty(normalized)) return "";

    let words = Text.split(normalized, #char ' ');
    var result = "";

    for (word in words) {
      if (not Text.isEmpty(word)) {
        result #= capitalize(word);
      };
    };
    result;
  };

  /// Converts text to snake_case format.
  ///
  /// ```motoko
  /// let snake = TextX.toSnakeCase("Hello World Test"); // "hello_world_test"
  /// let unchanged = TextX.toSnakeCase("already_snake_case"); // "already_snake_case"
  /// ```
  public func toSnakeCase(text : Text) : Text {
    let normalized = normalizeWhitespace(text);
    if (Text.isEmpty(normalized)) return "";

    let words = Text.split(normalized, #char ' ');
    let lowercaseWords = Iter.map(words, Text.toLower);
    Text.join("_", lowercaseWords);
  };

  /// Helper function to capitalize the first letter of a word.
  ///
  /// ```motoko
  /// let capitalized = TextX.capitalize("hello"); // "Hello"
  /// let unchanged = TextX.capitalize("Hello"); // "Hello"
  /// ```
  public func capitalize(text : Text) : Text {
    if (Text.isEmpty(text)) return text;
    let upperText = Text.toUpper(text);
    switch (charAt(upperText, 0)) {
      case null text;
      case (?firstChar) {
        let upperFirst = Text.fromChar(firstChar);
        if (text.size() == 1) {
          upperFirst;
        } else {
          let restText = Text.toLower(sliceToEnd(text, 1));
          upperFirst # restText;
        };
      };
    };
  };

  /// Concatenates a text with an optional text value.
  /// If the optional text is null, returns the original text unchanged.
  ///
  /// ```motoko
  /// let result1 = TextX.concatOpt("Hello", ?" World"); // "Hello World"
  /// let result2 = TextX.concatOpt("Hello", null); // "Hello"
  /// let result3 = TextX.concatOpt("", ?"World"); // "World"
  /// ```
  public func concatOpt(x : Text, y : ?Text) : Text {
    switch (y) {
      case (null) x;
      case (?yText) x # yText;
    };
  };

  /// Safely concatenates two optional text values.
  ///
  /// ```motoko
  /// let result1 = TextX.concatBothOpt(?"Hello", ?" World"); // ?"Hello World"
  /// let result2 = TextX.concatBothOpt(null, ?"World"); // ?"World"
  /// let result3 = TextX.concatBothOpt(null, null); // null
  /// ```
  public func concatBothOpt(x : ?Text, y : ?Text) : ?Text {
    switch (x, y) {
      case (null, null) null;
      case (?xText, null) ?xText;
      case (null, ?yText) ?yText;
      case (?xText, ?yText) ?(xText # yText);
    };
  };

  /// Null-safe version of Text.startsWith. Returns false if null
  ///
  /// ```motoko
  /// let result1 = TextX.startsWithOpt(?"Hello World", #text("Hello")); // true
  /// let result2 = TextX.startsWithOpt(null, #text("Hello")); // false
  /// let result3 = TextX.startsWithOpt(?"Hello World", #char('H')); // true
  /// ```
  public func startsWithOpt(text : ?Text, pattern : Text.Pattern) : Bool {
    switch (text) {
      case (null) false;
      case (?t) Text.startsWith(t, pattern);
    };
  };

  /// Null-safe version of Text.endsWith. Returns false if null
  ///
  /// ```motoko
  /// let result1 = TextX.endsWithOpt(?"Hello World", #text("World")); // true
  /// let result2 = TextX.endsWithOpt(null, #text("World")); // false
  /// let result3 = TextX.endsWithOpt(?"Hello World", #char('d')); // true
  /// ```
  public func endsWithOpt(text : ?Text, pattern : Text.Pattern) : Bool {
    switch (text) {
      case (null) false;
      case (?t) Text.endsWith(t, pattern);
    };
  };
};
