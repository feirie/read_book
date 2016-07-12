(define report-no-binding-found
  (lambda (search-var)
    (fprintf (current-error-port)  "apply-env:No binding for ~s" search-var)))
(define report-invalid-env
  (lambda (env)
    (fprintf (current-error-port)  "apply-env:Bad environment: ~s" env)))
(define empty-env
  (lambda()
    (list 'empty-env)))
(define extend-env
  (lambda (var val env)
    (list 'extend-env var val env)))
(define apply-env
  (lambda (env search-var)
    (cond
      ((eqv? (car env) 'empty-env)
       (report-no-binding-found search-var))
      ((eqv? (car env) 'extend-env)
       (let ((saved-var (cadr env))
             (saved-val (caddr env))
             (saved-env (cadddr env)))
         (if (eqv? search-var saved-var)
             saved-val
             (apply-env saved-env search-var))))
      (else
       (report-invalid-env env)))))
(define e
  (extend-env 'd 6 (empty-env)))
(apply-env e 'd)


(define report-no-binding-found
  (lambda (search-var)
    (fprintf (current-error-port)  "apply-env:No binding for ~s" search-var)))
(define empty-env
  (lambda ()
    (lambda (search-var)
      (report-no-binding-found search-var))))
(define extend-env
  (lambda (saved-var saved-val saved-env)
    (lambda (search-var)
      (if (eqv? saved-var search-var)
          saved-val
          (apply-env saved-env search-var)))))
(define apply-env
  (lambda (env search-var)
    (env search-var)))

