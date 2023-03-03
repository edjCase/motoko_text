import TextX "../src/TextX";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import { test } "mo:test";
import Array "mo:base/Array";

test(
    "toUpper",
    func() {
        assert (TextX.toUpper("abcdefghijklmnopqrstuvwxyz0123456789!") == "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!");
        assert (TextX.toUpper("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!") == "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!");
    },
);

test(
    "toLower",
    func() {
        assert (TextX.toLower("abcdefghijklmnopqrstuvwxyz0123456789!") == "abcdefghijklmnopqrstuvwxyz0123456789!");
        assert (TextX.toLower("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!") == "abcdefghijklmnopqrstuvwxyz0123456789!");
    },
);

test(
    "to and fromUtf8Bytes",
    func() {
        let check = func(bytes : [Nat8], expected : Text) {
            let actual = Text.fromIter(TextX.fromUtf8Bytes(Iter.fromArray(bytes)));
            if (actual != expected) {
                Debug.trap("expected: '" # expected # "', actual: '" # actual # "'");
            };
            let actualBytes = Iter.toArray(TextX.toUtf8Bytes(actual.chars()));
            if (actualBytes != bytes) {
                Debug.trap("expected: '" # debug_show (bytes) # "', actual: '" # debug_show (actualBytes) # "'");
            };

        };
        check([0x61, 0x62, 0x63, 0x64, 0x65], "abcde");
        check([0xC3, 0xA9], "é");
        check([0xE2, 0x82, 0xAC], "€");
        check([0xF0, 0xA3, 0x8F, 0xA6], "𣏦");
        check([0xF0, 0x9F, 0x98, 0x81], "😁");
    },
);
