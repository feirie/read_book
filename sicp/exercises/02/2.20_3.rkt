(define (same-parity first . other)
  (cons first
        (filter-list other
                     (if (even? first)
                         even?
                         odd?)
                     ))
  )
(define (filter-list items even-odd?)
  (if (null? items)
      null
      (if (even-odd? (car items))
          (cons (car items)
                (filter-list (cdr items) even-odd?))
          (filter-list (cdr items) even-odd?))))