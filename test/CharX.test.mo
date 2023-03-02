import CharX "../src/CharX";
import { test } "mo:test";

test(
    "toUpper",
    func() {
        assert (CharX.toUpper('a') == 'A');
        assert (CharX.toUpper('b') == 'B');
        assert (CharX.toUpper('c') == 'C');
        assert (CharX.toUpper('d') == 'D');
        assert (CharX.toUpper('e') == 'E');
        assert (CharX.toUpper('f') == 'F');
        assert (CharX.toUpper('g') == 'G');
        assert (CharX.toUpper('h') == 'H');
        assert (CharX.toUpper('i') == 'I');
        assert (CharX.toUpper('j') == 'J');
        assert (CharX.toUpper('k') == 'K');
        assert (CharX.toUpper('l') == 'L');
        assert (CharX.toUpper('m') == 'M');
        assert (CharX.toUpper('n') == 'N');
        assert (CharX.toUpper('o') == 'O');
        assert (CharX.toUpper('p') == 'P');
        assert (CharX.toUpper('q') == 'Q');
        assert (CharX.toUpper('r') == 'R');
        assert (CharX.toUpper('s') == 'S');
        assert (CharX.toUpper('t') == 'T');
        assert (CharX.toUpper('u') == 'U');
        assert (CharX.toUpper('v') == 'V');
        assert (CharX.toUpper('w') == 'W');
        assert (CharX.toUpper('x') == 'X');
        assert (CharX.toUpper('y') == 'Y');
        assert (CharX.toUpper('z') == 'Z');
        assert (CharX.toUpper('A') == 'A');
        assert (CharX.toUpper('Z') == 'Z');
        assert (CharX.toUpper('0') == '0');
        assert (CharX.toUpper('9') == '9');
        assert (CharX.toUpper(' ') == ' ');
        assert (CharX.toUpper('!') == '!');
    },
);

test(
    "toLower",
    func() {
        assert (CharX.toLower('A') == 'a');
        assert (CharX.toLower('B') == 'b');
        assert (CharX.toLower('C') == 'c');
        assert (CharX.toLower('D') == 'd');
        assert (CharX.toLower('E') == 'e');
        assert (CharX.toLower('F') == 'f');
        assert (CharX.toLower('G') == 'g');
        assert (CharX.toLower('H') == 'h');
        assert (CharX.toLower('I') == 'i');
        assert (CharX.toLower('J') == 'j');
        assert (CharX.toLower('K') == 'k');
        assert (CharX.toLower('L') == 'l');
        assert (CharX.toLower('M') == 'm');
        assert (CharX.toLower('N') == 'n');
        assert (CharX.toLower('O') == 'o');
        assert (CharX.toLower('P') == 'p');
        assert (CharX.toLower('Q') == 'q');
        assert (CharX.toLower('R') == 'r');
        assert (CharX.toLower('S') == 's');
        assert (CharX.toLower('T') == 't');
        assert (CharX.toLower('U') == 'u');
        assert (CharX.toLower('V') == 'v');
        assert (CharX.toLower('W') == 'w');
        assert (CharX.toLower('X') == 'x');
        assert (CharX.toLower('Y') == 'y');
        assert (CharX.toLower('Z') == 'z');
        assert (CharX.toLower('a') == 'a');
        assert (CharX.toLower('z') == 'z');
        assert (CharX.toLower('0') == '0');
        assert (CharX.toLower('9') == '9');
        assert (CharX.toLower(' ') == ' ');
        assert (CharX.toLower('!') == '!');
    },
);
