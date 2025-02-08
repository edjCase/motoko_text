import Char "mo:base/Char";

module CharX {
    /// Converts an uppercase character to lowercase.
    /// Handles ASCII, Latin-1 Supplement, and a selection of Latin Extended-A characters, including German Eszett (ẞ).
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

            // Latin-1 Supplement
            case ('À') 'à';
            case ('Á') 'á';
            case ('Â') 'â';
            case ('Ã') 'ã';
            case ('Ä') 'ä';
            case ('Å') 'å';
            case ('Æ') 'æ';
            case ('Ç') 'ç';
            case ('È') 'è';
            case ('É') 'é';
            case ('Ê') 'ê';
            case ('Ë') 'ë';
            case ('Ì') 'ì';
            case ('Í') 'í';
            case ('Î') 'î';
            case ('Ï') 'ï';
            case ('Ð') 'ð';
            case ('Ñ') 'ñ';
            case ('Ò') 'ò';
            case ('Ó') 'ó';
            case ('Ô') 'ô';
            case ('Õ') 'õ';
            case ('Ö') 'ö';
            case ('Ø') 'ø';
            case ('Ù') 'ù';
            case ('Ú') 'ú';
            case ('Û') 'û';
            case ('Ü') 'ü';
            case ('Ý') 'ý';
            case ('Þ') 'þ';
            case ('ẞ') 'ß';

            // Latin Extended-A
            case ('Ā') 'ā';
            case ('Ă') 'ă';
            case ('Ą') 'ą';
            case ('Ć') 'ć';
            case ('Ĉ') 'ĉ';
            case ('Ċ') 'ċ';
            case ('Č') 'č';
            case ('Ď') 'ď';
            case ('Đ') 'đ';
            case ('Ē') 'ē';
            case ('Ĕ') 'ĕ';
            case ('Ė') 'ė';
            case ('Ę') 'ę';
            case ('Ě') 'ě';
            case ('Ĝ') 'ĝ';
            case ('Ğ') 'ğ';
            case ('Ġ') 'ġ';
            case ('Ģ') 'ģ';
            case ('Ĥ') 'ĥ';
            case ('Ħ') 'ħ';
            case ('Ĩ') 'ĩ';
            case ('Ī') 'ī';
            case ('Ĭ') 'ĭ';
            case ('Į') 'į';
            case ('İ') 'i'; // Special case: capital I with dot above
            case ('Ĳ') 'ĳ';
            case ('Ĵ') 'ĵ';
            case ('Ķ') 'ķ';
            case ('Ĺ') 'ĺ';
            case ('Ļ') 'ļ';
            case ('Ľ') 'ľ';
            case ('Ŀ') 'ŀ';
            case ('Ł') 'ł';
            case ('Ń') 'ń';
            case ('Ņ') 'ņ';
            case ('Ň') 'ň';
            case ('Ŋ') 'ŋ';
            case ('Ō') 'ō';
            case ('Ŏ') 'ŏ';
            case ('Ő') 'ő';
            case ('Œ') 'œ';
            case ('Ƣ') 'ƣ';
            case ('Ư') 'ư';
            case ('Ŵ') 'ŵ';
            case ('Ŷ') 'ŷ';
            case ('Ȳ') 'ȳ';

            case (c) c;
        };
    };

    /// Converts a lowercase character to uppercase.
    /// Handles ASCII, Latin-1 Supplement, and a selection of Latin Extended-A characters, including German Eszett (ẞ).
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

            // Latin-1 Supplement
            case ('à') 'À';
            case ('á') 'Á';
            case ('â') 'Â';
            case ('ã') 'Ã';
            case ('ä') 'Ä';
            case ('å') 'Å';
            case ('æ') 'Æ';
            case ('ç') 'Ç';
            case ('è') 'È';
            case ('é') 'É';
            case ('ê') 'Ê';
            case ('ë') 'Ë';
            case ('ì') 'Ì';
            case ('í') 'Í';
            case ('î') 'Î';
            case ('ï') 'Ï';
            case ('ð') 'Ð';
            case ('ñ') 'Ñ';
            case ('ò') 'Ò';
            case ('ó') 'Ó';
            case ('ô') 'Ô';
            case ('õ') 'Õ';
            case ('ö') 'Ö';
            case ('ø') 'Ø';
            case ('ù') 'Ù';
            case ('ú') 'Ú';
            case ('û') 'Û';
            case ('ü') 'Ü';
            case ('ý') 'Ý';
            case ('þ') 'Þ';
            case ('ß') 'ẞ';

            // Latin Extended-A
            case ('ā') 'Ā';
            case ('ă') 'Ă';
            case ('ą') 'Ą';
            case ('ć') 'Ć';
            case ('ĉ') 'Ĉ';
            case ('ċ') 'Ċ';
            case ('č') 'Č';
            case ('ď') 'Ď';
            case ('đ') 'Đ';
            case ('ē') 'Ē';
            case ('ĕ') 'Ĕ';
            case ('ė') 'Ė';
            case ('ę') 'Ę';
            case ('ě') 'Ě';
            case ('ĝ') 'Ĝ';
            case ('ğ') 'Ğ';
            case ('ġ') 'Ġ';
            case ('ģ') 'Ģ';
            case ('ĥ') 'Ĥ';
            case ('ħ') 'Ħ';
            case ('ĩ') 'Ĩ';
            case ('ī') 'Ī';
            case ('ĭ') 'Ĭ';
            case ('į') 'Į';
            case ('ı') 'I'; // Special case: dotless i
            case ('ĳ') 'Ĳ';
            case ('ĵ') 'Ĵ';
            case ('ķ') 'Ķ';
            case ('ĺ') 'Ĺ';
            case ('ļ') 'Ļ';
            case ('ľ') 'Ľ';
            case ('ŀ') 'Ŀ';
            case ('ł') 'Ł';
            case ('ń') 'Ń';
            case ('ņ') 'Ņ';
            case ('ň') 'Ň';
            case ('ŋ') 'Ŋ';
            case ('ō') 'Ō';
            case ('ŏ') 'Ŏ';
            case ('ő') 'Ő';
            case ('œ') 'Œ';
            case ('ƣ') 'Ƣ';
            case ('ư') 'Ư';
            case ('ŵ') 'Ŵ';
            case ('ŷ') 'Ŷ';
            case ('ȳ') 'Ȳ';

            case (c) c;
        };
    };
};
