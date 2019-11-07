# vim-combo
Have you ever wondered how sick is your function typing? That insane very long lambda you just written in one go must have been a hell of a combo, shame it wasn't tracked.

Wasn't until now! vim-combo is inspired by the power-mode many more graphical editors have. While all the particles and text shaking is nice, the thing I really wanted was to keep track of my typing combos.
So here comes vim-combo! Each text edit in insert mode (autocmd on TextChangedI) increases the counter. The counter gets resetted if you type nothing for more than a second (you can set it to any number of seconds with g:timeout)

Pasting counts as 1 (be it in Insert-Paste or directly from clipboard), movement does not affect the counter and backspace keeps the combo going without increasing the counter.

vim-combo keeps track of your best combos for each filetype with files inside the hidden .combo folder (~/.vim/.combo). Every time vim loads, the best combo is loaded from file (one is kept for each filetype edited). Every time you get a new best score, the value on file is replaced. vim-combo also calculates the best combo across all filetypes, but it is not displayed by default (because my combo on .txt puts my combo on .c to shame). Use ```:ComboMaxOn, :ComboMaxOff``` to toggle.

There already are few plugins which provide particles (vim-particle, vim-power-mode) but they required windows. vim-combo can run on any system since it's only vim script!

Note that vim-combo by default places the counter in section B of airline-vim. All combos will be always tracked, but by default not displayed (as of now) unless you use airline-vim. You can add ```%1*\[%{g:best_combo_all}|%{g:best_combo}\] %{g:combo_counter} ᛥ``` anywhere you'd like. If you know a good spot to place it by default, do contact me! I have no idea!

Specific filetypes can be ignored (no combo will be counted while on them, and no best combo will be recorded). By default, .cmb files won't track combo. Note that none.cmb refers to files without extension, and should be in place (because the script does not create it).

vim-combo should be pretty fast. It runs a lot but does very little (time difference, counter). If you have any issue contact me!
