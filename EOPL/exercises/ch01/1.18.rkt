(define swapper 
  (lambda (s1 s2 slist)
    (cond ((null? slist)  '())
          ((symbol? slist) slist)
          (else (cons (cond ((eqv? (car slist) s1) s2)
                          ((eqv? (car slist) s2) s1)
                          (else (swapper s1 s2 (car slist))))  (swapper s1 s2 (cdr slist)))))))

(swapper 'a 'd '(a b c d))
(swapper 'a 'd '(a d () c d))
(swapper 'x 'y '((x) y (z (x))))
