(define invert
  (lambda (lst)
    (if (null? lst)
        '()
        (cons (list (car (cdr (car lst))) (car (car lst)))
              (invert (cdr lst))))))