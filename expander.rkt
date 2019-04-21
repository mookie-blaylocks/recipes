#lang br/quicklang
(require json)

(define-macro (recipes-mb PARSE-TREE)
  #'(#%module-begin
     (define result-string PARSE-TREE)
     (define validated-jsexpr (string->jsexpr result-string))
     (display result-string)))
(provide (rename-out [recipes-mb #%module-begin])) 

(define-macro (recipes-char CHAR-TOK-VALUE)
  #'CHAR-TOK-VALUE)
(provide recipes-char)
