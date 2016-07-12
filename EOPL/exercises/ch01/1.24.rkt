(define every-item
    (lambda (pred lst idx)
      (if (>= idx (length lst))
          #t
          (if (pred (list-ref lst idx))
              (every-item pred lst (+ idx 1))
              #f))))
(define every?
  (lambda (pred lst)
    (every-item pred lst 0)))
(every? number? '(a b c 3 e))
(every? number? '(1 2 3 5 4))