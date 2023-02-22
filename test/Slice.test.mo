import TextX "../src/TextX";
import Slice "../src/Slice";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import { test } "mo:test";

func check(expected : Text, actual : ?Text) {
    if (?expected != actual) {
        Debug.trap("Failed to match slice. Actual: " #debug_show (actual) # ", Expected: " #debug_show (expected));

    };
};

test(
    "Slice matching trimmed",
    func() {
        let matchInfo : TextX.SliceMatchInfo = {
            startsWith = #text("<!--");
            endsWith = #text("-->");
            trimMatch = true;
            strictStart = false;
        };
        let v = do ? {
            TextX.slice(#text("a<!-- -<>- -->z"), 0, null).tryMatchSlice(matchInfo)!.toText();
        };
        let expected = " -<>- ";
        check(expected, v);
    },
);

test(
    "Slice matching not trimmed",
    func() {
        let matchInfo : TextX.SliceMatchInfo = {
            startsWith = #text("<!--");
            endsWith = #text("-->");
            trimMatch = false;
            strictStart = false;
        };
        let v = do ? {
            TextX.slice(#text("a<!-- -<>- -->z"), 0, null).tryMatchSlice(matchInfo)!.toText();
        };
        let expected = "<!-- -<>- -->";
        check(expected, v);
    },
);

test(
    "Slice multi matching strict start",
    func() {
        let cases : [TextX.MappedSliceMatchInfo<Text>] = [
            {
                startsWith = #text("<!--");
                endsWith = #text("-->");
                trimMatch = false;
                strictStart = true;
                map = func(slice : TextX.TextSlice) : Text {
                    "Comment";
                };
            },
            {
                startsWith = #text("<?");
                endsWith = #text("?>");
                trimMatch = false;
                strictStart = true;
                map = func(slice : TextX.TextSlice) : Text {
                    "Q";
                };
            },
        ];
        let catchAllCase : TextX.MapSlice<Text> = func(slice : TextX.TextSlice) : Text {
            "Catch all";
        };
        let v = do ? {
            TextX.slice(#text("<!-- -<>- -->"), 0, null).matchAndMapSlice<Text>(cases, catchAllCase);
        };
        check("Comment", v);

        let v2 = do ? {
            TextX.slice(#text("<??>"), 0, null).matchAndMapSlice<Text>(cases, catchAllCase);
        };
        check("Q", v2);

        let v3 = do ? {
            TextX.slice(#text("asdffgvcg"), 0, null).matchAndMapSlice<Text>(cases, catchAllCase);
        };
        check("Catch all", v3);
    },
);
