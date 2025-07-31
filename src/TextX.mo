import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Char "mo:core/Char";

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

};
