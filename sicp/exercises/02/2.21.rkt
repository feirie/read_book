(define (square-list items)
  (if (null? items)
      null
      (cons ((lambda (x) (* x x)) (car items))
            (square-list (cdr items)))))
(define (square-list items)
  (map square items))