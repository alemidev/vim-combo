# vim-combo
## why
Have you ever wanted to obsessively classify your performance against know people of yours with a not-really-so-relevant score in different ~~programming languages~~ *filetypes*? This plugin comes right to the rescue!
## what
It keeps track of a "combo" counter that increases every time you type something. Waiting for too long resets such counter.
Deleting won't increase your combo but it will reset the timer. By default, the timer is 1 second. It may seem tight but longer timers lead to incredibly big combos too easily.
Pasting counts as 1 (be it in Insert-Paste or directly from clipboard), movement does not affect the counter.
## how
It uses a function called on buffer change (autocmd on TextChangedI) to increases the counter. Current time is checked every time against last recorded time.

vim-combo keeps track of your best combos for each filetype with files inside the hidden `.combo` folder (`~/.vim/.combo`). Every time the filetype changes, the best combo is loaded from file (one is kept for each filetype edited). Every time you get a new best score, the value on file is replaced.

# powermode for vim?
vim-combo is inspired by the power-mode many more graphical editors have. While all the particles and text shaking is nice, the thing I really wanted was to keep track of my typing combos.

There already are few plugins which provide particles (vim-particle, vim-power-mode) but they require gui and some fiddling. vim-combo can run on any system since it's only (~90 lines of) vim script!

# quickstart
If you just load this with a plugin manager, your combo will be tracked but not displayed anywhere. Current combo string is kept in `g:combo`, check it with `:let g:combo`.

You can (for example) put the value anywhere in your statusline:
```
set statusline=%{g:combo}
```
# configuring
* You can change the combo timeout by overriding `g:combo_timeout` in your `.vimrc`. Defaults to 1.
* You can access the whole combo string in `g:combo`. You can find current score in `g:combo_counter` and best score for file in `g:combo_best`.
* You can bind function `Cheated()` to a key. If you by accident register an unfair value, you can call it to revert.

# is this fast?
vim-combo should be pretty fast. It runs often but does very little (float difference, comparison, increment). I/O to disk is tiny and rare.
If you have any issue don't hesitate to contact me!
