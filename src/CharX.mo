import Char "mo:core/Char";

module CharX {
  /// Converts an uppercase character to lowercase.
  /// Handles ASCII
  ///
  /// ```motoko
  /// let lowerA = TextX.toLower('A');
  /// // lowerA is 'a'
  /// ```
  public func toLower(char : Char) : Char {
    switch (char) {
      // Basic Latin (ASCII)
      case ('A') 'a';
      case ('B') 'b';
      case ('C') 'c';
      case ('D') 'd';
      case ('E') 'e';
      case ('F') 'f';
      case ('G') 'g';
      case ('H') 'h';
      case ('I') 'i';
      case ('J') 'j';
      case ('K') 'k';
      case ('L') 'l';
      case ('M') 'm';
      case ('N') 'n';
      case ('O') 'o';
      case ('P') 'p';
      case ('Q') 'q';
      case ('R') 'r';
      case ('S') 's';
      case ('T') 't';
      case ('U') 'u';
      case ('V') 'v';
      case ('W') 'w';
      case ('X') 'x';
      case ('Y') 'y';
      case ('Z') 'z';
      case (c) c;
    };
  };

  /// Converts a lowercase character to uppercase.
  /// Handles ASCII
  ///
  /// ```motoko
  /// let upperA = TextX.toUpper('a');
  /// // upperA is 'A'
  /// ```
  public func toUpper(char : Char) : Char {
    switch (char) {
      // Basic Latin (ASCII)
      case ('a') 'A';
      case ('b') 'B';
      case ('c') 'C';
      case ('d') 'D';
      case ('e') 'E';
      case ('f') 'F';
      case ('g') 'G';
      case ('h') 'H';
      case ('i') 'I';
      case ('j') 'J';
      case ('k') 'K';
      case ('l') 'L';
      case ('m') 'M';
      case ('n') 'N';
      case ('o') 'O';
      case ('p') 'P';
      case ('q') 'Q';
      case ('r') 'R';
      case ('s') 'S';
      case ('t') 'T';
      case ('u') 'U';
      case ('v') 'V';
      case ('w') 'W';
      case ('x') 'X';
      case ('y') 'Y';
      case ('z') 'Z';

      case (c) c;
    };
  };
};
