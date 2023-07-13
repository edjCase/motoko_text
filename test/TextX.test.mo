import TextX "../src/TextX";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import { test } "mo:test";
import Array "mo:base/Array";

func assertText(actual : Text, expected : Text) {
    if (actual != expected) {
        Debug.trap("expected: '" # expected # "', actual: '" # actual # "'");
    };
};

test(
    "toUpper",
    func() {
        assertText(TextX.toUpper("abcdefghijklmnopqrstuvwxyz0123456789!"), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!");
        assertText(TextX.toUpper("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!");
    },
);

test(
    "toLower",
    func() {
        assertText(TextX.toLower("abcdefghijklmnopqrstuvwxyz0123456789!"), "abcdefghijklmnopqrstuvwxyz0123456789!");
        assertText(TextX.toLower("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"), "abcdefghijklmnopqrstuvwxyz0123456789!");
    },
);

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
