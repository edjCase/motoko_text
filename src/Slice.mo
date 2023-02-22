import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
module Slice {

    public type Sequence<T> = {
        #array : [T];
        #buffer : Buffer.Buffer<T>;
        #slice : Slice<T>;
    };

    public type OnMatch<T> = Slice<T> -> Slice<T>;

    public type SliceMatchInfo<T> = {
        startsWith : Sequence<T>;
        endsWith : Sequence<T>;
        trimMatch : Bool;
        strictStart : Bool;
    };

    public class Slice<T>(
        sequence : Sequence<T>,
        comparer : (T, T) -> Bool,
        sliceOffset : Nat,
        sliceLength : ?Nat,
    ) : Slice<T> = sliceRef {

        private func getSequenceSize(sequence : Sequence<T>) : Nat {
            switch (sequence) {
                case (#array(a)) a.size();
                case (#buffer(b)) b.size();
                case (#slice(s)) s.size();
            };
        };
        let sequenceSize : Nat = getSequenceSize(sequence);
        let calculatedSliceLength : Nat = switch (sliceLength) {
            // If no sliceLength specified, stop at end of chars
            case (null) {
                if (sliceOffset >= sequenceSize) {
                    Debug.trap("Start index must be less than the sliceLength of the sequence");
                };
                sequenceSize - sliceOffset;
            };
            case (?l) {
                if (sliceOffset + l > sequenceSize) {
                    // print all the variables
                    Debug.print("sliceOffset: " # debug_show sliceOffset # " sliceLength: " # debug_show l # " sequenceSize: " # debug_show sequenceSize);
                    Debug.trap("Start index + sliceLength must be less than the sliceLength of the sequence");
                };
                l;
            };
        };

        public func slice(offset : Nat, length : ?Nat) : Slice<T> {
            Slice<T>(sequence, comparer, sliceOffset + offset, length);
        };

        public func get(index : Nat) : T {
            getFromSequence(sequence, sliceOffset + index);
        };

        public func size() : Nat {
            calculatedSliceLength;
        };

        public func indexOf(subset : Sequence<T>) : ?Nat {
            indexOfInternal(subset, false);
        };

        public func indexOfInternal(subset : Sequence<T>, onlyStartsWith : Bool) : ?Nat {
            let subsetSize = getSequenceSize(subset);
            if (subsetSize > calculatedSliceLength) {
                return null;
            };
            // Create a loop that iterates through the slice, excluding the last x characters where x is the sequence size
            label f1 for (sliceIndex in Iter.range(0, calculatedSliceLength - subsetSize)) {
                // Check if the slice at the current index matches the sequence
                label f2 for (subsetIndex in Iter.range(0, subsetSize - 1)) {
                    let subsetValue = getFromSequence(subset, subsetIndex);
                    let sliceValue = get(sliceIndex + subsetIndex);
                    if (not comparer(sliceValue, subsetValue)) {
                        if (onlyStartsWith) {
                            // If only startswith, then fail on the first check
                            return null;
                        };
                        // If not matched, continue to next index
                        continue f1;
                    };
                };
                // If fully matched, return the index
                return ?sliceIndex;
            };
            return null;
        };

        public func tryMatchSlice(matchInfo : SliceMatchInfo<T>) : ?Slice<T> {
            do ? {
                // Get index where prefix starts
                let prefixStartIndex : Nat = indexOfInternal(matchInfo.startsWith, matchInfo.strictStart)!;

                // Get prefix slice
                let prefixSlice = slice(prefixStartIndex, null);

                // Get index where suffix starts
                let suffixStartIndex : Nat = prefixSlice.indexOf(matchInfo.endsWith)!;

                let suffixLength : Nat = getSequenceSize(matchInfo.endsWith);
                let (sliceOffset : Nat, sliceLength : Nat) = if (matchInfo.trimMatch) {
                    // prefix and suffix NOT included
                    let prefixLength : Nat = getSequenceSize(matchInfo.startsWith);
                    let sliceLength : Nat = suffixStartIndex - prefixStartIndex - prefixLength + 1;
                    (prefixStartIndex + prefixLength, sliceLength);
                } else {
                    // prefix and suffix included
                    (prefixStartIndex, suffixStartIndex + suffixLength);
                };

                slice(sliceOffset, ?sliceLength);
            };
        };

        public func toIter() : Iter.Iter<T> {
            switch (sequence) {
                case (#array(a)) toIterInternal(a.size(), func(i) = a[i]);
                case (#buffer(b)) toIterInternal(b.size(), func(i) = b.get(i));
                case (#slice(s)) s.toIter();
            };
        };

        private func getFromSequence(sequence : Sequence<T>, index : Nat) : T {
            switch (sequence) {
                case (#array(a)) a[index];
                case (#buffer(b)) b.get(index);
                case (#slice(s)) s.get(index);
            };
        };

        private func toIterInternal(size : Nat, getValue : Nat -> T) : Iter.Iter<T> {
            var iterLength = 0;
            // Create a new iter object to iterate through the slice
            {
                next = func() : ?T {

                    switch (sliceLength) {
                        case (null) {
                            if (iterLength + sliceOffset >= size) {
                                // If reached the end of array, return null
                                return null;
                            };
                        };
                        case (?l) {
                            if (iterLength >= l) {
                                // If reached the end of sliceLength, return null
                                return null;
                            };
                        };
                    };
                    let value = getValue(iterLength + sliceOffset);
                    iterLength += 1;
                    ?value;
                };
            };
        };

    };
};
