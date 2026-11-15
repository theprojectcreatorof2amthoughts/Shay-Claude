# Claude Code instructions for Shay

## Project identity

Shay is its own programming language. Do not treat it as a dialect, alias, or wrapper for another language. Preserve its vocabulary, grammar, file extensions, and tool names.

- `gshai` is the compiler.
- `shaii` is the interpreter.
- `.shay` is a Shay program.
- `.shaii` is a reusable Shay library.
- `.shaz` is a Zeccur task file.
- `.sho` is a native relocatable object emitted by the compiler's `-ob` mode.

Read `docs/SYNTAX.md` and `docs/CAPABILITY_SPEC.md` before changing language behavior. The syntax guide describes the current implementation; the capability specification describes goals and must not be mistaken for implemented features.

## Important language rules

- Variable declarations use `brew name = literal`.
- Text output uses `instxt-"text"`.
- Variable/function output uses `insval-name` or `insval-function(args)`.
- Functions start with `$declr name(parameters)` and end with `finish`.
- A numeric-returning function has a `forw expression` body. `forw` always requires an expression.
- A void function has statement bodies and does not use `forw`.
- Conditionals use `ifit comparison` and close with `exec`.
- Comments start with `##`.
- Zeccurs (`.shaz`) files are variable-free; do not add `brew` declarations to them.
- A `.shaii` file may import `.shaz`, but may not import another `.shaii` file.
- Do not invent syntax such as `insvar`, `enddeclr`, `else`, loops, assignment, or string-returning functions. Check the parser before proposing syntax.

## Imports

- `$shaiiport [name.shaii]` imports a library, searching beside the importer, then `SHAY_STDLIB`, then project `siil/` directories.
- `$shaiiport "path/to/name.shaii"` explicitly imports a disk file relative to the importer (or by absolute path); it does not fall back to `siil/`.
- `$shazport [name.shaz]` imports a Zeccur task relative to the importer.
- Duplicate imports load once and circular imports are diagnosed.

## Toolchain and development

Requirements: C11 and C++20 compilers, GNU Make; CMake 3.20+ is also supported.

- `make` builds `build/gshai` and `build/shaii`.
- `make test` builds and runs the regression suite.
- `make clean` removes generated build output.
- `cmake -S . -B build-cmake && cmake --build build-cmake --parallel` builds with CMake.
- `ctest --test-dir build-cmake --output-on-failure` runs the CMake test suite.
- `build/shaii --check path/to/program.shay` checks source without executing output.
- `build/shaii path/to/program.shay` interprets source.
- `build/gshai -o output-name path/to/program.shay` creates a standalone executable.
- `build/gshai -ob output-name.sho path/to/program.shay` creates a `.sho` object.
- Compiler flags include `--shaywall`, `--shaywextra`, and `--shayo0` through `--shayo3`.

Use the existing Makefile, CMake configuration, and tests as the source of truth for commands. Do not claim a test passed unless you actually ran it or CI reports success.

## Change discipline

1. Inspect the relevant lexer, parser, AST, interpreter, compiler, imports, tests, and docs before editing.
2. Keep compiler and interpreter behavior aligned. A syntax feature is incomplete if only one accepts or executes it.
3. Add or update regression tests for behavior changes and diagnostics.
4. Keep documentation explicit about what is implemented versus planned.
5. Avoid unrelated refactors, generated umbrella headers, and unnecessary dependencies.
6. Never silently change existing syntax or file-format meanings. Propose breaking language changes separately.
7. Prefer small, reviewable changes with clear commit messages.
8. Do not merge pull requests or push directly to `main`; use a feature branch and pull request.

## Documentation map

- `docs/SYNTAX.md`: current grammar and syntax examples.
- `docs/CAPABILITY_SPEC.md`: longer-term language goals and design policy.
- `siil/README.md`: bundled standard-library modules.
- `README.md`: project overview and toolchain usage.
- `tests/run.sh`: executable regression suite.
