# Move Prover Examples

Extremely simple examples of Move program specifications. The `basic/` examples
cover `assert`, `assume`, `aborts_if`, and `ensures` for pure functions; the
examples in `invariants/` look at global invariants, loop invariants, and
global state.

# Setup

- Install `move-cli`:

```sh
cargo install --git https://github.com/move-language/move move-cli
```

- Install the Boogie verifier. This can be done with your preferred package
  manager or with the [dev setup script][1].
- Install [z3][2].

[1]: https://github.com/move-language/move/blob/main/scripts/dev_setup.sh
[2]: https://github.com/Z3Prover/z3

# Usage

Run the prover in each Move project with `move prove --path [project]`. The
paths to the `z3` and `boogie` executables must be in the `Z3_EXE` and
`BOOGIE_EXE` environment variables, respectively.
