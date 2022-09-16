module 0x2::Example {
    fun increment(number: u64): u64 {
        number + 1
    }

    spec increment {
        // aborting on bad arithmetic already happens at runtime. this statement
        // only indicates the behavior. it would be necessary with the pragma
        // `aborts_if_is_strict`.
        aborts_if number + 1 > MAX_U64;

        // result refers to the return value of the function
        ensures result == number + 1;
    }

    fun sum(first: u64, second: u64): u64 {
        let total = first + second;

        first = 0;
        second = 0;

        // prevent warnings about unused code lol
        _ = first + second;

        spec {
            // for inline specs, variables refer to the current context.
            // only assume and assert are allowed.
            assert first == 0;
            assert second == 0;
        };

        total
    }

    spec sum {
        // tell the prover about preconditions. specifically, that sum is never
        // called with huge `first` or `second`. if we ever call `sum` with
        // values that can be too big, the prover will yell at us. if `sum` is
        // an entrypoint, having this assertion would not make sense.
        requires first < MAX_U64 / 2;
        requires second < MAX_U64 / 2;

        // with our assertions about preconditions, this asserts that the
        // function will never abort. `first + second` will never overflow.
        aborts_if false;

        // `first` and `second` are their original values as arguments. specs
        // can't really refer to intermediate values or states, unless about
        // references
        ensures result == first + second;

    }

    fun replace(number: &mut u64) {
        *number = *number % 5 + 1;
    }

    spec replace {
        // this will never abort!
        aborts_if false;

        // we can assert against values at the function entrypoint with `old`.
        // since number is a reference, it refers here to the final value.
        ensures number != old(number);
    }
}
