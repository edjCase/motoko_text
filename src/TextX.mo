import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import NatX "mo:xtended-numbers/NatX";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import CharX "CharX";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
import Prelude "mo:base/Prelude";

module TextX {
    public func toLower(text : Text) : Text {
        let buffer = Buffer.Buffer<Char>(text.size());
        for (char in text.chars()) {
            buffer.add(CharX.toLower(char));
        };
        return Text.fromIter(buffer.vals());
    };

    public func toUpper(text : Text) : Text {
        let buffer = Buffer.Buffer<Char>(text.size());
        for (char in text.chars()) {
            buffer.add(CharX.toUpper(char));
        };
        return Text.fromIter(buffer.vals());
    };

    public func slice(text : Text, startIndex : Nat, length : Nat) : Text {
        if (length < 1 or startIndex >= text.size()) {
            return "";
        };
        let buffer = Buffer.Buffer<Char>(length);
        let textIter = text.chars();
        var i = 0;
        label l loop {
            if (i >= startIndex) {
                break l;
            };
            let _ = textIter.next();
            i += 1;
        };

        var j = 0;
        label l loop {
            if (j >= length) {
                break l;
            };
            let ?char = textIter.next() else break l;
            buffer.add(char);
            j += 1;
        };
        return Text.fromIter(buffer.vals());
    };

    public func sliceToEnd(text : Text, startIndex : Nat) : Text {
        slice(text, startIndex, text.size() - startIndex);
    };

    public func fromUtf8Bytes(bytes : Iter.Iter<Nat8>) : Iter.Iter<Char> {
        return Utf8CharIter(bytes);
    };

    public func toUtf8Bytes(characters : Iter.Iter<Char>) : Iter.Iter<Nat8> {
        return Utf8ByteIter(characters);
    };

    public func isEmpty(text : Text) : Bool {
        text.size() == 0;
    };

    public func isEmptyOrWhitespace(text : Text) : Bool {
        for (char in text.chars()) {
            if (not Char.isWhitespace(char)) {
                return false;
            };
        };
        return true;
    };

    private class Utf8ByteIter(chars : Iter.Iter<Char>) : Iter.Iter<Nat8> {
        let buffer = Buffer.Buffer<Nat8>(4);

        public func next() : ?Nat8 {
            if (buffer.size() <= 0) {
                getNextSetOfBytes(); // Populate buffer
            };
            if (buffer.size() <= 0) {
                return null; // If still no bytes, we are done
            };
            return ?buffer.remove(buffer.size() - 1); // Remove from end for optimization
        };

        private func getNextSetOfBytes() {
            let char = switch (chars.next()) {
                case (?char) char;
                case (null) return;
            };
            let nat32 = Char.toNat32(char);
            if (nat32 <= 0x7F) {
                // Single byte encoding
                // 0xxxxxxx
                let byte1 = NatX.from32To8(nat32);
                buffer.add(byte1);
            } else if (nat32 <= 0x7FF) {
                // Two bytes encoded
                // 110xxxxx 10xxxxxx
                let byte1 = NatX.from32To8((nat32 >> 6) | 0xC0);
                let byte2 = NatX.from32To8((nat32 & 0x3F) | 0x80);
                // Add in reverse order for optimization when getting next byte
                buffer.add(byte2);
                buffer.add(byte1);
            } else if (nat32 <= 0xFFFF) {
                // Three bytes encoded
                // 1110xxxx 10xxxxxx 10xxxxxx
                let byte1 = NatX.from32To8((nat32 >> 12) | 0xE0);
                let byte2 = NatX.from32To8(((nat32 >> 6) & 0x3F) | 0x80);
                let byte3 = NatX.from32To8((nat32 & 0x3F) | 0x80);
                // Add in reverse order for optimization when getting next byte
                buffer.add(byte3);
                buffer.add(byte2);
                buffer.add(byte1);
            } else if (nat32 <= 0x10FFFF) {
                // Four bytes encoded
                // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                let byte1 = NatX.from32To8((nat32 >> 18) | 0xF0);
                let byte2 = NatX.from32To8(((nat32 >> 12) & 0x3F) | 0x80);
                let byte3 = NatX.from32To8(((nat32 >> 6) & 0x3F) | 0x80);
                let byte4 = NatX.from32To8((nat32 & 0x3F) | 0x80);
                // Add in reverse order for optimization when getting next byte
                buffer.add(byte4);
                buffer.add(byte3);
                buffer.add(byte2);
                buffer.add(byte1);
            } else {
                Debug.trap("Invalid UTF8 character: " # Char.toText(char));
            };
        };
    };

    private class Utf8CharIter(bytes : Iter.Iter<Nat8>) : Iter.Iter<Char> {
        private func nextNat32(isSubByte : Bool) : ?Nat32 {
            do ? {
                let byte = bytes.next()!;
                if (isSubByte) {
                    // Check for `10` prefix which indicates a sub byte
                    if (byte & 0x80 == 0x80) {
                        // Remove prefix and convert to nat32
                        return ?NatX.from8To32(byte & 0x3F);
                    };
                    // Invalid sub byte
                    Debug.trap("Invalid UTF8 byte. Expected 10xxxxxx but got: " # NatX.toTextAdvanced(Nat8.toNat(byte), #binary));
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
                        (byte1 & 0x1F) << 6 | byte2;
                    } else if (byte1 & 0xF0 == 0xE0) {
                        // Three bytes encoded
                        // 1110xxxx 10xxxxxx 10xxxxxx
                        let byte2 = nextNat32(true)!;
                        let byte3 = nextNat32(true)!;
                        ((byte1 & 0x0F) << 12) | (byte2 << 6) | byte3;
                    } else if (byte1 & 0xF8 == 0xF0) {
                        // Four bytes encoded
                        // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                        let byte2 = nextNat32(true)!;
                        let byte3 = nextNat32(true)!;
                        let byte4 = nextNat32(true)!;
                        ((byte1 & 0x07) << 18) | (byte2 << 12) | (byte3 << 6) | byte4;
                    } else {
                        Debug.trap("Invalid UTF8 first byte: " # NatX.toTextAdvanced(Nat32.toNat(byte1), #binary));
                    };
                    return ?Char.fromNat32(nat32);
                };
            };
        };
    };
};
