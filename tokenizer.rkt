#lang br/quicklang
(require brag/support racket/contract)

(module+ test
  (require rackunit))

(define (recipes-token? x)
  (or (eof-object? x) (string? x) (token-struct? x)))

(module+ test
  (check-true (recipes-token? eof))
  (check-true (recipes-token? "a string"))
  (check-true (recipes-token? (token 'A-TOKEN-STRUCT "hi")))
  (check-false (recipes-token? 42)))

(define (make-tokenizer port)
  (port-count-lines! port)
  (define (next-token)
    (define recipes-lexer
      (lexer
       [(from/to "//" "\n") (next-token)]
       [(from/to "@$" "$@")
        (token 'SEXP-TOK (trim-ends "@$" lexeme "$@")
               #:position (+ (pos lexeme-start) 2)
               #:line (line lexeme-start)
               #:column (+ (col lexeme-start))
               #:span (- (pos lexeme-end)
                         (pos lexeme-start)))]))
    (recipes-lexer port))
  next-token)
(provide
 (contract-out
  [make-tokenizer (input-port? . -> . (-> recipes-token?))]))

(module+ test
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "// comment\n")
   empty)
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "@$ (+ 6 7) $@")
   (list (token 'SEXP-TOK " (+ 6 7) "
                #:position 3
                #:line 1
                #:column 2
                #:span 9)))
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "hi")
   (list (token 'CHAR-TOK "h"
                #:position 1
                #:line 1
                #:column 0
                #:span 1)
	 (token 'CHAR-TOK "i"
                #:position 2
                #:line 1
                #:column 1
                #:span 1))))  
