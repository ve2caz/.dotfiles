# ZSH Shell Primer

In `zsh`, shells are categorized along two independent axes: whether they are a **login** shell and whether they are **interactive**. This results in four distinct shell types, each with a specific startup and shutdown sequence.

---
## Observations

*   `zshenv` is **always** sourced, making it the most reliable place to define environment variables that must be available in all `zsh` processes.
*   `zshrc` is sourced for **all interactive** shells. This is the correct place for interactive-only settings like aliases, functions, and prompt customization.
*   `zprofile` and `zlogin` are sourced only for **login** shells. They are ideal for one-time setup tasks that should occur at the beginning of a user session.

---
## The macOS Engineering Delima

The interaction between `path_helper`, the `zsh` startup file hierarchy, and the need for a consistent, inheritable `PATH` is a significant challenge.

See [https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2](https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2)

Using `.zshenv` as the primary source of truth is correct in principle, as it's the only file guaranteed to be sourced by all shell invocations. However, the subsequent sourcing of `.zprofile` in login shells can introduce non-idempotent behaviors (like re-adding paths) and other complexities with `path_helper`.

### Solving this issue robustly

The strategy is to create a **centralized, idempotent environment loader script** and call it from the appropriate startup files.

---
### The Unified Environment Loader Approach

This method ensures the environment is configured exactly once per shell, in the correct order, regardless of whether the shell is login, non-login, interactive, or non-interactive.

#### **Principle 1: Centralize Your Logic**
Do not place complex logic directly into `.zshenv` or `.zprofile`. Instead, create a single, dedicated script that manages your entire environment setup.

#### **Principle 2: Ensure Idempotency**
The script must be safe to run multiple times without causing side effects, like infinitely growing your `PATH`. We achieve this with a simple guard variable.

#### **Principle 3: Control the Order**
To defeat `path_helper`'s unpredictable reordering, we let it do its work first and then deterministically prepend our critical developer paths.

---
## Background: The 4 distinct shell types

### 1. Interactive Login Shell

*(Example: Connecting via `ssh user@host` or using `su -l user`)*

This is the most comprehensive sequence, loading all categories of startup files.

| Order | File | Purpose |
| :--- | :--- | :--- |
| 1 | `/etc/zshenv` | System-wide settings for **all** shells |
| 2 | `~/.zshenv` | User-specific settings for **all** shells |
| 3 | `/etc/zprofile` | System-wide settings for **login** shells |
| 4 | `~/.zprofile` | User-specific settings for **login** shells |
| 5 | `/etc/zshrc` | System-wide settings for **interactive** shells |
| 6 | `~/.zshrc` | User-specific settings for **interactive** shells |
| 7 | `/etc/zlogin` | System-wide settings loaded at the end of login |
| 8 | `~/.zlogin` | User-specific settings loaded at the end of login |

---

### 2. Interactive Non-Login Shell

*(Example: Opening a new terminal window on your desktop)*

This shell skips the login-specific `profile` and `login` files.

| Order | File | Purpose |
| :--- | :--- | :--- |
| 1 | `/etc/zshenv` | System-wide settings for **all** shells |
| 2 | `~/.zshenv` | User-specific settings for **all** shells |
| 3 | `/etc/zshrc` | System-wide settings for **interactive** shells |
| 4 | `~/.zshrc` | User-specific settings for **interactive** shells |

---

### 3. Non-Interactive Login Shell

*(Example: `ssh user@host 'command'`)*

This shell is for remote execution. It loads login files but skips interactive `rc` files.

| Order | File | Purpose |
| :--- | :--- | :--- |
| 1 | `/etc/zshenv` | System-wide settings for **all** shells |
| 2 | `~/.zshenv` | User-specific settings for **all** shells |
| 3 | `/etc/zprofile` | System-wide settings for **login** shells |
| 4 | `~/.zprofile` | User-specific settings for **login** shells |
| 5 | `/etc/zlogin` | System-wide settings loaded at the end of login |
| 6 | `~/.zlogin` | User-specific settings loaded at the end of login |

---

### 4. Non-Interactive Non-Login Shell

*(Example: A script starting with `#!/bin/zsh`)*

This is the most minimal sequence, intended for scripting. It only loads the environment files.

| Order | File | Purpose |
| :--- | :--- | :--- |
| 1 | `/etc/zshenv` | System-wide settings for **all** shells |
| 2 | `~/.zshenv` | User-specific settings for **all** shells |

---

### Logout

Finally, when a **login shell** exits, it sources the logout files.

| Order | File | Purpose |
| :--- | :--- | :--- |
| 1 | `~/.zlogout` | User-specific commands on logout |
| 2 | `/etc/zlogout` | System-wide commands on logout |
