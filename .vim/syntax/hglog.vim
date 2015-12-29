" mercurial custom logs syntax file

if exists("b:current_syntax")
  finish
endif

syn keyword hgTag tag
syn keyword hgSummary summary
syn keyword hgDate date
syn keyword hgUser user
syn keyword hgChangeset changeset

hi def link hgTag Statement
hi def link hgSummary Function
hi def link hgDate PreProc
hi def link hgUser Type
hi def link hgChangeset Todo

