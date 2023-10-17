# Overview

A general Text library for Motoko

# Modules

## CharX

    toLower(char : Char) : Char

    toUpper(char : Char) : Char

## TextX

    toLower(text : Text) : Text

    toUpper(text : Text) : Text

    slice(text : Text, startIndex : Nat, length : Nat) : Text

    sliceToEnd(text : Text, startIndex : Nat) : Text

    fromUtf8Bytes(bytes : Iter.Iter<Nat8>) : Iter.Iter<Char>

    toUtf8Bytes(characters : Iter.Iter<Char>) : Iter.Iter<Nat8>

    isEmpty(text : Text) : Bool

    isEmptyOrWhitespace(text : Text) : Bool
