# TextX: Advanced Text Manipulation for Motoko

TextX is a text manipulation library for Motoko

## Installation

```bash
mops install xtended-text
```

To setup MOPS package manage, follow the instructions from the
[MOPS Site](https://j4mwm-bqaaa-aaaam-qajbq-cai.ic0.app/)

## Quick Start

Here's a quick example to get you started:

```motoko
import TextX "mo:xtended-text/TextX";

let text = "Hello, World!";
let lowercased = TextX.toLower(text);
assert(lowercased == "hello, world!");

let sliced = TextX.slice(text, 7, 5);
assert(sliced == "World");

let isEmpty = TextX.isEmpty("");
assert(isEmpty);
```

## Modules

### CharX

Provides character-level operations:

- `toLower(char : Char) : Char`: Converts a character to lowercase.
- `toUpper(char : Char) : Char`: Converts a character to uppercase.

### TextX

Offers a wide range of text manipulation functions:

- `toLower(text : Text) : Text`: Converts all characters in the text to
  lowercase.
- `toUpper(text : Text) : Text`: Converts all characters in the text to
  uppercase.
- `slice(text : Text, startIndex : Nat, length : Nat) : Text`: Extracts a
  substring from the given text.
- `sliceToEnd(text : Text, startIndex : Nat) : Text`: Extracts a substring from
  the given index to the end of the text.
- `fromUtf8Bytes(bytes : Iter.Iter<Nat8>) : Iter.Iter<Char>`: Converts UTF-8
  bytes to characters.
- `toUtf8Bytes(characters : Iter.Iter<Char>) : Iter.Iter<Nat8>`: Converts
  characters to UTF-8 bytes.
- `isEmpty(text : Text) : Bool`: Checks if the text is empty.
- `isEmptyOrWhitespace(text : Text) : Bool`: Checks if the text is empty or
  contains only whitespace.

# Testing

```
mops test
```
