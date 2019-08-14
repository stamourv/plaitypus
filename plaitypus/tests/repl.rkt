#lang racket

(define ns (make-base-empty-namespace))
(parameterize ([current-namespace ns])
  (namespace-require 'plaitypus))

(define (tl expect expr)
  (define s
    (with-output-to-string
      (lambda ()
        (parameterize ([current-namespace ns])
          ((current-print) (eval `(#%top-interaction . ,expr)))))))
  (unless (equal? s expect)
    (error 'test "failed: ~e vs. ~e" expect s)))

(define (te rx expr)
  (with-handlers ([exn:fail? (lambda (exn) 
                               (unless (regexp-match? rx (exn-message exn))
                                 (error 'test "failed: ~e vs. ~e" rx exn)))])
    (parameterize ([current-namespace ns])
      ((current-print) (eval `(#%top-interaction . ,expr))))
    (error 'test "failed (expected exn): ~.s" expr)))

(tl "- number\n1\n" '1)
(tl "" '(define x 5))
(tl "- number\n5\n" 'x)

(tl "" '(define b (box (list))))
(tl "- (boxof (listof '_a))\n'#&()\n" 'b)
(tl "- void\n" '(set-box! b (list 'a)))
(tl "- (boxof (listof symbol))\n'#&(a)\n" 'b)

(tl "" '(define-type (M 'a)
          [v (fd : 'a)]))
(te #rx"duplicate definition for identifier" '(define-type (M 'a)
                                                [M (v : 'a)]))

(tl "" '(define x (box empty)))
(tl "" '(define y (box empty)))
(te (regexp-quote "(listof (boxof (listof '_a))) vs. (boxof (listof '_b))") '(cons x y))

;; Should have no source inside plaitypus implementation:
(te "^typecheck failed" '(cond [#t 4] [#f "string"]))
(te "^typecheck failed" '(cond [#t 4] ["string" 5]))

(te "misplaced `else' clause"
    '(type-case (optionof string) (some "x") [some (x) x] [else "else"] [none () "none"]))

(te "must be an identifier"
    '(type-case (optionof string) "frn" [some (,w) 3]))


(tl "" (void))
