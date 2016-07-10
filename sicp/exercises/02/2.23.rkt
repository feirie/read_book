(define (for-each proc items)
  (cond ((not (null? items))
      (begin
        (proc (car items))
        (for-each proc (cdr items))))))