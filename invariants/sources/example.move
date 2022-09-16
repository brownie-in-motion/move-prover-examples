// specs can sit outside of the module too
spec 0x2::Example {
    spec Account {
        // implicit because Move does not have signed integers
        invariant balance >= 0;
    }
}

module 0x2::Example {
    const MAX_BALANCE: u64 = 1023;

    struct Account has key {
        balance: u64
    }


    fun withdraw(account: address, amount: u64) acquires Account {
        let reference = borrow_global_mut<Account>(account);
        reference.balance = reference.balance - amount;
    }

    fun deposit(account: address, amount: u64) acquires Account {
        let reference = borrow_global_mut<Account>(account);

        let new_balance = reference.balance + amount;
        assert!(new_balance <= MAX_BALANCE, 0);

        reference.balance = new_balance;
    }

    public fun transfer(
        signer: signer,
        to: address,
        amount: u64
    ) acquires Account {
        let from = std::signer::address_of(&signer);

        assert!(from != to, 0);

        withdraw(from, amount);
        deposit(to, amount);
    }

    // we can define a helper function for use only in specifications
    spec fun balance(addr: address): u64 {
        global<Account>(addr).balance
    }

    // checks that transfer occurs properly
    spec transfer {
        let from = std::signer::address_of(signer);
        ensures balance(from) == old(balance(from)) - amount;
        ensures balance(to) == old(balance(to)) + amount;
    }

    // global invariant for the module. asserts that the balance of no Account
    // resource can ever be above MAX_BALANCE.
    invariant forall addr: address where exists<Account>(addr):
        balance(addr) <= MAX_BALANCE;

    public fun counter(start: u64): u64 {
        let i = if (start > 50) { 0 } else { start };

        while ({
            // the move prover deals with loops by literally doing induction.
            // this loop invariant is required for it to prove the assertion
            // that `counter` returns 50. the prover is unable to infer loop
            // invariants, and will return a verification error if this is not
            // written.
            spec {
                invariant i <= 50;
            };

            (i < 50)
        }) {
            i = i + 1;
        };

        i
    }

    spec counter {
        ensures result == 50;
    }
}
