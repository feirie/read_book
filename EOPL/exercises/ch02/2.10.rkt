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
    (cons (cons var val) env)))
(define apply-env
  (lambda (env search-var)
    (cond
      ((null? env)
       (report-no-binding-found search-var))
      ((eqv? (caar env) search-var)
       (cdr (car env)))
      (else
       (apply-env (cdr env) search-var)))))
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
    (if (null? var-list)
        env
        (extend-env* (cdr var-list ) (cdr val-list)
                     (extend-env (car var-list) (car val-list) env)))))
(define e
  (extend-env 'a 7
  (extend-env 'd 6 (empty-env))))
(apply-env e 'd)
(extend-env* '(A B C) '(1 2 3) e)