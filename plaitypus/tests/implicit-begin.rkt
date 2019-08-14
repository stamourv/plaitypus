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

(test (local [(define x 3)]
        (define y 5)
        (set! global #f)
        (define z (+ y 1))
        (+ x z))
      9)

(test (let ([x 0]
            [w 7])
        (define x 3)
        (set! global #t)
        (define y (+ x (+ w 2)))
        y)
      12)

(test (letrec ([x 0]
               [w 7])
        (define x 3)
        (set! global #t)
        (define y (+ x (+ w 2)))
        y)
      12)

(test (let* ([x 0]
             [w (+ x 7)])
        (define x 3)
        (set! global #t)
        (define y (+ x (+ w 2)))
        y)
      12)

(define p (make-parameter #f))
(test (parameterize ([p #t])
        (parameter-set! p (not (parameter-ref p)))
        (define x (not (parameter-ref p)))
        x)
      #t)

(test (cond [(= (+ 0 1) 10)
             (define x 15)
             (set! global #f)
             (+ x 17)]
            [else
             (define x 12)
             (- x 10)])
      2)

(test (case (+ 1 2)
        [(0)
         (define x 15)
         (set! global #f)
         (+ x 17)]
        [(1)
         (define y 17)
         y]
        [else
         (define x 12)
         (- x 10)])
      2)

(test (let ()
        (define x 5)
        (when true
          (set! x 7)
          (define y 12)
          (set! x y))
        x)
      12)

(test (let ()
        (define x 5)
        (unless false
          (set! x 7)
          (define y 12)
          (set! x y))
        x)
      12)

(define-type Foo
  [bop (x : number)])

(test (type-case Foo (bop 5)
          [bop (x)
               (define y (+ x 2))
               (set! global #t)
               (+ y 10)])
      17)
