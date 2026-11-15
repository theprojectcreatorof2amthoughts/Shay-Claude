# Shay-Claude instructions

This repository integrates Claude Code with the Shay programming language. It is **not** the Shay compiler repository and must not become a second copy of the language implementation.

## Source of truth

The canonical compiler, interpreter, C11 runtime, and `siil/` standard library live in:

https://github.com/theprojectcreatorof2amthoughts/Shay

The exact upstream revision used by this package is recorded in `toolchain.lock`.

- Run `./install.sh` to install the pinned toolchain.
- Run `./update.sh` to reinstall/update to the revision currently pinned in the lock file.
- Set `SHAY_REF` for a one-off test of another upstream branch, tag, or commit.
- Set `SHAY_PREFIX` to install somewhere other than `$HOME/.local`.

The installer builds Shay and runs its upstream regression tests before installing it.

## Claude Code integration

- Keep Shay-specific authoring guidance in `.claude/skills/shay/SKILL.md`.
- Keep project-wide Claude Code guidance here.
- Use the actual installed `gshai` and `shaii` binaries; do not emulate their behavior.
- Do not claim a syntax feature is supported without checking the pinned upstream toolchain or canonical Shay documentation.
- Preserve Shay's own vocabulary, grammar, and file extensions.
- Never translate a Shay request into another language unless the user explicitly asks.

## Repository boundaries

This repository may contain Claude Code skills, instructions, installation/update scripts, compatibility checks, and integration workflows.

Do **not** copy or independently maintain:
- `gshai` compiler source,
- `shaii` interpreter source,
- the Shay runtime,
- the Shay standard library,
- language-level parser or lexer implementations.

Language bugs and feature requests belong in the canonical Shay repository. Keep changes here focused on Claude integration and toolchain distribution.

## Verification

- Check shell scripts with `sh -n`.
- Run `./install.sh` to verify the pinned upstream toolchain can build, pass its regression tests, and install.
- Do not claim tests passed unless they were actually run or CI reports success.
- Keep updates reviewable: the scheduled sync workflow opens a pull request and never merges it automatically.
