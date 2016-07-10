(define (same-parity first . other)
  (define (same-odd-even? val)
    (if (even? (- first val))
        #t
        #f))
  (define (iter remained-items result)
    (if (null? remained-items)
        result
        (iter (cdr remained-items)
              (if (same-odd-even? (car remained-items))
                  (cons  (car remained-items) result)
                  result))))
  (reverse (iter other (list first))))