(define exists-item
    (lambda (pred lst idx)
      (if (>= idx (length lst))
          #f
          (if (pred (list-ref lst idx))
              #t
              (exists-item pred lst (+ idx 1))))))
(define exists?
  (lambda (pred lst)
    (exists-item pred lst 0)))
(exists? number? '(a b c 3 e))
(exists? number? '(a b c d e))