(define in-S?
  (lambda (n)
    (if (zero? n)
        #t
        (if (>= (- n 3) 0)
            (in-S? (- n 3))
            #f))))

(define list-length
  (lambda (lst)
    (if (null? lst)
        0
        (+ 1 (list-length (cdr lst))))))

(define nth-element
  (lambda (lst n)
    (if (null? lst)
        (fprintf (current-error-port) "nth-element:List too short by ~s elements.~% " (+ n 1))
        (if (zero? n)
            (car lst)
            (nth-element (cdr lst) (- n 1))))))

(define remove-first
  (lambda (s los)
    (if (null? los)
        '()
        (if (eqv? (car los) s)
            (cdr los)
            (cons (car los) (remove-first s (cdr los)))))))                                