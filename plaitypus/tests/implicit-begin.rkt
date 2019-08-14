#lang plaitypus

(print-only-errors #t)

(define global #t)

(define (foo [x : number])
  (define y (add1 x))
  (define z (sub1 x))
  (set! global #f)
  (+ y z))

(test (foo 3) 6)

(define bar : (number -> number)
  (lambda (x)
    (define y (add1 x))
    (define z (sub1 x))
    (set! global #f)
    (+ y z)))

(test (bar 3) 6)
