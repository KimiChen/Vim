" checksyntax.vim -- Check syntax when saving a file (php, ruby, tex ...)
" @Author:      Thomas Link (samul AT web de)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     04-Mai-2005.
" @Last Change: 12-Dez-2005.
" @Revision:    0.3.152

if exists('g:checksyntax')
    finish
endif
let g:checksyntax = 3

""" General variables
if !exists('g:checksyntax_auto')
    let g:checksyntax_auto = 1
endif
" if !exists('g:checksyntax_shellpipe')
"     let g:checksyntax_shellpipe = '>'
" endif

""" Php specific
"""""" Check syntax
if !exists('g:checksyntax_cmd_php')
    let g:checksyntax_cmd_php  = 'php -l'
endif
if !exists('g:checksyntax_efm_php')
    let g:checksyntax_efm_php  = '%*[^:]: %m in %f on line %l'
endif
if !exists('g:checksyntax_okrx_php')
    let g:checksyntax_okrx_php = 'No syntax errors detected in '
endif
if !exists('g:checksyntax_failrx_php')
    let g:checksyntax_failrx_php = 'Parse error: '
endif
if !exists('g:checksyntax_auto_php')
    let g:checksyntax_auto_php = 1
endif

"""""" Parse
if !exists('g:checksyntax_cmd_phpp')
    let g:checksyntax_cmd_phpp = 'php -f'
endif
if !exists('g:checksyntax_efm_phpp')
    let g:checksyntax_efm_phpp = g:checksyntax_efm_php
endif
if !exists('g:checksyntax_okrx_phpp')
    let g:checksyntax_okrx_phpp = g:checksyntax_okrx_php
endif
if !exists('g:checksyntax_failrx_phpp')
    let g:checksyntax_failrx_phpp = '^Parse error: '
endif
if !exists('g:checksyntax_auto_phpp')
    let g:checksyntax_auto_phpp = g:checksyntax_auto_php
endif

if !exists('g:checksyntax_alt_php')
    let g:checksyntax_alt_php = 'phpp'
endif


""" Ruby specific
if !exists('g:checksyntax_cmd_ruby')
    let g:checksyntax_cmd_ruby = 'ruby -c'
endif
if !exists('g:checksyntax_okrx_ruby')
    let g:checksyntax_okrx_ruby = 'Syntax OK\|No Errors'
endif
if !exists('g:checksyntax_auto_ruby')
    " let g:checksyntax_auto_ruby = 1
    let g:checksyntax_auto_ruby = 0
endif
if !exists('*CheckSyntax_prepare_ruby')
    fun! CheckSyntax_prepare_ruby()
        compiler ruby
    endf
endif

""" chktex (LaTeX specific
if !exists('g:checksyntax_cmd_tex')
    let g:checksyntax_cmd_tex = 'chktex -q -v0'
endif
if !exists('g:checksyntax_auto_tex')
    " File:Line:Column:Warning number:Warning message
    let g:checksyntax_efm_tex  = '%f:%l:%m'
endif
if !exists('g:checksyntax_auto_tex')
    " let g:checksyntax_auto_tex = 1
    let g:checksyntax_auto_tex = 0
endif


" CheckSyntax(manually, ?bang='', ?type=&ft)
function! CheckSyntax(manually, ...)
    let bang = a:0 >= 1 && a:1 != '' ? 1 : 0
    let ft   = a:0 >= 2 && a:2 != '' ? a:2 : &filetype
    if bang && exists('g:checksyntax_alt_'. ft)
        let ft = g:checksyntax_alt_{ft}
    endif
    if &modified
        echom "Buffer was modified. Please save it before calling :CheckSyntax."
        return
    end
    if exists('g:checksyntax_cmd_'. ft) 
                \ && (a:manually ||
                \     (exists('g:checksyntax_auto_'. ft)
                \      && g:checksyntax_auto_{ft}))
        let t  = @t
        let mp = &makeprg
        let ef = &errorformat
        let sp = &shellpipe
        try
            let &makeprg = g:checksyntax_cmd_{ft}
            if exists('g:checksyntax_shellpipe')
                let &shellpipe = g:checksyntax_shellpipe
            endif
            if exists('g:checksyntax_efm_'. ft)
                let &errorformat = g:checksyntax_efm_{ft}
            else
                set errorformat&
            endif
            if exists('*CheckSyntax_prepare_'. ft)
                call CheckSyntax_prepare_{ft}()
            endif
            let @t = ''
            try
                silent make %
                redir @t
                silent clist
                redir END
            catch
            endtry
            if @t =~ '\ \d \f\{-}:\d\{-}:'
                call CheckSyntaxFail(a:manually)
            else
                call CheckSyntaxSucceed(a:manually)
            " elseif exists('g:checksyntax_failrx_'. ft)
            "     if @t =~ g:checksyntax_failrx_{ft} || 
            "         call CheckSyntaxFail(a:manually)
            "     else
            "         call CheckSyntaxSucceed(a:manually)
            "     endif
            " elseif @t == '' || (exists('g:checksyntax_okrx_'. ft) && @t =~ g:checksyntax_okrx_{ft})
            "     call CheckSyntaxSucceed(a:manually)
            " else
            "     call CheckSyntaxFail(a:manually)
            endif
        finally
            let @t = t
            let &makeprg     = mp
            let &errorformat = ef
            let &shellpipe   = sp
        endtry
    endif
endf

if !exists('*CheckSyntaxSucceed')
    func! CheckSyntaxSucceed(manually)
        cclose
        if a:manually
            echo
            echo 'Syntax ok.'
        endif
    endf
endif

if !exists('*CheckSyntaxFail')
    fun! CheckSyntaxFail(manually)
        copen
    endf
endif

command! -bang -nargs=? CheckSyntax call CheckSyntax(1, "<bang>", <f-args>)

if !hasmapto(':CheckSyntax')
    noremap <F5> :CheckSyntax<cr>
    inoremap <F5> <c-o>:CheckSyntax<cr> 
endif

if g:checksyntax_auto
    autocmd BufWritePost * call CheckSyntax(0)
endif


finish
History:
0.2 php specific
0.3 generalized plugin; modes; support for ruby, phpp, latex (chktex)

