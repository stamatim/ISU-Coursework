#lang racket
(require racket/trace)
(provide (all-defined-out))

(define attr1
   '(
      (black (red blue white))
      (blue  (red))
      (white (blue red))

     ))

(define attr2
  '(
    (electric (four six))
    (hybrid (four six))
    (four (six))))

(define attr3
  '(
    (tesla (skoda alfa bmw))
    (bmw (skoda alfa))
    (alfa (skoda))))

(define carlist
  '( (red electric tesla)
     (black hybrid bmw)
     (blue electric bmw)
     (red hybrid bmw)
     (red four alfa)
     (blue electric tesla)
     (black four alfa)
     (black electric skoda)))

(define (member? x l)
  (cond [(empty? l) false]
        [(equal? x (car l)) true]
        [else (member? x (rest l))]))


(define (GT? x y attr)
  (cond  [(empty? attr) false]
         [(equal? x y) true]
         [(and (equal? x (car (car attr))) (member? y (cadr (car attr))))]
         [else (GT? x y (rest attr))]))

;; ================================================================================= ;;

(define (brandorder? x y)
  (GT? x y attr3))

(define (engineorder? x y)
  (GT? x y attr2))

(define (colororder? x y)
  (GT? x y attr1))


(define (GTL? l1 l2)
     (if (and (colororder?  (car l1) (car l2))
              (engineorder? (cadr l1) (cadr l2))
              (brandorder?  (cadr (cdr l1)) (cadr (cdr l2))))
         true
         false))

(define (EQL? l1 l2)
     (if (and (equal?  (car l1) (car l2))
              (equal? (cadr l1) (cadr l2))
              (equal?  (cadr (cdr l1)) (cadr (cdr l2))))
         true
         false))

(define (countedgesfromnode n l li)
  (cond [(empty? l) li]
        [(EQL? n (car l)) (countedgesfromnode n (cdr l) li)]
        [(GTL? n (car l)) (countedgesfromnode n (cdr l) (+ 1 li))]
        [else (countedgesfromnode n (cdr l) li)]))

(define (countedgestonode n l li)
  (cond [(empty? l) li]
        [(EQL? n (car l)) (countedgestonode n (cdr l) li)]
        [(GTL? (car l) n) (countedgestonode n (cdr l) (+ 1 li))]
        [else (countedgestonode n (cdr l)  li)]))


(define (ordercars clist cl l1 l2 l3)
  (cond [(empty? clist) (list l1 l2 l3)]
       [(equal? 3 (countedgesfromnode (car clist) cl 0)) (ordercars (cdr clist) cl (cons (car clist) l1) l2 l3)]
       [(and (equal? 0 (countedgesfromnode (car clist) cl 0))
             (equal? 0 (countedgestonode (car clist) cl 0))) (ordercars (cdr clist ) cl (cons (car clist) l1) l2 l3)]
       [(equal? 1 (countedgesfromnode (car clist) cl 0))  (ordercars (cdr clist) cl l1 (cons (car clist) l2)  l3)]
       [else  (ordercars (cdr clist) cl  l1 l2 (cons (car clist) l3))]))

(define (weakorder clist attr1 attr2 attr3)
  (ordercars clist carlist '() '() '()))