#lang racket
(require json)

(define recipes-file
  (open-input-file "recipes.json" #:mode 'text))

(define recipes-json (read-json recipes-file))

(define dinner (hash-ref recipes-json 'dinner))
(define breakfast (hash-ref recipes-json 'breakfast))
(define waffles (hash-ref breakfast '|Essential Raised Waffles|))
(hash-keys waffles)
(car (hash-keys dinner))
(car (hash-keys breakfast))
