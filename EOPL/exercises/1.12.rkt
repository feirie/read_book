(define subst
  (lambda (new old slist)
    (cond ((null? slist)  '())
          ((not (pair? slist)) slist)
          (else (cons (if (eqv? (car slist) old)
                          new
                          (subst new old (car slist)))  (subst new old (cdr slist)))))))