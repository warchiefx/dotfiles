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
non-interactive ssh shells can actually see. So it links the files, clones prezto
into `~/.zprezto`, `chsh`es the login shell to zsh, installs tpm and its tmux
plugins, and installs mosh — then checks the thing that actually breaks mosh.

```bash
./setup --list                 # report what would change, do nothing
./setup --only shell --only tmux
./setup --skip js
./setup --link-only            # just the symlinks
./setup --no-packages          # skip Termux package install
./setup --no-mosh --no-chsh    # skip mosh / leave the login shell alone
```

## Layout

The files are grouped by feature, one directory each:

```
shell/     zshrc zshenv zprofile zpreztorc
tmux/      tmux.conf
git/       gitconfig
ntfy/      client.yml
terminal/  ghostty/ termite/ Xresources
termux/    termux.properties font.ttf install-essentials
python/    pycodestyle.cfg pylintrc
js/        eslintrc eslintrc.js tern-config
```

A feature is any directory holding a `manifest`. That is the whole registry —
there is no list to keep in step with the filesystem, and `--only` / `--skip`
take those names.

A manifest says where each file belongs and which platforms want it:

```
# source      target                     platform
zshrc         ~/.zshrc
ghostty       $XDG_CONFIG_HOME/ghostty
Xresources    ~/.Xresources              linux
```

`~` and `$XDG_CONFIG_HOME` are expanded; nothing else is, and a target that does
not come out absolute is refused rather than acted on — a relative one would make
`mkdir -p` create the literal directory next to wherever `setup` was invoked
from. An omitted platform means both. Two things follow from targets being written out rather than derived
from filenames: `ghostty` can land in `~/.config` where ghostty actually reads it,
and X11-only files stop being linked on macOS where nothing reads them.

**Nothing is linked unless a manifest declares it.** Adding a file to this
repository does not silently put something in `$HOME`, and there is no exclusion
list to maintain for READMEs, licences and the script itself.

It is self-contained: it resolves its own directory, so it does not care where
this repository is checked out or what else is on the machine.

## Four things worth knowing

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

**`ntfy` push notifications & local secrets.** `ntfy/client.yml` configures
the default self-hosted host and topic. `zshenv` exports `NTFY_DEFAULT_HOST`,
`NTFY_SERVER`, `NTFY_DEFAULT_TOPIC`, and `NTFY_REGULUS_TOPIC`. It also sources
`~/.zshenv.local` (mode 0600, untracked) for local uncommitted secrets such as
`NTFY_TOKEN`. Run `~/.emacs.d/scripts/setup-ntfy-auth` to configure tokens.

**`termux` on Android.** When running in Termux on Android, `setup` links
`~/.termux/termux.properties` (modern defaults with disabled extra-keys toolbar)
and `~/.termux/font.ttf` (Iosevka Term Nerd Font with full icon and Powerline
support), reloads settings, and installs packages via `termux/install-essentials`
(python, mosh, tmux, zsh, vim, uv, termux-api, nodejs, wget, curl, openssh, gh, fzf)
with font verification. `termux/install-essentials` can also be run standalone.
If Nerd Fonts are not installable in a custom environment, tmux status indicators
support fallback to representative Unicode characters.

## Tests

Behaviour checks for `setup` live in the
[dotemacs](https://github.com/warchiefx/dotemacs) repository, which carries this
one as a submodule and has the test runner: `tests/test-dotfiles-setup`.
