" COMBO Counter

" Check if already loaded
if exists('g:combo_tracker_already_loaded')
	finish
endif
let g:combo_tracker_already_loaded = 1

" Check for a .combo folder, make one if missing
if !isdirectory($HOME . '/.vim')
	silent !mkdir $HOME/.vim
endif
if !isdirectory($HOME . '/.vim/.combo')
	silent !mkdir $HOME/.vim/.combo
endif

function ComboFmt()
	return printf("combo|%d [best|%d]", g:combo_counter, g:best_combo)
endfunction
"
" Declare variables
let g:combo_counter = 0		" The actual combo variable
let g:best_combo = 0		" Where best score for filetype is tracked
let g:best_last_combo = 0	" Used to revert, when you cheat by accident
let g:combo_timeout = 1
let g:combo = ComboFmt()
let g:last_combo = reltime()	" Set current time as last combo time

" Get extension, choose combo file
function ReloadComboFile()
	let g:combo_file_type = &filetype
	if strlen(g:combo_file_type) > 0 
		let g:combo_file = $HOME . '/.vim/.combo/' . g:combo_file_type . ".cmb"
	else
		let g:combo_file = $HOME . '/.vim/.combo/none.cmb'
	endif
	
	" Find best score for current filetype. If none exists, start tracking
	if filereadable(g:combo_file)
		let g:best_combo = readfile(g:combo_file)
		let g:best_combo = g:best_combo[0]
	else
		silent exec '!echo 0 > ' . g:combo_file
		let g:best_combo = 0
	endif
	let g:best_last_combo = g:best_combo		" Used to revert
	let g:combo_counter = 0		" The actual combo variable
	let g:combo = ComboFmt()
endfunction

autocmd FileType * call ReloadComboFile()

" Main check function, executed every time the file is changed
function! UpdateCombo()
	if reltimefloat(reltime(g:last_combo)) > g:combo_timeout
		call SaveCombo()
		let g:combo_counter = 1
	else
		let g:combo_counter +=1
	endif
	let g:combo = ComboFmt()
	let g:last_combo = reltime()
endfunction
autocmd TextChangedI * call UpdateCombo()	" Every time text is changed, call combo function

" Checks if a new combo has been achieved and saves it to file
function! SaveCombo()		" Should check inside because it can be called on InsertLeave
	if g:combo_counter > g:best_combo
		call writefile([g:combo_counter], g:combo_file)
		let g:best_last_combo = g:best_combo
		let g:best_combo = g:combo_counter
	endif
endfunction
autocmd InsertLeave * call SaveCombo()

" In case you want to revert your last combo
function! Cheated()
	let g:best_combo = g:best_last_combo
	let g:combo_counter = g:best_last_combo
	call writefile([g:combo_counter], g:combo_file)
endfunction

" This is only needed to avoid backspace cheating.
function! Decrease()
	let g:combo_counter -= 1
	return "\<BS>"
endfunction

inoremap <expr> <BS> Decrease()
