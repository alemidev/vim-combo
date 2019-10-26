# vim-combo
Have you ever wondered how sick is your function typing? That insane very long lambda you just written in one go must have been a hell of a combo, shame it wasn't tracked.

Well now you can! vim-combo is inspired by the power-mode many more graphical editors have. While all the particles and text shaking is nice and all, the thing I really wanted was to keep track of my typing combos.
So here comes vim-combo! Each keypress in insert mode increases the counter. The counter gets resetted if you type nothing for more than half a second.

vim-combo keeps track of your best combos by saving them to a .combo file in .vim. Every time vim loads, the best combo is loaded from such file. Every time you get a new best score, the content of such file is overwritten.

There already are few plugins which provide particles (vim-particle, vim-power-mode) but they required windows. vim-combo can run on any system since it's only vim script!
