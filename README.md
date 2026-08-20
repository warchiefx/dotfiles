# dotfiles

My shell environment: zsh (via prezto), tmux, git, ghostty, and the assorted
tool configs. Deployed on every machine I work on, including the ones I only ever
reach over ssh.

## Install

```bash
git clone https://github.com/warchiefx/dotfiles.git ~/dotfiles
~/dotfiles/setup
```

`setup` owns the whole environment, not just the files — `zshrc` sources prezto
and is inert without it, `tmux.conf` expects tpm, and mosh needs a `PATH` that
non-interactive ssh shells can actually see. So it:

- symlinks everything here into `$HOME`, prefixing a dot where there isn't one,
  and backs up anything already in the way
- puts the entries listed in `XDG_DOTFILES` under `$XDG_CONFIG_HOME` keeping
  their own name, because `~/.ghostty` is not a path ghostty reads
- clones prezto into `~/.zprezto`
- `chsh`es the login shell to zsh
- installs tpm and its tmux plugins
- installs mosh, then checks the thing that actually breaks it

```bash
./setup --list                 # report what would change, do nothing
./setup --link-only            # just the symlinks
./setup --no-mosh --no-chsh    # skip mosh / leave the login shell alone
```

It is self-contained: it resolves its own directory, so it does not care where
this repository is checked out or what else is on the machine.

## Two things worth knowing

**`TERM` is never set here.** The terminal emulator is the only thing that knows
what it can do, and tmux rewrites `TERM` for its panes, so exporting a value from
a shell rc file overwrites both. Forcing `xterm-256color` — a habit from Linux,
where terminals often under-reported — told Emacs it was talking to a real xterm
when it was talking to tmux, which broke arrow keys over ssh and cost truecolor
inside tmux. The note in `zshrc` has the details.

**`zshenv` exists for non-interactive ssh.** `ssh host <command>` runs a
non-interactive, non-login shell, and zsh reads only `.zshenv` for one — never
`.zprofile`, where the interactive setup lives. Without it `mosh host` fails with
"mosh-server not found" on a machine where mosh is installed, and a remote `qs` or
`claude` cannot be found either.

## Tests

Behaviour checks for `setup` live in the
[dotemacs](https://github.com/warchiefx/dotemacs) repository, which carries this
one as a submodule and has the test runner: `tests/test-dotfiles-setup`.
