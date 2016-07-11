(define count-occurrences
  (lambda (s slist)
    (cond ((null? slist) 0)
          ((symbol? slist) (if (eqv? s slist) 1 0))
          (else (+ (count-occurrences s (car slist))
             (count-occurrences s (cdr slist)))))))
(count-occurrences 'x '((f x) y (((x z) x))))
(count-occurrences 'x '((f x) y (((x z) () x))))
(count-occurrences 'w '((f x) y (((x z) x))))    