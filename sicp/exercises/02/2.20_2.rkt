(define (same-parity first . other)
  (cons first
        (filter (if (even? first)
                    even?
                    odd?)
                other)
        ))