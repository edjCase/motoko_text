import TextX "../src/TextX";
import Slice "../src/Slice";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import { test } "mo:test";

test(
    "Comment slicing",
    func() {
        let v = TextX.slice(#text("<!-- -<>- -->"), 0, null).match(
            [
                #prefix({
                    value = #text("<!--");
                    onMatch = #strip;
                }),
            ],
            func(slice : TextX.TextSlice) {
                slice;
            },
        ).toText();
        Debug.print(v);
        assert v == " -<>- -->";
    },
);
