import CharX "../src/CharX";
import { test } "mo:test";

test(
    "toUpper",
    func() {
        // Basic Latin (ASCII) tests
        assert (CharX.toUpper('a') == 'A');
        assert (CharX.toUpper('b') == 'B');
        assert (CharX.toUpper('z') == 'Z');
        assert (CharX.toUpper('A') == 'A'); // Already uppercase
        assert (CharX.toUpper('0') == '0'); // Non-alphabetic
        assert (CharX.toUpper(' ') == ' '); // Whitespace
        assert (CharX.toUpper('!') == '!'); // Symbol

        // Latin-1 Supplement tests
        assert (CharX.toUpper('à') == 'À');
        assert (CharX.toUpper('é') == 'É');
        assert (CharX.toUpper('ç') == 'Ç');
        assert (CharX.toUpper('ü') == 'Ü');
        assert (CharX.toUpper('À') == 'À'); // Already uppercase
        assert (CharX.toUpper('Þ') == 'Þ'); // Already uppercase

        // Latin Extended-A tests
        assert (CharX.toUpper('ā') == 'Ā');
        assert (CharX.toUpper('ĉ') == 'Ĉ');
        assert (CharX.toUpper('ė') == 'Ė');
        assert (CharX.toUpper('į') == 'Į');
        assert (CharX.toUpper('œ') == 'Œ');
        assert (CharX.toUpper('ƣ') == 'Ƣ');
        assert (CharX.toUpper('ư') == 'Ư');
        assert (CharX.toUpper('ŵ') == 'Ŵ');
        assert (CharX.toUpper('ŷ') == 'Ŷ');
        assert (CharX.toUpper('ȳ') == 'Ȳ');
        assert (CharX.toUpper('Ā') == 'Ā'); // Already uppercase
        assert (CharX.toUpper('Œ') == 'Œ'); // Already uppercase
        assert (CharX.toUpper('Ƣ') == 'Ƣ'); // Already uppercase
        assert (CharX.toUpper('Ȳ') == 'Ȳ'); // Already uppercase

        // German Eszett test
        assert (CharX.toUpper('ß') == 'ẞ');
        assert (CharX.toUpper('ẞ') == 'ẞ'); // Already uppercase

    },
);

test(
    "toLower",
    func() {
        // Basic Latin (ASCII) tests
        assert (CharX.toLower('A') == 'a');
        assert (CharX.toLower('B') == 'b');
        assert (CharX.toLower('Z') == 'z');
        assert (CharX.toLower('a') == 'a'); // Already lowercase
        assert (CharX.toLower('0') == '0'); // Non-alphabetic
        assert (CharX.toLower(' ') == ' '); // Whitespace
        assert (CharX.toLower('!') == '!'); // Symbol

        // Latin-1 Supplement tests
        assert (CharX.toLower('À') == 'à');
        assert (CharX.toLower('É') == 'é');
        assert (CharX.toLower('Ç') == 'ç');
        assert (CharX.toLower('Ü') == 'ü');
        assert (CharX.toLower('à') == 'à'); // Already lowercase
        assert (CharX.toLower('þ') == 'þ'); // Already lowercase

        // Latin Extended-A tests
        assert (CharX.toLower('Ā') == 'ā');
        assert (CharX.toLower('Ĉ') == 'ĉ');
        assert (CharX.toLower('Ė') == 'ė');
        assert (CharX.toLower('Į') == 'į');
        assert (CharX.toLower('Œ') == 'œ');
        assert (CharX.toLower('Ƣ') == 'ƣ');
        assert (CharX.toLower('Ư') == 'ư');
        assert (CharX.toLower('Ŵ') == 'ŵ');
        assert (CharX.toLower('Ŷ') == 'ŷ');
        assert (CharX.toLower('Ȳ') == 'ȳ');
        assert (CharX.toLower('ā') == 'ā'); // Already lowercase
        assert (CharX.toLower('œ') == 'œ'); // Already lowercase
        assert (CharX.toLower('ƣ') == 'ƣ'); // Already lowercase
        assert (CharX.toLower('ȳ') == 'ȳ'); // Already lowercase

        // German Eszett test
        assert (CharX.toLower('ẞ') == 'ß');
        assert (CharX.toLower('ß') == 'ß'); // Already lowercase
    },
);
