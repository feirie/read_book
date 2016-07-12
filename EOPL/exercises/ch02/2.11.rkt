#lang racket
(define report-no-binding-found
  (lambda (search-var)
    (fprintf (current-error-port)  "apply-env:No binding for ~s" search-var)))
(define report-invalid-env
  (lambda (env)
    (fprintf (current-error-port)  "apply-env:Bad environment: ~s" env)))
(define empty-env
  (lambda()
    '()))
(define extend-env
  (lambda (var val env)
    (cons (list (list var) (list val)) env)))
(define apply-item
  (lambda (var-list val-list search-var)
    (if (null? var-list)
        (cons #f '())
        (if (eqv? (car var-list) search-var)
            (cons #t (car val-list))
            (apply-item (cdr var-list) (cdr val-list) search-var)))))
(define apply-env
  (lambda (env search-var)
    (if (null? env)
        (report-no-binding-found search-var)
        (let ((item (apply-item (caar env) (cadar env) search-var)))
          (if (car item) (cdr item)
              (apply-env (cdr env) search-var))))))
(define empty-env?
  (lambda (env)
    (null? env)))
(define has-binding?
  (lambda (env search-var)
    (cond
      ((null? env) #f)
      ((eqv? (caar env) search-var) #t)
      (else
       (has-binding? (cdr env) search-var)))))
(define extend-env*
  (lambda (var-list val-list env)
    (cons (list var-list val-list) env)))
(define e
  (extend-env 'a 7
  (extend-env 'd 6 (empty-env))))
(apply-env e 'd)
(extend-env* '(A B C) '(1 2 3) e)