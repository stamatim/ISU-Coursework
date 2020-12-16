#lang racket
(require racket/trace)
(provide (all-defined-out))
(require "program.rkt")

(define (sem P Env Heap)
  (sem-h P (list Env Heap)))

;; semantics of a program = semantics of rest of the program in the context of semantics of first statement
(define (sem-h P Env)
  (if (null? (cdr P))
      (semstmt (car P) Env)
      (sem-h (cdr P) (semstmt (car P) Env))))
 
(define (semstmt S Env)
  (cond
    ;; For "declaration" 
    [ (equal? (car S) 'decl)   (list (cons (list (cadr S) 0) (car Env)) (cadr Env))  ]

    ;; For "assignment"
    [ (equal? (car S) 'assign) (list (updateValue (cadr S)
                                                  (semArith (cadr (cdr S)) (car Env))
                                                  (car Env)) (cadr Env))]
    ;; For "if"
    [ (equal? (car S) 'if)  (removemarker (semIf (semcomplexcond (cadr S) (car Env)) 
                                                 (cadr (cdr S)) ;; sequence of stmts
                                                 (cons (list '$m 0) (car Env)))) ]

    ;; For "while"
    [ (equal? (car S) 'while) (if (semcomplexcond (cadr S) (car Env)) ;; if condition is true
                                  (sem (list (list 'if '(eq 1 1) (cadr (cdr S))) ;; sequence of while statements
                                             S) ;; the while statement
                                       (car Env))
                                  (list (car Env) (cadr Env)))] ;; return the env

    [ (equal? (car S) 'fundecl) (list (cons (list (cadr S) (cadr (cdr S))) (car Env)) (cdr Env)) ]
  
    [ (equal? (car S) 'call)  (semcall (findDef (car (cadr S))
                                                (length (cadr (cadr S)))
                                                (car Env) (car Env))
                                       (semArithList (cadr (cadr S)) (car Env))) ]

    [ (equal? (car S) 'ref) (if (equal? (cadr Env) '(oom))
                                (list (car Env) (cadr Env))
                                (cond
                                  [ (found-free-heap? (cadr Env))
                                    (list (updateValue (cadr S)
                                                       (loc-of-free-heap (cadr Env))
                                                       (car Env)) ;; update the value in the environment
                                          (updateHeapValue (loc-of-free-heap (cadr Env)) (semArith (cadr (cdr S)) (car Env)) (cadr Env)))] ;update heap value
                                  [ else (list (car Env) (list 'oom))]))]
 

    [ (equal? (car S) 'deref) (if (equal? (cadr Env) '(oom))
                                  (list (car Env) (cadr Env))
                                  (cond
                                    [ (isooma? (semArith (cadr (cdr S)) (car Env)) (cadr Env)) (list (car Env) '(ooma))] ;does location in heap exist?
                                    [ (isfma?  (semArith (cadr (cdr S)) (car Env)) (cadr Env)) (list (car Env) '(fma))]  ; is location in heap free? ;     
                                    [ (list
                                       (updateValue (cadr S) (find-hval-from-l (semArith (cadr (cdr S)) (car Env)) (cadr Env)) (car Env))
                                       (cadr Env))]))]
                                
                            
    [ (equal? (car S) 'wref) (if (equal? (cadr Env) '(oom))
                                 (list (car Env) (cadr Env))
                                 (cond
                                   [ (isooma? (semArith (cadr S) (car Env)) (cadr Env)) (list (car Env) '(ooma)) ]
                                   [ (isfma?  (semArith (cadr S) (car Env)) (cadr Env)) (list (car Env) '(fma)) ]
                                   [ else (list (car Env)
                                                (updateHeapValue
                                                 (semArith (cadr S) (car Env))
                                                 (semArith (cadr (cdr S)) (car Env))
                                                 (cadr Env)))]))]

    [ (equal? (car S) 'free) (if (empty? (cdr Env))
                                 (list Env '(ooma))
                                 (cond
                                   [ (empty? (cadr Env)) (list (car Env) (list 'ooma))]
                                   [ (isooma? (semArith (car (cdr S)) (car Env))  (cadr Env)) (list (car Env) '(ooma))] 
                                   [ else (list (car Env) (updateHeapValue (semArith (car (cdr S)) (car Env)) 'free (cadr Env)))]))]

     [ else (list (car Env) (cdr Env))]))

    
(define (isfma? l hp)
   (cond [(empty? hp) false ]
         [(and (equal?  (car (car hp)) l) (equal? (car (cdr (car hp))) 'free)) true]
         [else (isfma? l (cdr hp))]))
 

(define (isooma? l hp)
  (cond [(empty? hp) true ]
        [(equal? (car (car hp)) l) false]
        [else (isooma? l (cdr hp))]))
                                
(define (find-hval-from-l l hp)
  (cond  [(empty? hp) empty]
         [(equal? (car (car hp)) l) (car (cdr (car hp)))]
         [else (find-hval-from-l l (cdr hp))]))

(define (found-free-heap? h)
  (cond [(empty? h) false]
        [(equal? (car (cdr (car h))) 'free) true]
        [else (found-free-heap? (cdr h))]))

(define (updateHeapValue loc val Hp)
  (if (equal? (car (car Hp)) loc)
      (cons (list (car (car Hp))
                  val)
            (cdr Hp))
      (cons (car Hp) (updateHeapValue loc val (cdr Hp)))))

(define (loc-of-free-heap h)
  (if (equal? (car (cdr (car h))) 'free)
      (car (car h))
      (loc-of-free-heap (cdr h))))

(define (findDef fname nParams EnvtoRec Env )
  (if (equal? (car (car EnvtoRec)) fname)      
      (findDef (cadr (car EnvtoRec)) nParams Env Env) ;; search from the top of environment
      (if (and (list? (car (car EnvtoRec)))    
               (equal? (car (car (car EnvtoRec))) fname)
               (equal? (length (cadr (car (car EnvtoRec)))) nParams)) 
          (list (cadr (car (car EnvtoRec)))     
                (cadr (car EnvtoRec))             
                (cons (list '$m 0) Env))          
                                                     
          ;; else continue with the search search in the rest of the environment
           (findDef fname nParams (cdr EnvtoRec) Env))))

(define (genEnv Params Args Env)
  (if (null? Params)
      Env
      (cons (list (car Params) (car Args)) (genEnv (cdr Params) (cdr Args) Env))))

(define (semArithList Exprs Env)
  (if (null? Exprs)
      Exprs
      (cons (semArith (car Exprs) Env) (semArithList (cdr Exprs) Env))))


(define (semcall ParamsDefEnv Args)
  (sem (cadr ParamsDefEnv)        
       (genEnv (car ParamsDefEnv)
               Args
               (cadr (cdr ParamsDefEnv)))))


(define (findValue v Env) 
  (if (null? Env)         
      v
      (if (equal? v (car (car Env)))
          (cadr (car Env))
          (findValue v (cdr Env)))))

(define (semIf condVal SSeq Env)
  (if condVal
      (sem SSeq Env)
      Env))

(define (removemarker Env)
  (if (equal? (car (car Env)) '$m)
      (cdr Env)
      (removemarker (cdr Env))))


(define (updateValue v val Env)
  (if (equal? (car (car Env)) v)
      (cons (list (car (car Env))
                  val)
            (cdr Env))
      (cons (car Env) (updateValue v val (cdr Env)))))
 

(define (semArith Expr Env)
  (cond
    [ (number? Expr)          Expr ]

    [ (symbol? Expr)          (findValue Expr Env) ]
    
    [ (equal? (car Expr) '+)  (+ (semArith (cadr Expr)  Env)
                                 (semArith (cadr (cdr Expr)) Env)) ]
    [ (equal? (car Expr) '-)  (- (semArith (cadr Expr) Env)
                                 (semArith (cadr (cdr Expr)) Env)) ]
    [ (equal? (car Expr) '*)  (* (semArith (cadr Expr) Env)
                                 (semArith (cadr (cdr Expr)) Env)) ]
    [ (equal? (car Expr) '/)  (/ (semArith (cadr Expr) Env)
                                 (semArith (cadr (cdr Expr)) Env)) ]

    [ (equal? (car Expr) 'anonf) (semanon (car (cadr Expr))
                                          (cadr (cadr Expr))
                                          (semArithList (cadr (cdr Expr)) Env)
                                          Env) ]
    ))

(define (semanon ParamList Expr ArgList Env)
  (semArith Expr (genEnv ParamList ArgList Env)))

; semantics of complex conditions
(define (semcomplexcond CCond Env)
  (cond
    [ (equal? (car CCond) 'or)   (or (semcomplexcond (cadr CCond) Env)
                                     (semcomplexcond (cadr (cdr CCond)) Env)) ]
    [ (equal? (car CCond) 'and)   (and (semcomplexcond (cadr CCond) Env)
                                     (semcomplexcond (cadr (cdr CCond)) Env)) ]
    [ (equal? (car CCond) 'not)   (not (semcomplexcond (cadr CCond) Env))
                                      ]
    [ else  (semboolcond CCond Env) ]))  ;; semantics of conditions: lt, gt

(define (semboolcond BCond Env)
  (cond
    [ (equal? (car BCond) 'gt)  (> (semArith (cadr BCond) Env)
                                   (semArith (cadr (cdr BCond)) Env)) ]
    [ (equal? (car BCond) 'lt)  (< (semArith (cadr BCond) Env)
                                   (semArith (cadr (cdr BCond)) Env)) ]
    [ (equal? (car BCond) 'eq)  (equal? (semArith (cadr BCond) Env)
                                        (semArith (cadr (cdr BCond)) Env)) ]))
