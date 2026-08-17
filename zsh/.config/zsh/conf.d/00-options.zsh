# Shell behaviour. Loaded first because later files depend on some of it —
# extended_glob in particular, which 20-completion.zsh uses for its cache check.

# --- directory navigation ---------------------------------------------------
setopt auto_cd              # a bare `dotfiles` cds there when it isn't a command
setopt auto_pushd           # every cd pushes the old dir, so `cd -<TAB>` lists history
setopt pushd_ignore_dups
setopt pushd_silent         # don't dump the whole stack after every cd
setopt cdable_vars

# --- globbing ---------------------------------------------------------------
setopt extended_glob        # #, ~, ^ operators and the (#q...) qualifier syntax
setopt numeric_glob_sort    # file10 sorts after file9, not between file1 and file2
setopt no_case_glob
# Deliberately NOT glob_dots: it would make `rm *` match .git.

# --- prompt and input -------------------------------------------------------
setopt interactive_comments # allow trailing # comments when typing at the prompt
setopt no_beep
setopt long_list_jobs
setopt no_flow_control      # free up ^S and ^Q, which nothing sane uses for XON/XOFF
setopt no_clobber           # `>` refuses to truncate an existing file; `>|` still does

# --- correction -------------------------------------------------------------
# correct_all is too eager (it second-guesses filenames); correcting just the
# command word catches the actual typos without getting in the way.
setopt correct
