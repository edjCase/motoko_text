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

    public type Sequence = Slice.Sequence<Char> or {
        #text : Text;
    };

    public type MapSlice<T> = TextSlice -> T;

    public type SliceMatchInfo = {
        startsWith : Sequence;
        endsWith : Sequence;
        trimMatch : Bool;
        strictStart : Bool;
    };

    public type MappedSliceMatchInfo<T> = SliceMatchInfo and {
        map : MapSlice<T>;
    };

    public class TextSlice(innerSlice : Slice.Slice<Char>) = sliceRef {

        public func tryMatchSlice(info : SliceMatchInfo) : ?TextSlice {
            let innerTokenMatchInfo = mapInfo(info); // Map to inner slice match info
            switch (innerSlice.tryMatchSlice(innerTokenMatchInfo)) {
                case (null) null; // If not matched, return null
                case (?s) ?TextSlice(s); // If matched, map the slice
            };
        };

        public func tryMatchAndMapSlice<T>(info : MappedSliceMatchInfo<T>) : ?T {
            switch (tryMatchSlice(info)) {
                case (null) null; // If not matched, return null
                case (?s) ?info.map(s); // If matched, map the slice
            };
        };

        public func matchAndMapSlice<T>(cases : [MappedSliceMatchInfo<T>], catchAllCase : MapSlice<T>) : T {
            for (c in Iter.fromArray(cases)) {
                let result = tryMatchAndMapSlice(c);
                switch (result) {
                    case (null)(); // Didn't match case, try next case
                    case (?slice) return slice; // matched case, return result
                };
            };
            catchAllCase(sliceRef);
        };

        public func slice(startIndex : Nat, length : ?Nat) : TextSlice {
            TextSlice(innerSlice.slice(startIndex, length));
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

        private func mapInfo(c : SliceMatchInfo) : Slice.SliceMatchInfo<Char> {
            {
                startsWith = mapValue(c.startsWith);
                endsWith = mapValue(c.endsWith);
                trimMatch = c.trimMatch;
                strictStart = c.strictStart;
            };
        };
    };

    public func slice(value : Sequence, startIndex : Nat, length : ?Nat) : TextSlice {
        let innerValue : Slice.Sequence<Char> = mapValue(value);

        let innerSlice = Slice.Slice<Char>(innerValue, Char.equal, startIndex, length);
        TextSlice(innerSlice);
    };

    private func mapValue(value : Sequence) : Slice.Sequence<Char> {
        switch (value) {
            case (#text(t)) #buffer(Buffer.fromIter<Char>(t.chars()));
            case (#array(a)) #array(a);
            case (#buffer(b)) #buffer(b);
            case (#slice(s)) #slice(s);
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
};
