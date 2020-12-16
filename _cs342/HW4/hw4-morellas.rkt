#lang racket
#|
    Stamatios Morellas
    CS342 - Section A
    3/13/2020
|#

(require "program.rkt")
(provide (all-defined-out))
(require racket/trace)

;; Problem 1
;;    synchk
;; Return true if the program belongs to L
(define (synchk program)
    (cond
      [(null? program) #f] ;; program is null
      [(not (list? (car program))) #f]
      [else (sseq program)]
    )
)

;; Non-terminal 1
;;     sseq
(define (sseq program)
    (cond
      [(equal? 'decl (car (car program))) (decl program)] ;; if Statement is Decl
      [(equal? 'assign (car (car program))) (assign program)] ;; if Statement is Assign
      [(equal? 'if (car (car program))) (ifnt program)] ;; if Statement is If
      [(equal? 'while (car (car program))) (whilent program)] ;; if Statement is While
      [else #f]
    )
)

;; Non-terminal 2
;;     decl
(define (decl program)
    ;; Check length first
    (if (equal? (length (car program)) 2)
        (cond
          [(symbol? (cadr (car program))) (sseq (cdr program))] ;; If var, call recursively for the rest of the program
          [else #f]
        )
        0
    )
)

;; Non-terminal 3
;;     assign
(define (assign program)
    ;; Check length first
    (if (equal? (length (car program)) 3)
        (cond
          [(symbol? (cadr (car program))) (sseq (cdr program))]
          [(equal? #t (arithexpr (caddr (car program))) (sseq (cdr program)))]
          [else #f]
        )
        0
    )
)

;; Non-terminal 4
;;     arithexpr
(define (arithexpr expr)
    (cond
      [(number? expr #t)] ;; Check for Num
      [(symbol? expr #t)] ;; Check for Var
      [(op? (car (car program)) #t)]
      [else #f]
    )
)

;; Helper for arithexpr
(define (op? o)
    (if (or (equal? o '+) (equal? o '-) (equal? o '*) (equal? o '/))
        #t
        #f
    )
)
