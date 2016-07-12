(define has-binding?
  (lambda (env search-var)
    (cond
      ((null? env) #f)
      ((eqv? (caar env) search-var) #t)
      (else
       (has-binding? (cdr env) search-var)))))