---
name: shay
description: Write, explain, debug, test, and compile programs in the Shay programming language using gshai and shaii.
---

# Shay language workflow

Use this skill whenever the user is working with Shay source files (`.shay`), Shay libraries (`.shaii`), Zeccur task files (`.shaz`), or compiled Shay object files (`.sho`).

## Toolchain

- `shaii` interprets Shay source and supports syntax checking.
- `gshai` compiles Shay source to native executables or relocatable `.sho` object files.
- `siil/` contains Shay's standard library.
- `SHAY_STDLIB` should point to the installed `siil` directory when using installed standard-library modules.

Before assuming a command or feature exists, inspect `gshai --help`, `shaii --help`, or the project's own documentation. Do not invent flags or syntax.

## Safe development loop

1. Read the relevant source and nearby examples before editing.
2. Preserve Shay syntax and vocabulary; do not silently translate a requested Shay program into JavaScript, Python, C, or another language.
3. Check syntax with `shaii --check path/to/program.shay`.
4. Run it with `shaii path/to/program.shay` when execution is requested and safe.
5. Compile with `gshai -o output path/to/program.shay` for an executable, or `gshai -ob path/to/program.shay` for a `.sho` object.
6. For compiler or interpreter changes in a Shay checkout, run `make test`.

## Language conventions

Shay has its own grammar. Examples of established syntax include:

```shay
instxt-"Hello, world!"
brew username = "Alex"
insval-username
```

Imports use forms such as:

```shay
$shaiiport [math.shaii]
$shaiiport "external/custom.shaii"
$shazport [startup.shaz]
```

Do not assume that familiar syntax from other languages (such as `let`, braces, semicolons, or JavaScript-style functions) is valid Shay syntax. Confirm supported constructs from the installed compiler/interpreter and current Shay documentation.

## Compatibility discipline

Shay evolves independently. Prefer the installed toolchain's actual behavior over assumptions based on other language ecosystems. If a feature is unsupported, say so clearly and offer a working alternative rather than fabricating syntax. When debugging, preserve the exact compiler/interpreter error and fix the smallest relevant issue first.
