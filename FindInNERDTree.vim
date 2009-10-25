" FindInNERDTree
"
" Description: Plugin for running a single Ruby test under the cursor
"              Supports TestUnit and Rspec
" Last Change: Oct 20, 2009
" Version: 1.0
" Author:	Doug McInnes <doug@dougmcinnes.com>
" URL: http://github.com/dmcinnes/find_in_nerd_tree/tree
"
" A plugin for NERDTree
" http://www.vim.org/scripts/script.php?script_id=1658

function! FindInNERDTree(...)
  if a:0
    let l:path = a:1
  else
    let l:path = g:NERDTreePath.New(bufname('%'))

    let l:nerdbuf = 0
    for item in tabpagebuflist()
      if bufname(item) =~ "^NERD_tree_"
        let l:nerdbuf = item
      endif
    endfor

    if l:nerdbuf
			silent! exec bufwinnr(l:nerdbuf) . "wincmd w"
    else
      silent! exec "NERDTreeToggle"
    endif

    call cursor(g:NERDTreeFileNode.GetRootLineNum(), 1)
  endif
  let l:root = g:NERDTreeDirNode.GetSelected()

  if l:root.path.compareTo(l:path) == 0
    return l:root.findNode(l:path)
  elseif l:path.str() == g:NERDTreePath.Slash()
    echo "Not in the current NERD tree!"
  else
    let l:node = FindInNERDTree(l:path.getParent())
    if !empty(l:node)
      call l:node.open()
      if a:0
        return l:node.findNode(l:path)
      else
        call NERDTreeRender()
        call g:NERDTreeFileNode.New(l:path).putCursorHere(1, 0)
      endif
    endif
  endif

  return {}
endfunction
