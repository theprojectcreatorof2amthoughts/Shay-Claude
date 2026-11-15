# Using Shay with Claude Code

This guide helps Claude Code work accurately in a Shay repository. It complements the root `CLAUDE.md`, which Claude Code reads automatically when a session starts in the repository.

## 1. Start a session

Open the Shay repository as the working directory and start Claude Code:

```sh
claude
```

Claude Code should load the repository's root `CLAUDE.md`. In a session, use `/memory` or `/context` to check which project instruction files were loaded.

For a first exploration, ask Claude:

> Read CLAUDE.md, docs/SYNTAX.md, and docs/CAPABILITY_SPEC.md. Then inspect the lexer, parser, interpreter, compiler, and tests. Summarize what Shay implements today, separating implemented behavior from roadmap goals. Do not edit files yet.

## 2. Shay at a glance

| Item | Meaning |
|---|---|
| `gshai` | Native compiler |
| `shaii` | Interpreter |
| `.shay` | Program source |
| `.shaii` | Library source |
| `.shaz` | Zeccur task source |
| `.sho` | Native relocatable object |

The compiler currently translates the supported Shay subset to generated C++ and invokes the host C++ compiler/linker. Do not describe this as a direct machine-code backend.

## 3. Current syntax examples

### Output and variables

```shay
instxt-"Hello from Shay!"
brew language = "Shay"
brew answer = 42
insval-language
insval-answer
```

`brew` currently accepts string, numeric, and boolean literals. String escapes include `\\n`, `\\t`, `\\r`, `\\\\`, and `\\"`. Comments begin with `##`.

### Numeric-returning functions

```shay
$declr add(x, y)
    forw x + y
finish

insval-add(10, 20)
```

`forw` requires a numeric expression. The current expression evaluator supports numeric literals, parameter/variable names, parentheses, unary signs, and `+`, `-`, `*`, `/`. Division by zero is diagnosed by the interpreter.

### Void functions with statements

```shay
$declr compare(x, y)
    ifit x > y
        instxt-"The first value is bigger"
    exec
finish

insval-compare(7, 6)
```

A void function contains statements and closes with `finish`; it does not use `forw`. Supported function-body statements currently include text output, value output, function calls, and `ifit` blocks. Keep examples within the implemented subset.

### Conditions

```shay
brew first = 20
brew second = 10

ifit first > second
    instxt-"first is greater"
exec
```

Supported comparisons: `>`, `<`, `>=`, `<=`, `==`, and `!=`. The current expression/condition implementation is numeric; do not imply arbitrary string or boolean condition evaluation.

## 4. Imports and file types

```shay
$shaiiport [math.shaii]
$shaiiport "external/custom.shaii"
$shazport [startup.shaz]
```

- Bracketed `$shaiiport [name.shaii]` is the implemented-library form. It searches beside the importer, then `SHAY_STDLIB`, then project `siil/` directories.
- Quoted `$shaiiport "path/name.shaii"` is an explicit external disk path, relative to the importer or absolute. It does not fall back to `siil/`.
- `$shazport [name.shaz]` imports a Zeccur task relative to the importer.
- `.shay` and `.shaz` can import `.shaii` and `.shaz`.
- `.shaii` can import `.shaz`, but cannot import another `.shaii`.
- Duplicate imports load once; circular imports are errors.
- Zeccurs files are variable-free: `brew` is rejected in `.shaz`.

The bundled `siil/` directory currently provides constants and reusable text values. Check `siil/README.md` for its current modules; do not assume it contains APIs that are not listed there.

## 5. Build, run, and compile

Build both programs:

```sh
make
```

Interpret and syntax-check:

```sh
./build/shaii examples/hello.shay
./build/shaii --check examples/hello.shay
```

Compile a standalone executable:

```sh
./build/gshai -o hello examples/hello.shay
./hello
```

Emit a native object:

```sh
./build/gshai -ob hello.sho examples/hello.shay
```

The object exports `shay_program_entry`; see the tests for a host-link example.

Native compiler flags:

- `--shaywall` enables `-Wall`.
- `--shaywextra` enables `-Wextra`.
- `--shayo0`, `--shayo1`, `--shayo2`, `--shayo3` select optimization levels.

The same flags can be used with `gshai` before or after the output mode and source path.

## 6. Working on the language

When asked to add a feature, Claude should:

1. State whether the request is already supported, partially supported, or new.
2. Trace the feature through lexer/tokenization, parser/AST, interpreter, compiler/code generation, diagnostics, and tests.
3. Propose syntax changes before implementing a new keyword or grammar form.
4. Keep interpreter and compiler semantics consistent.
5. Add regression coverage for both successful behavior and invalid input.
6. Update `docs/SYNTAX.md` and examples. If a capability is only planned, put it in `docs/CAPABILITY_SPEC.md`, not among current syntax features.
7. Run the relevant checks and report their actual results.

A useful implementation prompt:

> Implement [feature] in Shay. First inspect the current grammar and explain the smallest syntax/design change. Then update the lexer/parser/AST, interpreter, compiler, diagnostics, and regression tests as needed. Keep the two execution paths consistent. Update the current syntax documentation, run the relevant test suite, and summarize changed files and test results. Do not add unrelated features.

## 7. Important non-goals and cautions

The current implementation is a growing bootstrap, not a complete general-purpose language yet. Do not invent or promise loops, arrays, general assignment, nested function calls in expressions, closures, string-returning functions, exception handling, or a REPL unless the source code and tests have since implemented them.

Treat `docs/CAPABILITY_SPEC.md` as a roadmap, not a list of available features. When documentation conflicts with code, inspect the implementation and tests, then correct the documentation rather than guessing.
