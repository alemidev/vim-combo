" COMBO Counter
" Choose combo file depending on extension
if strlen(expand("%:e")) > 0 
	let g:combo_file = $HOME . '/.vim/.combo/' . expand("%:e") . ".cmb"
else
	let g:combo_file = $HOME . '/.vim/.combo/none.cmb'
endif

" Find best score across all filetypes
let scores = []
for f in split(globpath($HOME . '/.vim/.combo/', '*'), '\n')
	let buf = readfile(f)
	call insert(scores, buf[0])
endfor
let g:best_combo_all = max(scores)

" Checking for ignored extensions
let ignored = [ 'txt' ]
let g:disable_combo = 0
for f in ignored
	if expand("%:e") == f
		let g:disable_combo = 1
	endif
endfor

" If file should be ignored, just set text, else continue with script
if g:disable_combo
	let g:airline_section_b = 'ᛥ -|-|%{g:best_combo_all}'
else
	" Find best score for current filetype
	if filereadable(g:combo_file)
	        let g:best_combo = readfile(g:combo_file)
		let g:best_combo = g:best_combo[0]
	else
		silent !echo 0 > $HOME/.vim/.combo/%:e.cmb
		let g:best_combo = 0
	endif
	
	" Configure variables
	let g:combo_counter = 0		" The actual combo variable
	let g:timeout = 1
	let g:emphasis = ''
	let g:mult = 10
	let g:last_combo = reltime()	" Set current time as last combo time
	let g:airline_section_b = 'ᛥ %{g:combo_counter}|%{g:best_combo}|%{g:best_combo_all} %{g:emphasis}'
	function! UpdateCombo()
		if reltimefloat(reltime(g:last_combo)) > g:timeout
			call SaveCombo()
			let g:combo_counter = 1
		else
			let g:combo_counter +=1 
		endif
		let g:emphasis = ''
		let ceil = g:combo_counter / g:mult
		let i = 0
		while i < ceil
			let g:emphasis = g:emphasis . '*'
			let i+=1
		endwhile
		let g:last_combo = reltime()
	endfunction
	function! SaveCombo()
		if g:combo_counter > g:best_combo
			call writefile([g:combo_counter], g:combo_file)
			let g:best_combo = g:combo_counter
		endif
	endfunction
	
	autocmd TextChangedI * call UpdateCombo()	" Every time the cursor moves, call combo function
	autocmd InsertLeave * call SaveCombo()
	
	" Options for Backspace Cheaters
	" inoremap <BS> <C-o>:let g:combo_counter-=1<CR><BS>
endif
