#lang racket/base

(module m1 plaitypus
  (define (f x) x))

(module m2 racket/base
  (require (submod ".." m1))
  (f 1))

;; ----------------------------------------

(module m3 plaitypus
  (define (id x) x))

(module m4 racket
  (require (submod ".." m3))
  (id 1))
