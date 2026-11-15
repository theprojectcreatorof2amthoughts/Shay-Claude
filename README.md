# Shay-Claude

Shay-Claude connects Claude Code to the **Shay programming language**. It provides Claude-specific instructions and a small installer for the official Shay toolchain.

**This is not a compiler fork.** The canonical compiler, interpreter, runtime, and standard library remain in [the Shay repository](https://github.com/theprojectcreatorof2amthoughts/Shay). This repository pins an upstream Shay commit and can update that pin through reviewed pull requests.

## What it provides

- A Claude Code skill for writing, checking, running, and compiling Shay programs.
- Project-level Claude Code guidance in `CLAUDE.md`.
- An installer that downloads the pinned Shay source, builds it, runs its regression tests, and installs `gshai`, `shaii`, and `siil`.
- A daily GitHub Actions check that opens a pull request when Shay's `main` branch advances.

## Install

Requirements: Git, GNU Make, a C11 compiler, a C++20 compiler, `curl` or `wget`, and `tar`.

Clone this repository and run the installer:

```sh
git clone https://github.com/theprojectcreatorof2amthoughts/Shay-Claude.git
cd Shay-Claude
./install.sh
```

The default install prefix is `$HOME/.local`. Add its binary directory to your PATH if it is not already there:

```sh
export PATH="$HOME/.local/bin:$PATH"
export SHAY_STDLIB="$HOME/.local/share/shay/siil"
```

Then start Claude Code from that terminal so it inherits the Shay environment.

### Windows

Use an MSYS2 environment with a C/C++ toolchain, GNU Make, Git, curl, and tar. Run the commands above from the MSYS2 terminal. The installer does not require administrator privileges.

## Update Shay

From this repository, run:

```sh
./update.sh
```

This rebuilds the exact revision pinned in `toolchain.lock`. To test a different upstream branch, tag, or commit without changing the lock file:

```sh
SHAY_REF=main ./install.sh
```

## How synchronization works

1. `toolchain.lock` records the exact Shay commit used by this integration.
2. A scheduled GitHub Actions workflow checks the canonical Shay `main` branch.
3. When the upstream commit changes, the workflow opens a pull request updating the pin.
4. Shay-Claude CI downloads that exact revision, builds it, and runs Shay's regression suite.
5. A maintainer reviews and merges the update. The toolchain never changes silently underneath a pinned install.

The sync workflow only proposes updates; it does not merge its own pull requests.

## Claude Code integration

The `shay` skill is in `.claude/skills/shay/SKILL.md`. It teaches Claude Code to use the real Shay tools, check source before execution, preserve Shay syntax, and avoid inventing unsupported language features.

## Project boundaries

- **Shay** owns language design, compiler, interpreter, runtime, standard library, and language-level tests.
- **Shay-Claude** owns Claude Code instructions, skills, setup, and integration-specific tests/workflows.

Fixes to the language itself should be made upstream in Shay, not duplicated here.
