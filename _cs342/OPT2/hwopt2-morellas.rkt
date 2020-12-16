#lang racket
(require "tests.rkt")
(provide (all-defined-out))


;; (List, Element) -> Bollean
;; produces true if the element is is the List otherwise false
(define (is-in-list? list value)
 (cond
  [(empty? list) false]
  [(equal? (car list) value) true]
  [else (is-in-list? (cdr list) value)]))

;; (List, List) -> List
;; produces the intersection of two lists 
(define (intersection a b)
  (cond [(empty? a) empty]
        [else (if (is-in-list? b (car a))
                  (cons (car a)(intersection (cdr a) b))
                  (intersection (cdr a) b))]))

;; Nodes on the graph
(define N0 "s0")
(define N1 "s1")
(define N2 "s2")
(define N3 "s3")
(define nodes (list N0 N1 N2 N3))

;;============================================================================================================================;;

(define-struct edge (x y))

;; ListOfEdge is either empty or (cons Edge ListOfEdge)
;; a list of Edges --> the trs structure given
(define E1 (make-edge N0 N1))
(define E2 (make-edge N0 N2))
(define E3 (make-edge N0 N3))
(define E4 (make-edge N1 N1))
(define E5 (make-edge N2 N3))
(define E6 (make-edge N3 N1)) 
(define trs (list E1 E2 E3 E4 E5 E6))

;;============================================================================================================================

;; State is (make-state Node ListOfProp)
;; a graph state at node n having propositions p
(define-struct state (n p)) 

;; ListOfState is either empty or (cons State ListOfState)
;; a list of States ---> the sts structure
(define sts (list (make-state N0 (list "p" "q")) (make-state N1 (list "p")) (make-state N2 (list "q"))  (make-state N3 (list empty))))

;;============================================================================================================================
;;
;;                                                             Functions
;;
;;============================================================================================================================

;; Edge -> list of nodes
(define (edge-to-nodes d)
  (append (list (edge-x d)    
                (edge-y d))))   

;; ==========================================================   tr function  ==================================================
;; ListOfEdge -> ListOfNode
;; The 'tr function is the first requirement of the grammar we need to implement

(define (tr-helper loe)
  (cond [(empty? loe) empty]
        [else
               (cons (edge-to-nodes (car loe))
                                    (tr-helper (cdr loe)))]))
(define (tr-merging loe)
  (cond [(empty? loe) empty]
        [else (set-union (car loe) (tr-merging (cdr loe)))]))

(define (tr loe)
  (sort (tr-merging (tr-helper loe)) string<?))


;;==========================================================  (prop x) function  ===============================================
;;
;;

;; (Prop, State) -> Node
;; produces the node that is associated with proposition p or '() otherwise
(define (state-to-node p  st)
  (cond [(is-in-list? (state-p st) p) (state-n st)]
        [else empty]))

;; (Prop, ListOfState) -> ListOfNode
(define (prop-to-node p losta)
  (cond [(empty? losta) empty]
        [else
          (if (is-in-list? (state-p (car losta)) p)
              (cons (state-to-node p (car losta)) (prop-to-node p (cdr losta)))
              (prop-to-node p (cdr losta)))]))

;;=========================================================  (not Expr) function  ==============================================
;;
;;

;; (ListOfNode, ListOfNode) -> ListOfNode
;; produces the list of nodes that do not belog to the list return by the expression
(define (notExpr l1 l2)
  (cond [(empty? l1) l2]
        [else
          (if (is-in-list? l2 (car l1))
              (notExpr (cdr l1) (remove (car l1) l2))
              (notExpr (cdr l1) l2))]))

;;====================================================== (and Expr1 Expr2) function  ===========================================
;;
;; (ListOfNode, ListOfNode) -> ListOfNode
;; produces the list of nodes common in the results of the two expressions, i.e., in the intersection

(define (andExpr l1 l2)
  (intersection l1 l2))

;;======================================================= (or Expr1 Expr2) function  ===========================================
;;
;; (ListOfNode, ListOfNode) -> ListOfNode
;; produces a list which is the union of the results of the two expressions

(define (orExpr l1 l2)
  (sort (set-union l1 l2) string<?))

;;========================================================= (ex Expr) function =================================================

;; (Node, ListOfEdge) -> ListOfNode
;; produces the list of initial nodes with a direct edge to the terminal node 
(define (from-to-node n loe)
  (cond [(empty? loe) empty]
        [else
              (if (equal? n (edge-y (car loe)))
                  (cons (edge-x (car loe)) (from-to-node n (cdr loe)))
                  (from-to-node n (cdr loe)))]))

;; (ListOfNode, ListOfEdge) -> ListOfNode
;; produces a list of initial nodes with directed nodes appearing in the given list ListOfNode 
(define (exExpr-helper lon trs)
  (cond [(empty? lon) empty]
        [else (set-union (from-to-node (car lon) trs) (exExpr-helper (cdr lon) trs))]))

(define (exExpr lon trs)
  (sort (flatten (exExpr-helper lon trs)) string<?))


;;======================================================== (ax Expr) function ===================================================

(define (axExpr lon trs)
  (notExpr (exExpr (notExpr lon nodes) trs) nodes))

;;====================================================== (starex Expr) function =================================================

;; ListOfNode -> ListOfNode
(define (starexExpr lonode)
  (cond [(equal? (sort lonode string<?) (sort (exExpr lonode trs) string<?)) (sort lonode string<?)]
        [else  
               (starexExpr (set-union (sort lonode string<?) (sort (exExpr lonode trs) string<?)))]))

;;====================================================== (starax Expr) function ====================================================

;; (Node, ListOfEdge) -> ListOfNode
;; produces the list of initial nodes with a direct edge to the terminal node 

(define (reach-from-node n loe)
  (cond [(empty? loe) empty]
        [else
              (if (equal? n (edge-x (car loe)))
                  (cons (edge-y (car loe)) (reach-from-node n (cdr loe)))
                  (reach-from-node n (cdr loe)))]))

(define (all-out-node lon lons)
  (cond [(empty? lon) empty]
        [else
              (if (subset? (reach-from-node (car lon) trs) lons)
                  (cons (car lon) (all-out-node (cdr lon) lons))
                  (all-out-node (cdr lon) lons))])) 

;; ListOfNode -> ListOfNode
(define (staraxExpr lonode)
  (cond [(equal? (sort lonode string<?)  (sort (all-out-node nodes lonode ) string<?)) (sort lonode string<?)]
        [else  
               (staraxExpr (set-union (sort lonode string<?) (sort (all-out-node nodes lonode ) string<?)))]))

;;======================================================= vsem function ===========================================================

(define (vsem ls sts trs)
  (cond [(equal? 'tr ls)                                                                                      (tr trs)]
        [(equal? 'fa ls)                                                                                         empty]
        [(equal? 'prop (car ls))                                (prop-to-node (car (cdr (map symbol->string ls))) sts)] 
        [(equal? 'not (car ls))                                        (notExpr (vsem (car (cdr ls)) sts trs)   nodes)]                                
        [(equal? 'and (car ls))            (andExpr (vsem (car (cdr ls)) sts trs) (vsem (car (cdr (cdr ls))) sts trs))]
        [(equal? 'or (car ls))              (orExpr (vsem (car (cdr ls)) sts trs) (vsem (car (cdr (cdr ls))) sts trs))]
        [(equal? 'ex (car ls))                                              (exExpr (vsem (car (cdr ls)) sts trs) trs)]
        [(equal? 'ax (car ls))                                              (axExpr (vsem (car (cdr ls)) sts trs) trs)]
        [(equal? 'starex (car ls))                                          (starexExpr (vsem (car (cdr ls)) sts trs))]
        [(equal? 'starax (car ls))    (staraxExpr (vsem (car (cdr ls)) sts trs))]
  ))
