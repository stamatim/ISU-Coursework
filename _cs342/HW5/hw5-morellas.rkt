#lang racket
(require racket/trace)
(provide (all-defined-out))

;; semantics of the code
;; sem function: input sequence of statements (SSeq) and an environment -> new environment
(define (sem P Env)
  (if (null? (cdr P)) ;; if the rest of the sequence is null
      (semstmt (car P) Env) ;; produces output environment based on semantics of one statement
      (sem (cdr P) (semstmt (car P) Env))))

;; semstmt function: input a statement and an environment -> new environment
(define (semstmt S Env)
  (cond
    [ ;; declaration (decl x) -> add (x 0) to the environment
     (equal? (car S) 'decl)      (cons (list (cadr S) 0) Env) ]
    
    [ ;; assignment  (assign ArithExpr) -> evaluate ArithExpr=value, (x value)
      ;; write a new function to update existing value of variable in the environment
     (equal? (car S) 'assign)    (updatevalue (cadr S)
                                              (semarith (cadr (cdr S)) Env)
                                              Env) ]
    [ ;; if statement is of the form (if Condition (SSeq))
      ;; evaluate the semantics of (SSeq) in the context of an Env by a marker
      ;; semantics of the condition:
      ;;     if the condition is true -> compute the semantics of the body of the if in an environment with marker
      ;;         output will be a new environment with marker
      ;;         remove the marker - write a new function for this
      ;;     otherwise, return the current environment
     (equal? (car S) 'if)        (removemarker (semif (semcond (cadr S) Env) ;; evaluation of condExpr
                                                      (cadr (cdr S)) ;;
                                                      (cons (list '$if 0) Env))) ]

    [ ;; while statement is of the form (while condExpr (SSeq))
      ;; if the condition is true
      ;;     create a new sequence of statements
      ;;     ( (if (eq 1 1) SSeq))  (while condExpr (SSeq)) )
     (equal? (car S) 'while)     (if (semcond (cadr S) Env)
                                     (sem (list (list '$if '(gt 1 0) (cadr (cdr S)))
                                                S)
                                          Env)
                                     Env) ]


    [ ;; funcdecl statement is of the form (funcdecl (FName ParamList) (SSeq))
      ;; semantics of the condition
      ;;     if the condition is true -> 
     (equal? (car S) 'funcdecl)  (if (semparam (cadr S) Env) ;; evaluate the list of params
                                     (sem (list (list '$if '(eq 0 0) (cadr (cdr S)))
                                                S)
                                          Env)
                                     Env) ]
     
  ))

;; semparam function:
;; helper to evaluate the list of parameters
(define (semparam expr env)
  (cond
    [ (symbol? (car expr))    (findvalue (car expr) env) ]

    [ (symbol? (cadr expr))    (findvalue (cadr expr) env) ]

  ))
    


;; semif function: 
(define (semif condExpr SSeq Env)
  (if condExpr
      (sem SSeq Env)
  ))

;; removemarker function:
(define (removemarker Env)
  (if (equal? (car (car Env)) '$if)
      (cdr Env)
      (removemarker (cdr Env))
  ))
      

;; updatevalue function:
(define (updatevalue v val Env)
  (if (equal? v (car (car Env)))
      (cons (list v val) (cdr Env)) ;; first pair is the existing value of v -> updated and added back to list
      (cons (car Env) (updatevalue v val (cdr Env)))))

;; ---------------------------------------------------------------------------------------------------------------------------- ;;
;; code from 02.20 lecture
;; Find value associated with variable
(define (findvalue v env)
  (if (equal? (car (car env)) v)
      (cadr (car env))
      (findvalue v (cdr env))
  ))

(define (semarith expr env)
  (cond
    [ (symbol? expr)    (findvalue expr env) ]
    
    [ (number? expr)    expr ]
    
    [ (equal? (car expr) '+)  (+ (sem (cadr expr) env)
                                 (sem (cadr (cdr expr)) env)) ]
    
    [ (equal? (car expr) '-)  (- (sem (cadr expr) env)
                                 (sem (cadr (cdr expr)) env)) ]
    
    [ (equal? (car expr) '*)  (* (sem (cadr expr) env)
                                 (sem (cadr (cdr expr)) env)) ]
    
    [ (equal? (car expr) '/)  (/ (sem (cadr expr) env)
                                 (sem (cadr (cdr expr)) env)) ]
   ))

(define (semcond expr env)
  (cond
    [ (equal? (car expr) 'gt)  (> (sem (cadr expr) env)
                                  (sem (cadr (cdr expr)) env)) ]
    [ (equal? (car expr) 'lt)  (< (sem (cadr expr) env)
                                  (sem (cadr (cdr expr)) env)) ]
    [ (equal? (car expr) 'or)  (or (semcond (cadr expr) env)
                                  (semcond (cadr (cdr expr)) env)) ]
    ;; ...
   ))