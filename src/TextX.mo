import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import NatX "mo:xtended-numbers/NatX";
import Debug "mo:base/Debug";
import Slice "Slice";
import Array "mo:base/Array";

module TextX {

    public type TextValue = Slice.Value<Char> or {
        #text : Text;
    };
    public type MatchCatchAll = TextSlice -> TextSlice;

    public type AffixMatch = {
        value : TextValue;
        onMatch : { #strip };
    };

    public type MatchType = {
        #prefix : AffixMatch;
        #suffix : AffixMatch;
    };

    public class TextSlice(innerSlice : Slice.Slice<Char>) {

        public func match(cases : [MatchType], catchAllCase : MatchCatchAll) : TextSlice {
            let innerCases : [Slice.MatchType<Char>] = Array.map(cases, mapCase);
            let innerCatchAllCase : Slice.MatchCatchAll<Char> = mapBody(catchAllCase);
            let newInnerSlice = innerSlice.match(innerCases, innerCatchAllCase);
            TextSlice(newInnerSlice);
        };

        public func asCharSequence() : Slice.Slice<Char> {
            innerSlice;
        };

        public func toIter() : Iter.Iter<Char> {
            innerSlice.toIter();
        };

        public func toText() : Text {
            Text.fromIter(toIter());
        };

        private func mapCase(c : MatchType) : Slice.MatchType<Char> {
            switch (c) {
                case (#prefix(p)) #prefix({
                    value = mapValue(p.value);
                    onMatch = p.onMatch;
                });
                case (#suffix(s)) #suffix({
                    value = mapValue(s.value);
                    onMatch = s.onMatch;
                });
            };
        };

        private func mapBody(body : MatchCatchAll) : Slice.MatchCatchAll<Char> {
            func(textSlice : Slice.Slice<Char>) : Slice.Slice<Char> {
                body(TextSlice(textSlice)).asCharSequence();
            };
        };
    };

    public func slice(value : TextValue, startIndex : Nat, length : ?Nat) : TextSlice {
        let innerValue : Slice.Value<Char> = mapValue(value);

        let innerSlice = Slice.Slice<Char>(innerValue, Char.equal, startIndex, length);
        TextSlice(innerSlice);
    };

    private func mapValue(value : TextValue) : Slice.Value<Char> {
        switch (value) {
            case (#text(t)) #buffer(Buffer.fromIter<Char>(t.chars()));
            case (#iter(i)) #iter(i);
            case (#array(a)) #array(a);
            case (#buffer(b)) #buffer(b);
        };
    };

    public func fromUtf8Bytes(bytes : Iter.Iter<Nat8>) : Iter.Iter<Char> {
        return Utf8Iter(bytes);
    };

    private class Utf8Iter(bytes : Iter.Iter<Nat8>) : Iter.Iter<Char> {
        private func nextNat32(isSubByte : Bool) : ?Nat32 {
            do ? {
                let byte = bytes.next()!;
                if (isSubByte) {
                    // Check for `10` prefix
                    if (byte & 0xC0 == 0xC0) {
                        // Remove prefix
                        return ?NatX.from8To32(byte & 0x3F);
                    };
                    // Invalid sub byte
                    return null;
                };
                NatX.from8To32(byte);
            };
        };

        public func next() : ?Char {
            do ? {
                loop {
                    let byte1 = nextNat32(false)!;
                    let nat32 = if (byte1 & 0x80 == 0) {
                        // Single byte encoding
                        // 0xxxxxxx
                        byte1 & 0x7F;
                    } else if (byte1 & 0xE0 == 0xC0) {
                        // Two bytes encoded
                        // 110xxxxx 10xxxxxx
                        let byte2 = nextNat32(true)!;
                        (byte1 & 0x1F) << 6 & byte2;
                    } else if (byte1 & 0xF0 == 0xE0) {
                        // Three bytes encoded
                        // 1110xxxx 10xxxxxx 10xxxxxx
                        let byte2 = nextNat32(true)!;
                        let byte3 = nextNat32(true)!;
                        ((byte1 & 0x0F) << 12) & (byte2 << 6) & byte3;
                    } else if (byte1 & 0xF8 == 0xF0) {
                        // Four bytes encoded
                        // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                        let byte2 = nextNat32(true)!;
                        let byte3 = nextNat32(true)!;
                        let byte4 = nextNat32(true)!;
                        ((byte1 & 0x07) << 18) & (byte2 << 12) & (byte3 << 6) & byte4;
                    } else {
                        // Invalid first byte
                        return null;
                    };
                    return ?Char.fromNat32(nat32);
                };
            };
        };
    };

    private class Reader(iter : Iter.Iter<Char>) {
        var peekCache : ?Char = null;
        var currentValue : ?Char = null;
        public var position : ?Nat = null;

        public func current() : ?Char {
            currentValue;
        };

        public func peek() : ?Char {
            if (peekCache == null) {
                peekCache := iter.next();
            };
            return peekCache;
        };

        public func next() : ?Char {
            position := switch (position) {
                case (null) ?0;
                case (?p) ?(p + 1);
            };
            if (peekCache == null) {
                iter.next();
            } else {
                let next = peekCache;
                // clear cache since it moved to next
                peekCache := null;
                currentValue := next;
                next;
            };
        };

        public func skipWhitespace() : () {
            loop {
                switch (isNextWhitespace()) {
                    case (?true) {
                        let _ = next(); // Skip whitespace
                    };
                    case (_) {
                        return;
                    };
                };
            };
        };

        public func readUntil(
            pattern : { #char : Char; #text : Text; #whitespace; #end },
            mustMatchPattern : Bool,
        ) : ?Text {
            do ? {
                let isPatternMatched : (char : Char) -> Bool = switch (pattern) {
                    case (#char(c)) func(char : Char) : Bool {
                        c == char;
                    };
                    case (#text(t)) {
                        var currentText : Text = "";
                        func(char : Char) : Bool {
                            // Append the character to the end of the current text value
                            currentText := currentText # Text.fromChar(char);
                            // If the current text is the prefix, then its potentially the right value
                            if (Text.startsWith(t, #text(currentText))) {
                                t == currentText; // Return true if not just the prefix but whole value
                            } else {
                                // If not partially matching, reset 'current text value'
                                currentText := ""; // reset
                                false;
                            };
                        };
                    };
                    case (#whitespace) Char.isWhitespace;
                    case (#end) func(char : Char) : Bool {
                        false; // Awlays return false because if there is a character, its not the end
                    };
                };

                let charBuffer = Buffer.Buffer<Char>(0);
                label l loop {
                    let currentChar : Char = switch (next()) {
                        case (null) {
                            // Check to see if the end of characters is expected, if not return null
                            if (not mustMatchPattern or pattern == #end) {
                                break l;
                            };
                            return null;
                        };
                        case (?c) c;
                    };

                    let patternMatched : Bool = isPatternMatched(currentChar);
                    charBuffer.add(currentChar);
                    if (patternMatched) {
                        break l;
                    };
                };
                return ?Text.fromIter(charBuffer.vals()); // TODO optimize each char becoming text and concat? Cant find a Buffer<Char> -> Text
            };
        };

        private func isNextWhitespace() : ?Bool {
            do ? {
                let nextChar = peek()!;
                Char.isWhitespace(nextChar);
            };
        };

    };
};
