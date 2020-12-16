#lang racket
#|
    Stamatios Morellas
    CS342 - Section A
    3/1/2020
|#

(provide (all-defined-out)) ;; for testing purposes
(require racket/trace)      ;; tracing library
(require "PTS.rkt")         ;; to access the database of points

;; --------------------------------------------------------------------------------------------------------------------- ;;
;; PART 1

;; Utility function 1
;;     sum
;; Compute the sum of all integers in a list
(define (sum lst)
    (if (null? lst)
        0
        (+ (car lst) (sum (cdr lst)))
    )
)

;; Utility function 2
;;     len
;; Return the length of a list
(define (len lst)
    (if (null? lst)
        0
        (+ 1 (len (cdr lst)))
    )
)

;; Utility function 3
;;     list_avg
;; Return the average of the sum of all the numbers in a list
(define (lst_avg lst)
    (if (null? lst)
        0
        (/ (sum lst) (len lst))
    )
)

;; Utility function 4
;;     get_x
;; Return a list of the X values from compute_mc input list
(define (get_x lst)
    (if (null? lst)
        lst
        (cons (car (car lst)) (get_x (cdr lst)))
    )
)

;; Helper function 5
;;     get_y
;; Return a list of the Y values from compute_mc input list
(define (get_y lst)
    (if (null? lst)
        lst
        (cons (cadr (car lst)) (get_y (cdr lst)))
    )
)

;; Utility function 6
;;     pwr2
;; Compute the square a number
(define (pwr2 num)
    (* num num)
)

;; Helper function for compute_m
;;     m_numer
;; Compute the numerator of m, defined in the assignment specifications
(define (m_numer lst avg_x avg_y) ;; List averages of x and y as parameters
    (if (null? lst)
        0
        (+ (* (- (car (car lst)) avg_x) (- (cadr (car lst)) avg_y)) (m_numer (cdr lst) avg_x avg_y))
    )
)

;; Helper function for compute_m
;;     m_denom
;; Compute the demominator of m, defined in the assignment specifications
(define (m_denom lst avg_x)
    (if (null? lst)
        0
        (+ (pwr2 (- (car (car lst)) avg_x)) (m_denom (cdr lst) avg_x))
    )
)

;; Component 1 of compute_mc
;;     compute_m
;; Calculate the value of m
(define (compute_m lst)
    (if (null? lst)
        0
        (/ (m_numer lst (lst_avg (get_x lst)) (lst_avg (get_y lst))) (m_denom lst (lst_avg (get_x lst))))
    )
)
    
;; Component 2 of compute_mc
;;     compute_c
;; Return the value of c
(define (compute_c lst)
    (if (null? lst)
        0
        (- (lst_avg (get_y lst)) (* (compute_m lst) (lst_avg (get_x lst))))
    )
)

;; Problem 1
;;     compute_mc
;; Compute m and c from the given list
(define (compute_mc lst)
    (list (compute_m lst) (compute_c lst))
)

;; --------------------------------------------------------------------------------------------------------------------- ;;
;; PART 2

;; Helper function for compute_E
;;     y_hat
;; Calculate the component of E summation - (mx + c)
(define (y_hat m x c)
    (+ (* m x) c)
)

;; Helper function for compute_E
;;     E_summation
;; Compute the summation portion of E (excluding 1/n)
(define (E_summation lst m x c)
    (if (null? lst)
        0
        (+ (pwr2 (- (cadr (car lst)) (y_hat m x c))) (E_summation (cdr lst) m (car (car lst)) c))
    )
)

;; Utility function 7
;;     compute_E
;; Calculate the value of E from part 1 of the assignment description
(define (compute_E lst)
    (if (null? lst)
        0
        (* (/ 1 (len lst)) (E_summation lst (compute_m lst) (car (car lst)) (compute_c lst)))
    )
)

;; Helper function for compute_dEdm
;;    dEdm_summation
;; Compute the summation portion of dE/dm
(define (dEdm_summation lst)
    (if (null? lst)
        0
        (+ (* (car (car lst)) (- (cadr (car lst)) (y_hat (compute_m lst) (car (car lst)) (compute_c lst)))) (dEdm_summation (cdr lst)))
    )
)

;; Helper function for update_mval
;;     compute_dEdm
;; Compute the value of dE/dm from the given list
(define (compute_dEdm lst)
    (if (null? lst)
        0
        (* (/ (- 0 2) (len lst)) (dEdm_summation lst))
    )
)

;; Helper function for compute_dEdc
;;     dEdc_summation
;; Compute the summation portion of dE/dc
(define (dEdc_summation lst)
    (if (null? lst)
        0
        (+ (- (cadr (car lst)) (y_hat (compute_m lst) (car (car lst)) (compute_c lst))) (compute_dEdc (cdr lst)))
    )
)

;; Helper function for update_cval
;;     compute_dEdc
;; Compute the value of dE/dc from the given list
(define (compute_dEdc lst)
    (if (null? list)
        0
        (* (/ -2 (len lst)) (dEdc_summation lst))
    )
)

;; Helper function for gradient_mc_helper
;;     update_mval
;; Update the value of m to (m - L)*(dE/dm)
(define (update_mval lst m L)
    (- m (* L (compute_dEdm lst)))
)

;; Helper function for gradient_mc_helper
;;     update_cval
;; Update the value of c to (c - L)*(dE/dc)
(define (update_cval lst c L)
    (- c (* L (compute_dEdc lst)))
)

;; Helper function for gradient_mc
;;     gradient_mc_helper
;; Helper method for gradient_mc
(define (gradient_mc_helper lst L e cnt m c)
    (if (or (< (compute_E lst) e) (>= 0 cnt))
        (list m c (compute_E lst)) ;; return a list
        (gradient_mc_helper lst L e (- cnt 1) (update_mval lst m L) (update_cval lst c L))
    )
)

;; Problem 2
;;     gradient_mc
;; Return a list containing the valuation of m, c, and E
(define (gradient_mc lst L e cnt)
    (if (null? lst)
        0
        (gradient_mc_helper lst L e cnt 0 0)
    )
)