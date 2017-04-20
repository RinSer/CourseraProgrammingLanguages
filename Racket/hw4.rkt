
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

; Function 1 that produces a list of numbers in a given interval with given stride
(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

; Function 2 to append string suffix to strings in a given list
(define (string-append-map xs suffix)
  (map (lambda(x) (string-append x suffix)) xs))

; Function 3 returns the (n mod list length)s element of a given list
(define (list-nth-mod xs n)
  (if (< n 0)
      (error "list-nth-mod: negative number")
      (if (null? xs)
          (error "list-nth-mod: empty list")
          (car (list-tail xs (remainder n (length xs)))))))

; Function 4 returns a list with the first n elements of a given stream
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))))

; Function 5 stream of natural numbers, where each 5th number is negative
(define funny-number-stream
  (letrec ([f (lambda (x)
                (cons (if (= 0 (remainder x 5))
                            (- x)
                            x) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

; Function 6 stream of two alternating strings (namely "dan.jpg" and "dog.jpg")
(define dan-then-dog
  (letrec ([f (lambda (str)
                (cons str (lambda () (f
                            (if (string=? str "dan.jpg")
                                "dog.jpg"
                                "dan.jpg")))))])
    (lambda () (f "dan.jpg"))))

; Function 7 reshapes the stream output into a pair with 0
(define (stream-add-zero s)
  (lambda ()
    (let ([n (s)])
      (cons (cons 0 (car n)) (stream-add-zero (cdr n))))))

; Function 8 stream of paired members from two lists
(define cycle-lists (lambda (xs ys)
                      (letrec ([f (lambda (n)
                                    (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
                                          (lambda () (f (+ n 1)))))])
    (lambda () (f 0)))))

; Function 9 assoc for vectors
(define (vector-assoc v vec)
  (letrec ([f (lambda (n)
             (if (>= n (vector-length vec))
                 #f
                 (let ([c (vector-ref vec n)])
                   (if (and (pair? c) (equal? (car c) v))
                       c
                       (f (+ n 1))))))])
    (f 0)))

; Function 10 extracts and cashes in a vector assoc pairs
(define (cached-assoc xs n)
  (letrec ([cash (make-vector n #f)]
           [pointer 0]
           [f (lambda (x)
                (let ([cv (vector-assoc x cash)])
                  (if cv
                      cv
                      (let ([cl (assoc x xs)])
                        (if cl
                            (begin
                              (vector-set! cash pointer cl)
                              (set! pointer (remainder (+ 1 pointer) n))
                              cl)
                            cl)))))])
    f))

; Challenge: define macros
(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (letrec ([x e1]
              [y (lambda ()
                   (let ([z e2])
                     (if (< z x)
                         (y)
                         #t)))]) (y))]))

; Fin