# vim-combo
Have you ever wanted to obsessively classify your performance against know people of yours with a not-really-so-relevant score in different languages?
This plugin comes right to the rescue: it keeps track of a "combo" counter that increases every time you press a key. Waiting for too long resets such counter.
Deleting won't increase your combo but it will reset the timer. By default, the timer is 1 second. It may seem tight but longer timers lead to incredibly big combos too easily.
Pasting counts as 1 (be it in Insert-Paste or directly from clipboard), movement does not affect the counter.

vim-combo is inspired by the power-mode many more graphical editors have. While all the particles and text shaking is nice, the thing I really wanted was to keep track of my typing combos.
It uses a function called on buffer change (autocmd on TextChangedI) to increases the counter. Current time is checked every time against last best time.

vim-combo keeps track of your best combos for each filetype with files inside the hidden .combo folder (~/.vim/.combo). Every time vim loads, the best combo is loaded from file (one is kept for each filetype edited). Every time you get a new best score, the value on file is replaced.

There already are few plugins which provide particles (vim-particle, vim-power-mode) but they required windows. vim-combo can run on any system since it's only vim script!

If you just load this with a plugin manager, your combo will be tracked but not displayed anywhere. Current combo string is kept in `g:combo`, you can place it anywhere you'd like. If you don't have specific statusbar edits, you can add `set statusline=%{g:combo}` in your `.vimrc`.

Specific filetypes can be ignored (no combo will be counted while on them, and no best combo will be recorded). By default, .cmb files won't track combo. Note that none.cmb refers to files without extension, and should be in place.

vim-combo should be pretty fast. It runs a lot but does very little (time difference, counter). If you have any issue contact me!
